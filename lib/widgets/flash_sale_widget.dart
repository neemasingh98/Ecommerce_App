import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../models/categories_model.dart';
import '../models/product_model.dart';
import '../user_panel/product_details_screen.dart';
import '../user_panel/single_category_products_screen.dart';
import '../utils/app_constant.dart';

class FlashSaleWidget extends StatelessWidget {
  const FlashSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('products').where('isSale', isEqualTo: true).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error:${snapshot.error}"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: Get.height / 5,// Adjusted height for loader
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
            // 1. Increased parent height slightly to allow scrolling without clipping
            height: Get.height / 4.5,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,// Horizontal scroll enabled
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                ProductModel productModel = ProductModel(

                  productId: productData['productId'],
                  categoryId: productData['categoryId'],
                  productName: productData['productName'],
                  categoryName: productData['categoryName'],
                  salePrice: productData ['salePrice'],
                  fullPrice: productData ['fullPrice'],
                  productImages: productData['productImages'],
                  deliveryTime: productData['deliveryTime'],
                  isSale: productData['isSale'],
                  productDescription: productData['productDescription'],
                  createdAt: productData['createdAt'],
                  updatedAt: productData['updatedAt'],
                );
                //   categoryId: snapshot.data!.docs[index]['categoryId'],
                //   categoryImg: snapshot.data!.docs[index]['categoryImg'],
                //   categoryName: snapshot.data!.docs[index]['categoryName'],
                //   createdAt: snapshot.data!.docs[index]['createdAt'],
                //   updatedAt: snapshot.data!.docs[index]['updatedAt'],
                // );
                 return  Row(
                 children: [
                 GestureDetector(
                  onTap: ()
                  => Get.to(() =>   ProductDetailsScreen(productModel: productModel)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: Get.width / 4.0,
                      child: FillImageCard(
                        borderRadius: 20.0,
                        width: Get.width / 3.5,
                        heightImage: Get.height / 10.0,
                        // Image height

                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 2, vertical: 4),
                        imageProvider: CachedNetworkImageProvider(

                          productModel.productImages[0],
                        ),
                        // 3. MINIMIZED Title area
                        title: Center(
                          child: Text(
                            productModel.productName,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        footer: Row(
                          children: [Text("Rs ${productModel.salePrice}",
                          ),
                        SizedBox(
                          width: 2.0,
                        ),
                            Text(
                              "${productModel.fullPrice}",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: AppConstant.appMainColor,fontStyle:FontStyle.normal,
                                decoration: TextDecoration.lineThrough,decorationColor: AppConstant.appMainColor, // 👈 line color
                                decorationThickness: 2,
                              ),
                            ),
                          ],
                        ),

                      ),
                    ),
                  ),
               ),
               ]
                );
              }
              ),
          );
        }

        return Container();
      },
    );
  }
}