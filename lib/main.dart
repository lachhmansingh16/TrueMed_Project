import 'package:flutter/material.dart';
import 'package:true_med_fyp/constants.dart';
import 'package:true_med_fyp/views/home_screen.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: ${e.code}\nError Message: ${e.description}');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TrueMed App',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.smokeyGray,
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.navyBlue, // Change to your desired color
          selectionColor: AppColors.navyBlue.withAlpha(100),
          selectionHandleColor: AppColors.navyBlue,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
