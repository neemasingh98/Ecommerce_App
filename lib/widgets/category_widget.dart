import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../models/categories_model.dart';
import '../user_panel/single_category_products_screen.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('categories').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error"),
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
            child: Text("No category found!"),
          );
        }

        if (snapshot.data != null) {
          return Container(
            // 1. Increased parent height slightly to allow scrolling without clipping
            height: Get.height / 5.0,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,// Horizontal scroll enabled
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              itemBuilder: (context, index) {
                CategoriesModel categoriesModel = CategoriesModel(
                  categoryId: snapshot.data!.docs[index]['categoryId'],
                  categoryImg: snapshot.data!.docs[index]['categoryImg'],
                  categoryName: snapshot.data!.docs[index]['categoryName'],
                  createdAt: snapshot.data!.docs[index]['createdAt'],
                  updatedAt: snapshot.data!.docs[index]['updatedAt'],
                );
                  // return  Row(
                  // children: [
                 return   GestureDetector(
                      onTap: ()=>Get.to(() => AllSingleCategoryProductsScreen(
                          categoryId: categoriesModel.categoryId)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                         // width: Get.width / 4.0,
                          child: FillImageCard(
                            borderRadius: 20.0,
                            width: Get.width / 4.0,
                            heightImage: Get.height / 9.5,// Image height

                            contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                            imageProvider: CachedNetworkImageProvider(
                              categoriesModel.categoryImg,
                            ),
                            // 3. MINIMIZED Title area
                            title: Center(
                              child: Text(
                                categoriesModel.categoryName,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    // ),
                  // ],
                );
              },
            ),
          );
        }

        return Container();
      },
    );
  }
}