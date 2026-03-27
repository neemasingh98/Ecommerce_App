import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../controllers/google_sign_in_controller.dart';
import '../../../utils/app_constant.dart';
import 'sign_in_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final GoogleSignInController _googleSignInController =
  Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {
    // Define a common white background color for top container & buttons
    final Color containerColor = Colors.white;

    return Scaffold(
      backgroundColor: AppConstant.appMainColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppConstant.appMainColor,
      ),
      body: Column(
        children: [
          // Top Container with Lottie animation
          Container(
            width: double.infinity,
            height: 350,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: containerColor, // same as buttons
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/images/splash_icon.json',
                  height: 250,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Welcome to My App!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Google login button
          Container(
            width: Get.width / 1.2,
            height: 50,
            decoration: BoxDecoration(
              color: containerColor, // same color as top container
              borderRadius: BorderRadius.circular(20),

            ),
            child: TextButton.icon(
              icon: Image.asset(
                'assets/images/google_logo.png',
                width: 35, // small icon to avoid overflow
                height: 35,
              ),
              label: Text(
                "Sign in with Google",
                style: TextStyle(color: AppConstant.appSecondaryColor),
              ),
              onPressed: () {
                _googleSignInController.signInWithGoogle();
              },
            ),
          ),

          const SizedBox(height: 15),

          // Email login button
          Container(
            width: Get.width / 1.2,
            height: 50,
            decoration: BoxDecoration(
              color: containerColor, // same color as top container
              borderRadius: BorderRadius.circular(20),

            ),
            child: TextButton.icon(
              icon: Icon(
                Icons.email,
                size: 30,
              ),
              label: Text(
                "Sign in with Email",
                style: TextStyle(color: AppConstant.appSecondaryColor),
              ),
              onPressed: () {
                Get.to(() => SignInScreen());
              },
            ),
          ),
        ],
      ),
    );
  }
}