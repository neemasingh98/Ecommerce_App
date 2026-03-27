import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_app/controllers/banners_controller.dart';

class BannersWidget extends StatefulWidget {
  const BannersWidget({super.key});

  @override
  State<BannersWidget> createState() => _BannersWidgetState();
}

class _BannersWidgetState extends State<BannersWidget> {
  // Initialize the controller
   final CarouselController carouselController = CarouselController();
  final BannersController _bannersController = Get.put(BannersController());
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Obx((){
        return CarouselSlider(
            items: _bannersController.bannerUrls.map(
                    (imageUrl) => ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) => ColoredBox(
                          color: Colors.white,
                          child: Center(
                            child: CupertinoActivityIndicator(),
                          ),
                ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            ),
            ).toList(),
            options: CarouselOptions(
              height: 190, // Set a fixed height to make all banners equal
              viewportFraction: 0.9, // Shows a little bit of the next/prev image
              enlargeCenterPage: true, // Makes the middle one stand out

          autoPlay: true,
          aspectRatio: 16/9,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),

        ),
        );
      }),
    );
  }
}
