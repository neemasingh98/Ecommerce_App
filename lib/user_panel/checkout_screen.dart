import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../controllers/cart_price_controller.dart';
import '../controllers/get_customer_device_token_controller.dart';
import '../models/cart_model.dart';
import '../services/get_service_key.dart';
import '../services/place_order_service.dart';
import '../utils/app_constant.dart';


class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
  Get.put(ProductPriceController());
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String? customerToken;
  String? name;
  String? phone;
  String? address;
  String? accessToken; // To store the token locally

  final Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    // Initialize Razorpay listeners once inside initState
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text('Checkout Screen'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 5,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No products found!"),
            );
          }

          if (snapshot.data != null) {
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  CartModel cartModel = CartModel(
                    productId: productData['productId'],
                    categoryId: productData['categoryId'],
                    productName: productData['productName'],
                    categoryName: productData['categoryName'],
                    salePrice: productData['salePrice'],
                    fullPrice: productData['fullPrice'],
                    productImages: productData['productImages'],
                    deliveryTime: productData['deliveryTime'],
                    isSale: productData['isSale'],
                    productDescription: productData['productDescription'],
                    createdAt: productData['createdAt'],
                    updatedAt: productData['updatedAt'],
                    productQuantity: productData['productQuantity'],
                    productTotalPrice: double.parse(
                        productData['productTotalPrice'].toString()),
                  );

                  //calculate price
                  productPriceController.fetchProductPrice();
                  return SwipeActionCell(
                    key: ObjectKey(cartModel.productId),
                    trailingActions: [
                      SwipeAction(
                        title: "Delete",
                        forceAlignmentToBoundary: true,
                        performsFirstActionWithFullSwipe: true,
                        onTap: (CompletionHandler handler) async {
                          print('deleted');

                          await FirebaseFirestore.instance
                              .collection('cart')
                              .doc(user!.uid)
                              .collection('cartOrders')
                              .doc(cartModel.productId)
                              .delete();
                        },
                      )
                    ],
                    child: Card(
                      elevation: 5,
                      color: AppConstant.appTextColor,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppConstant.appMainColor,
                          backgroundImage:
                          NetworkImage(cartModel.productImages[0]),
                        ),
                        title: Text(cartModel.productName),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(cartModel.productTotalPrice.toString()),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Container();
        },
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
                  () => Text(
                " Total ${productPriceController.totalPrice.value.toStringAsFixed(1)} : PKR",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                child: Container(
                  width: Get.width / 2.0,
                  height: Get.height / 18,
                  decoration: BoxDecoration(
                    color: AppConstant.appSecondaryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: Text(
                      "Confirm Order",
                      style: TextStyle(color: AppConstant.appTextColor),
                    ),

                    onPressed: () async {
                      try {
                      GetServerKey getServerKey = GetServerKey();
                      //  getServerKeyToken
                       accessToken = await getServerKey.getServerKeyToken();
                      print( "FCM Access Token: $accessToken");
                      showCustomBottomSheet();
                       } catch (e) {
                         print("Error getting Server Key: $e");
                         }
                      },

                  ),

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Form Fields ...
              TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
              TextField(controller: phoneController, decoration: InputDecoration(labelText: "Phone"), keyboardType: TextInputType.phone),
              TextField(controller: addressController, decoration: InputDecoration(labelText: "Address")),
              SizedBox(height: 20),


              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //       horizontal: 20.0, vertical: 20.0),
              //   child: Container(
              //     height: 55.0,
              //     child: TextFormField(
              //       controller: nameController,
              //       decoration: InputDecoration(
              //         labelText: 'Name',
              //         contentPadding: EdgeInsets.symmetric(
              //           horizontal: 10.0,
              //         ),
              //         hintStyle: TextStyle(
              //           fontSize: 12,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //       horizontal: 20.0, vertical: 20.0),
              //   child: Container(
              //     height: 55.0,
              //     child: TextFormField(
              //       controller: phoneController,
              //       textInputAction: TextInputAction.next,
              //       keyboardType: TextInputType.phone,
              //       decoration: InputDecoration(
              //         labelText: 'Phone',
              //         contentPadding: EdgeInsets.symmetric(
              //           horizontal: 10.0,
              //         ),
              //         hintStyle: TextStyle(
              //           fontSize: 12,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //       horizontal: 20.0, vertical: 20.0),
              //   child: Container(
              //     height: 55.0,
              //     child: TextFormField(
              //       controller: addressController,
              //       decoration: InputDecoration(
              //         labelText: 'Address',
              //         contentPadding: EdgeInsets.symmetric(
              //           horizontal: 10.0,
              //         ),
              //         hintStyle: TextStyle(
              //           fontSize: 12,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.appMainColor,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                ),
                onPressed: () async {
                  if (nameController.text != '' &&
                      phoneController.text != '' &&
                      addressController.text != '') {
                    name = nameController.text.trim();
                    phone = phoneController.text.trim();
                    address = addressController.text.trim();
                    customerToken = await getCustomerDeviceToken();

                    placeOrder(
                      context: context,
                      customerName: name!,
                      customerPhone: phone!,
                      customerAddress: address!,
                      customerDeviceToken: customerToken!,
                      serverKey: accessToken!,
                    );
                    Get.back(); // Close bottom sheet

                    // var options = {
                    //   'key': 'Your key',
                    //   'amount': 1000,
                    //   'currency': 'USD',
                    //   'name': 'Acme Corp.',
                    //   'description': 'Fine T-Shirt',
                    //   'prefill': {
                    //     'contact': '8888888888',
                    //     'email': 'test@razorpay.com'
                    //   }
                    // };

                    // _razorpay.open(options);
                  } else {
                    Get.snackbar("Error", "Please fill all details", backgroundColor: Colors.red, colorText: Colors.white);
                  }
                },
                child: Text(
                  "Place Order",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 6,
    );
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    //place order series
    // FIXED: Added serverKey parameter
    placeOrder(
      context: context,
      customerName: name!,
      customerPhone: phone!,
      customerAddress: address!,
      customerDeviceToken: customerToken!,
      serverKey: accessToken!,
    );

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("Payment Failed", response.message ?? "Unknown Error");
  // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    _razorpay.clear();
  }
}
