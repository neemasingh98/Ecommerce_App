import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../controllers/sign_up_controller.dart';
import '../../../utils/app_constant.dart';
import 'sign_in_screen.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController signUpController = Get.put(SignUpController());
  TextEditingController username = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userCity = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  RxBool isPasswordVisible = true.obs;

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
            "Sign Up",
            style: TextStyle(color: AppConstant.appSecondaryColor),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Optional Lottie animation at top
                if (!isKeyboardVisible)
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Lottie.asset(
                      'assets/images/splash_icon.json',
                      fit: BoxFit.contain,
                    ),
                  ),

                SizedBox(height: Get.height / 30),

                // Username
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Username",
                      prefixIcon: Icon(Icons.person, color: AppConstant
                          .appSecondaryColor),
                    ),
                  ),
                ),

                SizedBox(height: Get.height / 40),

                // Phone
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    controller: userPhone,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Phone",
                      prefixIcon: Icon(Icons.phone, color: AppConstant
                          .appSecondaryColor),
                    ),
                  ),
                ),

                SizedBox(height: Get.height / 40),

                // Email
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    controller: userEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email, color: AppConstant
                          .appSecondaryColor),
                    ),
                  ),
                ),

                SizedBox(height: Get.height / 40),

                // City
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    controller: userCity,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "City",
                      prefixIcon: Icon(Icons.location_pin, color: AppConstant
                          .appSecondaryColor),
                    ),
                  ),
                ),

                SizedBox(height: Get.height / 40),

                // Password
                Obx(
                      () =>
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: containerColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          controller: userPassword,
                          obscureText: isPasswordVisible.value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock,
                                color: AppConstant.appSecondaryColor),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                isPasswordVisible.value =
                                !isPasswordVisible.value;
                              },
                              child: Icon(
                                isPasswordVisible.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppConstant.appSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                ),

                SizedBox(height: Get.height / 40),

                // Sign Up Button
                Container(
                  width: Get.width / 5,
                  height: Get.height / 20,
                  decoration: BoxDecoration(
                    color: AppConstant.appStatusBarColor,
                    borderRadius: BorderRadius.circular(20),
                  ),


                  //  SIGN UP BUTTON (FIXED)


                    child: TextButton(
                      onPressed: () async {
                        //  NotificationService notificationService = NotificationService();
                        String name = username.text.trim();
                        String email = userEmail.text.trim();
                        String phone = userPhone.text.trim();
                        String city = userCity.text.trim();
                        String password = userPassword.text.trim();
                        String? userDeviceToken = ''; //await notificationService.getDeviceToken();

                        if (name.isEmpty || email.isEmpty || phone.isEmpty || city
                            .isEmpty || password.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please enter all details",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appStatusBarColor,
                            colorText: AppConstant.appSecondaryColor,
                          );
                        } else {
                          EasyLoading.show(status: "Please wait...");
                          UserCredential? userCredential = await signUpController
                              .signUpMethod(
                            name,
                            email,
                            phone,
                            city,
                            password,
                            userDeviceToken,
                          );
                          //  Dismiss loading
                          EasyLoading.dismiss();

                          if (userCredential != null) {
                            Get.snackbar(
                              "Verification email sent.",
                              "Please check your email.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appStatusBarColor,
                              colorText: AppConstant.appSecondaryColor,
                            );

                            FirebaseAuth.instance.signOut();
                            Get.offAll(() => SignInScreen());
                          }
                        }
                      },

                      // padding: EdgeInsets.symmetric(horizontal: 8), // inner padding for text
                      //   child: Center(
                      //     child: Text(
                      //       'SIGN UP',
                      //       style: TextStyle(color: AppConstant.appSecondaryColor,fontWeight: FontWeight.bold,fontSize: 12,
                      //       ),
                      //     ),
                      //   ),
                      // ),


                       child: Container(
                         width: Get.width / 5,
                         height: Get.height /20,

                         alignment: Alignment.center,
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(color: AppConstant.appSecondaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ),



                SizedBox(height: Get.height / 40),

                // Sign In link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(
                          color: AppConstant.appSecondaryColor, fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () => Get.offAll(() => SignInScreen()),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: AppConstant.appSecondaryColor, fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),


              ],

            ),
          ),
        ),

      );
    }
    );
  }
}