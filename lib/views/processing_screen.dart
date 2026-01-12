import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:true_med_fyp/constants.dart';
import 'package:true_med_fyp/views/results_screen.dart';
import 'scan_screen.dart'; // For the Medicine class

class ProcessingScreen extends StatefulWidget {
  final Medicine medicine;
  final XFile testImageFile;

  const ProcessingScreen({
    super.key,
    required this.medicine,
    required this.testImageFile,
  });

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  String _status = "Connecting to server...";

  // --- ⚠️ UPDATE THIS URL EVERY TIME YOU RESTART NGROK ---
  // final String apiUrl = "https://granolithic-botryomycotic-laney.ngrok-free.dev/verify";
  final String apiUrl = "https://granolithic-botryomycotic-laney.ngrok-free.dev/verify";

  @override
  void initState() {
    super.initState();
    // Start the API call as soon as the screen loads
    _verifyMedicineWithApi();
  }

  Future<void> _verifyMedicineWithApi() async {
    try {
      setState(() => _status = "Uploading image for analysis...");

      // 1. Create the Multipart Request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // 2. Add the medicine name (must match the filename on server exactly)
      request.fields['medicine_name'] = widget.medicine.name;

      // 3. Add the image file
      request.files.add(
          await http.MultipartFile.fromPath('file', widget.testImageFile.path)
      );

      // 4. Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        setState(() => _status = "Processing results...");

        // 5. Parse JSON Response
        var data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          String verdict = data['verdict']; // "AUTHENTIC" or "COUNTERFEIT"
          bool isAuthentic = verdict == "AUTHENTIC";

          // Calculate a simple confidence percentage based on passed checks
          int passed = data['passed_rois'];
          int total = data['total_rois'];
          double confidence = total > 0 ? (passed / total) * 100 : 0.0;

          String detailText = "Passed $passed out of $total security checks.";

          _navigateToResults(isAuthentic, confidence, detailText);
        } else {
          _showError("Server Error: ${data['message']}");
        }
      } else {
        _showError("Connection Failed: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Network Error: $e");
    }
  }

  void _navigateToResults(bool isAuth, double conf, String text) {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          isAuthentic: isAuth,
          confidence: conf,
          verdictText: text,
        ),
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.white),
            const SizedBox(height: 32),
            Text(
              _status,
              style: const TextStyle(color: AppColors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Please wait while our AI verifies the packaging features...",
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}