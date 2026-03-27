import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shopping_app/controllers/sign_in_controller.dart';
import 'package:shopping_app/screens/screen_ui/sign_up_screen.dart';
import '../../../controllers/get_user_data_controller.dart';
import '../../../user_panel/main_screen.dart';
import '../../../utils/app_constant.dart';
import '../admin_panel/admin_main_screen.dart';
import 'forget_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController signInController = Get.put(SignInController());
  final GetUserDataController getUserDataController = Get.put(GetUserDataController());

  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  RxBool isPasswordVisible = true.obs;

  @override
  Widget build(BuildContext context) {
    const Color containerColor = Colors.white;

    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        backgroundColor: AppConstant.appMainColor,
        appBar: AppBar(
          backgroundColor: AppConstant.appMainColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Sign In",
            style: TextStyle(color: AppConstant.appSecondaryColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Lottie Animation
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

                SizedBox(height: Get.height / 20),

                // Email Field
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
                      prefixIcon: Icon(Icons.email, color: AppConstant.appSecondaryColor),
                    ),
                  ),
                ),

                SizedBox(height: Get.height / 30),

                // Password Field
                Obx(
                      () => Container(
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
                        prefixIcon: Icon(Icons.lock, color: AppConstant.appSecondaryColor),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            isPasswordVisible.value = !isPasswordVisible.value;
                          },
                          child: Icon(
                            isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                            color: AppConstant.appSecondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Get.height / 40),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Get.to(() => const ForgetPasswordScreen()),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: AppConstant.appSecondaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Get.height / 30),

                // Sign In Button
                Material(
                  borderRadius: BorderRadius.circular(20),
                  color: AppConstant.appStatusBarColor,
                  child: InkWell(
                    onTap: () async {
                      String email = userEmail.text.trim();
                      String password = userPassword.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Please enter all details",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                      } else {
                        // 1. Authenticate with Firebase
                        UserCredential? userCredential = await signInController.signInMethod(email, password);

                        if (userCredential != null) {
                          // 2. Check Email Verification
                          if (userCredential.user!.emailVerified) {

                            // 3. Fetch Data from Firestore
                            var userData = await getUserDataController.getUserData(userCredential.user!.uid);

                            if (userData.isNotEmpty) {
                              // 4. Role-based Redirection
                              if (userData[0]['isAdmin'] == true) {
                                Get.snackbar(
                                  "Success Admin",
                                  "Login Successful!",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                                Get.offAll(() => const AdminMainScreen());
                              } else {
                                Get.snackbar(
                                  "Success User",
                                  "Login Successful!",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppConstant.appStatusBarColor,
                                  colorText: AppConstant.appSecondaryColor,
                                );
                                Get.offAll(() => const MainScreen());
                              }
                            } else {
                              Get.snackbar("Error", "User data not found.");
                            }
                          } else {
                            // If Email not verified
                            Get.snackbar(
                              "Verification Required",
                              "Please verify your email before login.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appStatusBarColor,
                              colorText: AppConstant.appSecondaryColor,
                            );
                            await FirebaseAuth.instance.signOut();
                          }
                        }
                      }
                    },
                    child: Container(
                      width: Get.width / 2,
                      height: Get.height / 18,
                      alignment: Alignment.center,
                      child: const Text(
                        "SIGN IN",
                        style: TextStyle(
                          color: AppConstant.appSecondaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Get.height / 30),

                // Sign Up Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: AppConstant.appTextColor, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () => Get.offAll(() => const SignUpScreen()),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: AppConstant.appStatusBarColor,
                          fontSize: 15,
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
    });
  }
}