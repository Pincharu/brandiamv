class UserModel {
  final String id;
  final String name;
  final String? bussinessName;
  final String phone;
  final String? atoll;
  final String? island;
  final String? address;
  final bool? isAdmin;

  UserModel({
    required this.id,
    required this.name,
    this.bussinessName,
    required this.phone,
    this.atoll,
    this.island,
    this.address,
    this.isAdmin,
  });

  factory UserModel.fromMap(Map data, String id) {
    return UserModel(
      id: id,
      name: data['name'],
      bussinessName: data['bussinessName'],
      phone: data['phone'],
      atoll: data['atoll'],
      island: data['island'],
      address: data['address'],
      isAdmin: data['isAdmin'],
    );
  }

  static double checkDouble(dynamic value) {
    String newValue = value.toString();
    return double.parse(newValue);
  }
}
