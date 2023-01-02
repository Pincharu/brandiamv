class UserModel {
  final String id;
  final String name;
  final String bussinessName;
  final String phone;
  final String? atoll;
  final String? island;
  final String? address;

  UserModel({
    required this.id,
    required this.name,
    required this.bussinessName,
    required this.phone,
    this.atoll,
    this.island,
    this.address,
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
    );
  }

  static double checkDouble(dynamic value) {
    String newValue = value.toString();
    return double.parse(newValue);
  }
}
