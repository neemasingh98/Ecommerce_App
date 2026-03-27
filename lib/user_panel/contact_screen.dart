import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_constant.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  // URL Launcher function
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
        backgroundColor: AppConstant.appMainColor,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          const Center(
            child: Icon(Icons.support_agent, size: 100, color: Colors.blueGrey),
          ),
          const SizedBox(height: 20),
          const Text(
            "How can we help you?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "If you have any issues with your order or any feedback, please reach out to us.",
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(),

          // Email Option
          ListTile(
            leading: const Icon(Icons.email, color: Colors.red),
            title: const Text("Email Us"),
            subtitle: const Text("support@unique.com"),
            onTap: () => _launchUrl("mailto:support@unique.com"),
          ),

          // Call Option
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.green),
            title: const Text("Call Us"),
            subtitle: const Text("+977-98XXXXXXXX"),
            onTap: () => _launchUrl("tel:+97798XXXXXXXX"),
          ),

          // WhatsApp Option
          ListTile(
            leading: const Icon(Icons.message, color: Colors.teal),
            title: const Text("WhatsApp"),
            subtitle: const Text("Chat with us on WhatsApp"),
            onTap: () => _launchUrl("https://wa.me/97798XXXXXXXX"),
          ),

          // Website Option
          ListTile(
            leading: const Icon(Icons.web, color: Colors.blue),
            title: const Text("Our Website"),
            subtitle: const Text("www.unique-shopping.com"),
            onTap: () => _launchUrl("https://www.google.com"),
          ),
        ],
      ),
    );
  }
}