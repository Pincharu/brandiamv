import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersModel {
  final String id;
  final String address;
  final List<dynamic> products;
  final String user;
  final Timestamp orderTime;
  final bool read;
  final String phone;
  final String atoll;
  final String island;
  final String name;

  OrdersModel({
    required this.id,
    required this.address,
    required this.products,
    required this.user,
    required this.orderTime,
    required this.read,
    required this.phone,
    required this.name,
    required this.atoll,
    required this.island,
  });

  factory OrdersModel.fromMap(Map data, String id) {
    return OrdersModel(
      id: id,
      address: data['address'],
      products: data['products'],
      user: data['user'],
      orderTime: data['orderTime'],
      read: data['read'],
      phone: data['phone'],
      name: data['name'],
      atoll: data['atoll'],
      island: data['island'],
    );
  }

  static double checkDouble(dynamic value) {
    String newValue = value.toString();
    return double.parse(newValue);
  }
}
