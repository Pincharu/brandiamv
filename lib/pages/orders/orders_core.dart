import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../model/orders_model.dart';
import '../login/authcore.dart';

class OrdersCore extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var ordersList = RxList<OrdersModel>([]);
  var auth = Get.find<AuthCore>();

  @override
  void onInit() {
    ordersList.bindStream(orderStream());
    super.onInit();
  }

  Stream<List<OrdersModel>> orderStream() {
    return _db
        .collection('orders')
        .orderBy('orderTime', descending: true)
        .where('user', isEqualTo: auth.getUser)
        .snapshots()
        .map((list) => list.docs.map((doc) => OrdersModel.fromMap(doc.data(), doc.id)).toList());
  }
}
