class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int cart;
  final String? address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.cart,
    this.address,
  });

  factory UserModel.fromMap(Map data, String id) {
    return UserModel(
      id: id,
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      cart: data['cart'],
      address: data['address'],

    );
  }

  static double checkDouble(dynamic value) {
    String newValue = value.toString();
    return double.parse(newValue);
  }
}
