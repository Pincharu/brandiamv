import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../model/orders_model.dart';
import '../../../shared/authcore.dart';

class OrdersCore extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var ordersList = RxList<OrdersModel>([]);
  var authCore = Get.find<AuthCore>();

  @override
  void onInit() {
    if (authCore.firestoreUser.value != null) ordersList.bindStream(orderStream());
    if (authCore.firestoreUser.value == null) restartOrder();
    super.onInit();
  }

  Stream<List<OrdersModel>> orderStream() {
    return _db
        .collection('orders')
        .where('phone', isEqualTo: authCore.firestoreUser.value!.phone)
        .snapshots()
        .map((list) => list.docs.map((doc) => OrdersModel.fromMap(doc.data(), doc.id)).toList());
  }

  restartOrder() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await Future.delayed(const Duration(seconds: 2), () async {
      onInit();
    });
  }
}
