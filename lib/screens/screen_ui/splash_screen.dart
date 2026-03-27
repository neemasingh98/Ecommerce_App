import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/app_constant.dart';
import '../../controllers/get_user_data_controller.dart';
import '../../user_panel/main_screen.dart';
import '../admin_panel/admin_main_screen.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),(){
     staylogining(context);
    });
  }
  Future<void> staylogining(BuildContext context) async {
    try {
      if (user != null) {
        final GetUserDataController getUserDataController =
        Get.put(GetUserDataController());
        var userData = await getUserDataController.getUserData(user!.uid);


        //  check empty data
        if (userData == null || userData.isEmpty) {
          //  logout if firestore data missing
          await FirebaseAuth.instance.signOut();

          Get.offAll(() => WelcomeScreen());
          return;
        }


        if (userData[0]['isAdmin'] == true) {
          Get.offAll(() => AdminMainScreen());
        } else {
          Get.offAll(() => MainScreen());
        }
      } else {
        Get.to(() => WelcomeScreen());
      }
    }catch (e) {
      //  crash fallback
      await FirebaseAuth.instance.signOut();
      Get.offAll(() =>  WelcomeScreen());
    }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appMainColor,

      body: Center( // Center everything vertically & horizontally
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white, // optional background for the container
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, //  shrink column to fit content
            children: [
              Lottie.asset(
                'assets/images/splash_icon.json',
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome to Ecommerce App",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
