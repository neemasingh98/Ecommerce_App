import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shopping_app/screens/screen_ui/splash_screen.dart';
import 'package:shopping_app/services/notification_service.dart';
import 'firebase_options.dart';


// Background Handler
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message: ${message.messageId}");
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 1. Firebase Initialize
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // 2. Background handler register
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Subscribe the user to a specific notification topic
    subscribe();
    // Initialize the local notification service and listeners
   NotificationService().init();
  }



  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      //  Link the key here
      navigatorKey: NotificationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      home: SplashScreen(),
      // Initialize EasyLoading for showing progress HUDs globally
      builder: EasyLoading.init(),
    );
  }
// Helper method to subscribe the device to a Firebase topic
  void subscribe() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    messaging.subscribeToTopic('all');
    print("Subscribe to all topic successfully");
  }
}
