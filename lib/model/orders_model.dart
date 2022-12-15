import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersModel {
  final String id;
  final String address;
  final List<dynamic> products;
  final double total;
  final String user;
  final Timestamp orderTime;

  OrdersModel({
    required this.id,
    required this.address,
    required this.products,
    required this.total,
    required this.user,
    required this.orderTime,
  });

  factory OrdersModel.fromMap(Map data, String id) {
    return OrdersModel(
      id: id,
      address: data['address'],
      products: data['products'],
      total: checkDouble(data['total']),
      user: data['user'],
      orderTime: data['orderTime'],
    );
  }

  static double checkDouble(dynamic value) {
    String newValue = value.toString();
    return double.parse(newValue);
  }
}
