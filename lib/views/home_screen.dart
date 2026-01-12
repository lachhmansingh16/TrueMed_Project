import 'package:flutter/material.dart';
import 'package:true_med_fyp/constants.dart';
import 'package:true_med_fyp/views/select_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.smokeyGray,
      appBar: AppBar(backgroundColor: AppColors.smokeyGray, toolbarHeight: 0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/app_logo.png', height: 250),
          Text(
            'TrueMed',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColors.navyBlue,
            ),
          ),
          Text(
            'Verify Medicine Authenticity Instantly.',
            style: TextStyle(fontSize: 18, color: AppColors.gray),
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              'Use your camera to scan medicine packaging and detect counterfeits.',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.2),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SelectScreen()),
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: AppColors.navyBlue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined, color: AppColors.white),
                  const SizedBox(width: 10),
                  Text(
                    'Start Verification',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        ],
      ),
    );
  }
}
