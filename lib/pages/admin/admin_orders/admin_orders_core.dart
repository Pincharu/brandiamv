import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../model/orders_model.dart';

class AdminOrdersCore extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var ordersList = RxList<OrdersModel>([]);

  @override
  void onInit() {
    ordersList.bindStream(orderStream());
    super.onInit();
  }

  Stream<List<OrdersModel>> orderStream() {
    return _db
        .collection('orders')
        .orderBy('orderTime', descending: true)
        .snapshots()
        .map((list) => list.docs.map((doc) => OrdersModel.fromMap(doc.data(), doc.id)).toList());
  }
}
