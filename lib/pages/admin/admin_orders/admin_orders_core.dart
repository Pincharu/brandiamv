import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/orders_model.dart';
import '../../../shared/authcore.dart';
import '../../../shared/loading.dart';
import '../../../shared/pdf_report.dart';

class AdminOrdersCore extends GetxController {
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
        .snapshots()
        .map((list) => list.docs.map((doc) => OrdersModel.fromMap(doc.data(), doc.id)).toList());
  }

  List<TextEditingController> prices = [];

  Future saveProducts(OrdersModel order) async {
    List<Map> productsList = [];

    for (int i = 0; i < order.products.length; i++) {
      productsList.add({
        "id": order.products[i]['id'],
        "name": order.products[i]['name'],
        "quantity": order.products[i]['quantity'],
        "itemCode": order.products[i]['itemCode'],
        "price": double.parse(prices[i].text)
      });
    }

    final path = 'orders/${order.id}';
    final ref = FirebaseFirestore.instance.doc(path);
    await ref.update({'products': productsList, 'read': true});
  }

  Future readOrder(String id) async {
    final path = 'orders/$id';
    final ref = FirebaseFirestore.instance.doc(path);
    await ref.update({'read': true});
  }

  Future generatePDF(OrdersModel order) async {
    showLoadingIndicator();
    await PdfReportApi.generate(order);
    hideLoadingIndicator();
  }
}
