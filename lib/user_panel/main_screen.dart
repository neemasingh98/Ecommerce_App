import 'package:badges/badges.dart' as badges;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopping_app/user_panel/notification_screen.dart';
import '../controllers/notification_controller.dart';
import '../screens/screen_ui/welcome_screen.dart';
import '../services/get_service_key.dart';
import '../services/notification_service.dart';
import '../utils/app_constant.dart';
import '../widgets/all_products_widget.dart';
import '../widgets/banners_widget.dart';
import '../widgets/category_widget.dart';
import '../widgets/custom_drawer_widget.dart';
import '../widgets/flash_sale_widget.dart';
import '../widgets/heading_widget.dart';
import 'all_categories_screen.dart';
import 'all_flash_sale_products.dart';
import 'all_products_screen.dart';
import 'cart_screen.dart';
import 'checkout_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
 final NotificationService notificationService = NotificationService();
  final GetServerKey _getServerKey = GetServerKey();

  final NotificationController notificationController =
  Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    // One call to rule them all
    notificationService.init();
    notificationService.getDeviceToken();

    getServiceToken();



  }

  Future<void> getServiceToken() async {
    String serverToken = await _getServerKey.getServerKeyToken();
    print("Server Token => $serverToken");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: DrawerWidget(),

      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor,size: 35),
        backgroundColor: AppConstant.appMainColor,
        title: Text(AppConstant.appMainName,style:TextStyle(color: AppConstant.appTextColor),
        ),

        centerTitle: true,
        actions: [
          Obx(() {
            return badges.Badge(
              badgeContent: Text(
                  "${notificationController.notificationCount.value}",
                  style: TextStyle(color: Colors.white)),
              position: badges.BadgePosition.topEnd(top: 0, end: 3),
              showBadge: notificationController.notificationCount.value > 0,
              child: IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () => Get.to(() => NotificationScreen(message: null,)),
              ),
            );
          }),
         GestureDetector(
           onTap: ()=> Get.to(()=> CartScreen()),

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.shopping_cart,
                color: AppConstant.appTextColor,
              ),
            ),
          ),
        ],
      ),

      drawer: DrawerWidget(),
      body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              child: Column(
                children: [
              SizedBox(
              height: Get.height / 90.0,
              ),

                //banner
                  BannersWidget(),

                //  heading
                  HeadingWidget(
                    headingTitle: "Categories",
                    headingSubTitle: "According to your budget",
                    onTap: () => Get.to(() => AllCategoriesScreen()),
                    buttonText: "See More >",
                  ),

                   CategoriesWidget(),
                  //
                  //heading
                  HeadingWidget(
                    headingTitle: "Flash Sale",
                    headingSubTitle: "According to your budget",
                      onTap: () => Get.to(() => AllFlashSaleProductScreen()),
                    buttonText: "See More >",
                  ),

                  FlashSaleWidget(),

                  // //heading
                  HeadingWidget(
                    headingTitle: "All Products",
                    headingSubTitle: "According to your budget",
                    onTap: () => Get.to(() => AllProductsScreen()),
                    buttonText: "See More >",
                  ),
                  //
                   AllProductsWidget(),
                ],
              ),
            ),
      ),
    );
  }
}
