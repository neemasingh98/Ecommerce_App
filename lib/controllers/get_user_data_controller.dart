import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetUserDataController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUserData(String uId) async {
    final QuerySnapshot<Map<String, dynamic>> userData = await _firestore
        .collection('users')
        .where('uId', isEqualTo: uId)
        .get();

    return userData.docs;
  }
}