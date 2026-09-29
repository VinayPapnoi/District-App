import 'package:flutter/material.dart';
import '../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait 3 seconds, then go to login screen
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final logoWidth = (size.width * 0.55).clamp(160.0, 250.0);

    return Scaffold(
      backgroundColor: AppColors.primaryPurple,
      body: Center(
        child: Image.asset(
          'assets/images/district_logo.png',
          width: logoWidth,
        ),
      ),
    );
  }
}