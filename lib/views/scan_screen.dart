import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:true_med_fyp/constants.dart';
import 'processing_screen.dart';

// Your existing Medicine class
class Medicine {
  final String name;
String get imagePath {
  final filename = '${name}_authentic.jpg';
  return 'assets/references/$filename';
}
  const Medicine({required this.name});
}

class ScanScreen extends StatefulWidget {
  final Medicine medicine;
  const ScanScreen({super.key, required this.medicine});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  // This will hold the file of the image the user picks
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // This function handles picking an image from either camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  // This function will be called when the user presses "Verify"
  void _startVerification() {
    if (_imageFile == null) return;
    
    // Navigate to the processing screen, passing the necessary data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProcessingScreen(
          medicine: widget.medicine,
          testImageFile: _imageFile!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan: ${widget.medicine.name}', style: const TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.navyBlue,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // This is the main display area for the image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.gray.withOpacity(0.5), width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: _imageFile == null
                      ? const _PlaceholderView()
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(_imageFile!.path),
                            fit: BoxFit.contain, // Use contain to see the whole image
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons for Camera and Gallery
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.photo_camera,
                  label: 'Take Photo',
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                _ActionButton(
                  icon: Icons.photo_library,
                  label: 'From Gallery',
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // The main "Verify" button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navyBlue,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                disabledBackgroundColor: AppColors.gray.withOpacity(0.5),
              ),
              onPressed: _imageFile == null ? null : _startVerification,
              child: const Text('VERIFY AUTHENTICITY', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Helper Widgets for a cleaner UI ---

class _PlaceholderView extends StatelessWidget {
  const _PlaceholderView();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_search, size: 96, color: AppColors.gray.withOpacity(0.7)),
        const SizedBox(height: 16),
        const Text(
          'Use the buttons below to select an image for verification',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: AppColors.gray),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 48, color: AppColors.navyBlue),
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.gray.withOpacity(0.1),
            padding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: AppColors.navyBlue)),
      ],
    );
  }
}

