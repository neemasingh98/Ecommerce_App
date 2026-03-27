import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/controllers/sign_in_controller.dart';
import '../../../controllers/forget_password_controller.dart';
import '../../../user_panel/main_screen.dart';
import '../../../utils/app_constant.dart';


class  ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final ForgetPasswordController  forgetPasswordController = Get.put( ForgetPasswordController());

  TextEditingController userEmail = TextEditingController();

  @override
  void dispose() {
    userEmail.dispose(); // Memory leak bata bachna
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color containerColor = Colors.white; // same as WelcomeScreen

    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        backgroundColor: AppConstant.appMainColor,
        appBar: AppBar(
          backgroundColor: AppConstant.appMainColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Forget Password",
            style: TextStyle(color: AppConstant.appSecondaryColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Optional Lottie animation at top
                if (!isKeyboardVisible)
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Lottie.asset(
                      'assets/images/splash_icon.json',
                      fit: BoxFit.contain,
                    ),
                  ),

                SizedBox(height: Get.height/20),

                // Email field
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    controller: userEmail,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email, color: AppConstant.appSecondaryColor),
                    ),
                  ),
                ),

                // SizedBox(height: Get.height/20),
                //
                // // Password field
                // Obx(
                //       () => Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 10),
                //     decoration: BoxDecoration(
                //       color: containerColor,
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     child: TextFormField(
                //       controller: userPassword,
                //       obscureText: isPasswordVisible.value,
                //       decoration: InputDecoration(
                //         border: InputBorder.none,
                //         hintText: "Password",
                //         prefixIcon: Icon(Icons.lock, color: AppConstant.appSecondaryColor),
                //         suffixIcon: GestureDetector(
                //           onTap: () {
                //
                //             isPasswordVisible.value = !isPasswordVisible.value;
                //           },
                //           child: Icon(
                //             isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                //             color: AppConstant.appSecondaryColor,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: Get.height/50),
                // // Forgot password link
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: GestureDetector(
                //     onTap: () {},
                //     child: Text(
                //       "Forgot Password?",
                //       style: TextStyle(
                //           color: AppConstant.appSecondaryColor,fontSize: 15,
                //           fontWeight: FontWeight.bold),
                //     ),
                //   ),
                // ),

                SizedBox(height:  Get.height / 50),

                // Sign In Button


                // Container(
                //   width: Get.width / 3,
                //   height: Get.height / 20,
                //   decoration: BoxDecoration(
                //     color: AppConstant.appStatusBarColor,
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //
                //     child: TextButton(
                Material(
                  borderRadius: BorderRadius.circular(20),
                  color: AppConstant.appStatusBarColor,
                  child: InkWell(
                    onTap: () async {
                      String email = userEmail.text.trim();


                      if (email.isEmpty ) {
                        Get.snackbar(
                          "Error",
                          "Please enter all details",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppConstant.appStatusBarColor,
                          colorText: AppConstant.appSecondaryColor,
                        );
                      }else{
                        String email = userEmail.text.trim();
                        forgetPasswordController.ForgetPasswordMethod(email);
                      }
                    },
                    //   } else {
                    //     UserCredential? userCredential = await signInController
                    //         .signInMethod(email, password);
                    //
                    //     // var userData = await getUserDataController
                    //     //  .getUserData(userCredential!.user!.uid);
                    //
                    //     if (userCredential != null) {
                    //       if (userCredential.user!.emailVerified) {
                    //
                    //         //
                    //         // if (userData[0]['isAdmin'] == true) {
                    //         // Get.snackbar(
                    //         // "Success Admin Login",
                    //         // "login Successfully!",
                    //         // snackPosition: SnackPosition.BOTTOM,
                    //         // backgroundColor: AppConstant.appSecondaryColor,
                    //         // colorText: AppConstant.appTextColor,
                    //         // );
                    //         // Get.offAll(() => AdminMainScreen());
                    //
                    //
                    //         Get.snackbar(
                    //           "Success User Login",
                    //           "login Successfully!",
                    //           snackPosition: SnackPosition.BOTTOM,
                    //           backgroundColor: AppConstant.appStatusBarColor,
                    //           colorText: AppConstant.appTextColor,
                    //         );
                    //         Get.offAll(() => MainScreen());
                    //
                    //       } else {
                    //         Get.snackbar(
                    //           "Error",
                    //           "Please verify your email before login",
                    //           snackPosition: SnackPosition.BOTTOM,
                    //           backgroundColor: AppConstant.appStatusBarColor,
                    //           colorText: AppConstant.appTextColor,
                    //         );
                    //       }
                    //     } else {
                    //       Get.snackbar(
                    //         "Error",
                    //         "Please try again",
                    //         snackPosition: SnackPosition.BOTTOM,
                    //         backgroundColor: AppConstant.appSecondaryColor,
                    //         colorText: AppConstant.appTextColor,
                    //       );
                    //     }
                    //   }
                    // },

                    child: Container(
                      width: Get.width / 2,
                      height: Get.height / 18,
                      alignment: Alignment.center,
                      child: const Text(
                        "Forget ",
                        style: TextStyle(
                            color: AppConstant.appSecondaryColor,fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),

                    // },
                  ),
                ),
                // ),
                // ),
                // ),
                // SizedBox(height:  Get.height / 30),
                // // Sign up link
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text("Don't have an account? ",
                //         style: TextStyle(color: AppConstant.appTextColor,fontSize: 15,fontWeight: FontWeight.bold)),
                //     GestureDetector(
                //       onTap: () => Get.offAll(() => SignUpScreen()),
                //       child: const Text(
                //         "Sign Up",
                //         style: TextStyle(
                //           color: AppConstant.appStatusBarColor,fontSize: 15,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),


              ],

            ),
          ),
        ),

      );
    }

    );
  }
}