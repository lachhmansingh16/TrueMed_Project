import 'package:flutter/material.dart';
import '../constants.dart';

class ResultsScreen extends StatelessWidget {
  final bool isAuthentic;
  final double confidence;
  final String verdictText;

  const ResultsScreen({
    super.key,
    required this.isAuthentic,
    required this.confidence,
    required this.verdictText,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the visuals based on the verdict
    final Color resultColor = isAuthentic ? Colors.green.shade700 : Colors.red.shade700;
    final IconData resultIcon = isAuthentic ? Icons.check_circle_outline : Icons.highlight_off;
    final String resultTitle = isAuthentic ? "AUTHENTIC" : "COUNTERFEIT";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Result', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.navyBlue,
        automaticallyImplyLeading: false, // Disables the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            // Large icon for immediate visual feedback
            Icon(resultIcon, color: resultColor, size: 150),
            const SizedBox(height: 24),

            // The main verdict text
            Text(
              resultTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: resultColor,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),

            // The confidence score, only shown if the verdict is not inconclusive
            if (verdictText.startsWith("Product"))
              Text(
                "Confidence: ${confidence.toStringAsFixed(2)}%",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, color: AppColors.gray),
              ),
            
            // A more detailed explanation for the user
            const SizedBox(height: 8),
             Text(
                verdictText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: AppColors.gray),
              ),

            const Spacer(),

            // Button to return to the home screen
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navyBlue,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // This will pop all screens until it gets back to the very first one
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Scan Another Medicine', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

