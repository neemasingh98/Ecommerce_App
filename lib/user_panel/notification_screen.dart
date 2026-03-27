import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import '../utils/app_constant.dart';

class NotificationScreen extends StatefulWidget {
  final RemoteMessage? message;
  const NotificationScreen({super.key, required this.message});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "Notifications",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .doc(user!.uid)
            .collection('notifications')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading notifications"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Inbox is empty"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index];
              String docId = data.id; // Unique ID for THIS specific message
              bool isSeen = data['isSeen'] ?? false;

              return SwipeActionCell(
                key: ObjectKey(docId),
                trailingActions: [
                  SwipeAction(
                    title: "Delete",
                    onTap: (CompletionHandler handler) async {
                      // THIS deletes ONLY the swiped message
                      await FirebaseFirestore.instance
                          .collection('notifications')
                          .doc(user!.uid)
                          .collection('notifications')
                          .doc(docId) // Points to only one document
                          .delete();

                      await handler(true); // Removes only this row from UI
                    },
                    color: Colors.red,
                  ),
                ],
                child: GestureDetector(
                  onTap: () async {
                    // Mark as seen when clicked
                    await FirebaseFirestore.instance
                        .collection('notifications')
                        .doc(user!.uid)
                        .collection('notifications')
                        .doc(docId)
                        .update({"isSeen": true});
                  },
                  child: Card(
                    elevation: isSeen ? 0 : 2,
                    color: isSeen ? Colors.grey.shade50 : Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSeen ? Colors.grey : AppConstant.appMainColor,
                        child: Icon(
                          isSeen ? Icons.mark_email_read : Icons.email,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        data['title'],
                        style: TextStyle(
                          fontWeight: isSeen ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(data['body']),
                      // Optional: Single delete button on the right
                      trailing: IconButton(
                        icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                        onPressed: () async {
                          // Deletes ONLY this one message when 'X' is clicked
                          await FirebaseFirestore.instance
                              .collection('notifications')
                              .doc(user!.uid)
                              .collection('notifications')
                              .doc(docId)
                              .delete();
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}