import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../screens/screen_ui/sign_in_screen.dart';
import '../utils/app_constant.dart';

class ForgetPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  Future<void>  ForgetPasswordMethod(
      String userEmail,
      ) async {
    try {
      // 1. Start Loading
      EasyLoading.show(status: "Sending reset link...");
      // 2. Firebase Action
      await _auth.sendPasswordResetEmail(email: userEmail);
      // 3. Stop Loading
      EasyLoading.dismiss();
      // 4. Success Feedback (Large Text Style)
      Get.snackbar(
        "",
        "",
        titleText: Text(
          "Reset Link Sent",
          style: TextStyle(
            fontSize: 20, // Title ko size yaha bata thulo banaunu hos
            fontWeight: FontWeight.bold,
            color: AppConstant.appSecondaryColor,
          ),
        ),
       // "Request Sent Successfully",
       // "Password resent link sent to $userEmail",snackStyle: SnackStyle.FLOATING,
        messageText: Text(
          "Password reset link has been sent to $userEmail. Please check your inbox.if not found,check your Spam folder,",
          style: TextStyle(
            fontSize: 16,
            color: AppConstant.appSecondaryColor,
          ),
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appStatusBarColor,
        colorText: AppConstant.appSecondaryColor,
        snackStyle: SnackStyle.FLOATING,
        duration: const Duration(seconds: 5),
      );
      // 5. Navigate back to Login
      Get.offAll(() => SignInScreen());
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {

      String errorMsg = "";

      // Firebase specific error codes handle
      if (e.code == 'user-not-found') {
        errorMsg = "This email is not registered with us.";
      } else if (e.code == 'invalid-email') {
        errorMsg = "The email address is badly formatted.";
      } else if (e.code == 'too-many-requests') {
        errorMsg = "Too many requests. Please try again later.";
      } else {
        // Fallback to Firebase's default
        errorMsg = e.message.toString();
      }
      Get.snackbar(
        "Error",
        "$e ",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appMainColor,
        colorText: AppConstant.appTextColor,
      );
    }
  }
}
