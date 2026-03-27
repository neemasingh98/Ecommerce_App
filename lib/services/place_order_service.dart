import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';


import '../models/order_model.dart';
import '../user_panel/main_screen.dart';
import '../utils/app_constant.dart';
import 'generate_order_id_service.dart';
import 'notification_service.dart';
import 'send_notification_service.dart';

void placeOrder({
  required BuildContext context,
  required String customerName,
  required String customerPhone,
  required String customerAddress,
  required String customerDeviceToken,
  required String serverKey,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  NotificationService notificationService = NotificationService();
  EasyLoading.show(status: "Please Wait..");
  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrders')
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;

        String orderId = generateOrderId();

        OrderModel cartModel = OrderModel(
          productId: data['productId'],
          categoryId: data['categoryId'],
          productName: data['productName'],
          categoryName: data['categoryName'],
          salePrice: data['salePrice'],
          fullPrice: data['fullPrice'],
          productImages: data['productImages'],
          deliveryTime: data['deliveryTime'],
          isSale: data['isSale'],
          productDescription: data['productDescription'],
          createdAt: DateTime.now(),
          updatedAt: data['updatedAt'],
          productQuantity: data['productQuantity'],
          productTotalPrice: double.parse(data['productTotalPrice'].toString()),
          customerId: user.uid,
          status: false,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          customerDeviceToken: customerDeviceToken,
        );

        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .set(
            {
              'uId': user.uid,
              'customerName': customerName,
              'customerPhone': customerPhone,
              'customerAddress': customerAddress,
              'customerDeviceToken': customerDeviceToken,
              'orderStatus': false,
              'createdAt': DateTime.now()
            },
          );

          //upload orders
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .collection('confirmOrders')
              .doc(orderId)
              .set(cartModel.toMap());

          //delete cart products
          await FirebaseFirestore.instance
              .collection('cart')
              .doc(user.uid)
              .collection('cartOrders')
              .doc(cartModel.productId.toString())
              .delete()
              .then((value) {
            print('Delete cart Products $cartModel.productId.toString()');
          });
        }
        // save notification
        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(user.uid)
            .collection('notifications')
            .doc()
            .set(
          {
            'title': "Order Successfully placed ${cartModel.productName}",
            'body': cartModel.productDescription,
            'isSeen': false,
            'createdAt': DateTime.now(),
            'image': cartModel.productImages,
            'fullPrice': cartModel.fullPrice,
            'salePrice': cartModel.salePrice,
            'isSale': cartModel.isSale,
            'productId': cartModel.productId,
          },
        );
      }

      //sent notification
      await SendNotificationService.sendNotificationUsingApi(
        token: "",
        title: "Order Successfully placed",
        body: "Hello $customerName, your order is being processed.",
        data: {
          "screen": "notification",
        },
      );

      print("Order Confirmed");
      Get.snackbar(
        "Order Confirmed",
        "Thank you for your order!",
        backgroundColor: AppConstant.appMainColor,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );

      EasyLoading.dismiss();
      Get.offAll(() => MainScreen());
    } catch (e) {
      print("error $e");
    }
  }
}