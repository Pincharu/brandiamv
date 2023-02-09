import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersModel {
  final String id;
  final List<dynamic> products;
  final Timestamp orderTime;
  final bool read;
  final String phone;
  final String atoll;
  final String island;
  final String name;
  final String? pdf;
  final String? note;

  OrdersModel({
    required this.id,
    required this.products,
    required this.orderTime,
    required this.read,
    required this.phone,
    required this.name,
    required this.atoll,
    required this.island,
    this.pdf,
    this.note,
  });

  factory OrdersModel.fromMap(Map data, String id) {
    return OrdersModel(
      id: id,
      products: data['products'],
      orderTime: data['orderTime'],
      read: data['read'],
      phone: data['phone'],
      name: data['name'],
      atoll: data['atoll'],
      island: data['island'],
      pdf: data['pdf'],
      note: data['note'],
    );
  }

  static double checkDouble(dynamic value) {
    String newValue = value.toString();
    return double.parse(newValue);
  }
}
