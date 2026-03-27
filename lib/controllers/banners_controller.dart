import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BannersController extends GetxController {
  // Observable list to store the image URLs
  RxList<String> bannerUrls = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBannersUrls();
  }

  // Function to fetch data from Firestore
  Future<void> fetchBannersUrls() async {
    try {
      // 1. Fetch all documents from the 'banners' collection
      QuerySnapshot bannersSnapshot =
      await FirebaseFirestore.instance.collection('banners').get();

      if (bannersSnapshot.docs.isNotEmpty) {
        List<String> urls = [];

        // 2. LOOP through each document
        for (var doc in bannersSnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          //
          if (data.containsKey('imageUrl')) {
            urls.add(data['imageUrl'] as String);
          } else {
            // This helps you debug if one specific document is broken
            print("Warning: Document ${doc.id} is missing the 'imageUrl' field!");
          }
        }

        // 4. Update the observable list with the new URLs
        bannerUrls.value = urls;
        print("Successfully loaded ${bannerUrls.length} banners.");
      } else {
        print("No documents found in the 'banners' collection.");
      }
    } catch (e) {
      // If there's a connection error or permission issue, it prints here
      print("Error fetching banners: $e");
    }
  }
}