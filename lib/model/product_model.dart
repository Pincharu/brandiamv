class ProductModel {
  final String id;
  final String name;
  final String nameDesc;
  final String? image;
  final String? category;
  final double price;
  final int stock;
  int? quantity;
  final String itemCode;
  final String? description;

  ProductModel({
    required this.id,
    required this.name,
    required this.nameDesc,
    this.image,
    this.category,
    required this.price,
    required this.stock,
    this.quantity,
    required this.itemCode,
    this.description,
  });

  factory ProductModel.fromMap(Map data, String id) {
    return ProductModel(
      id: id,
      name: data['name'],
      nameDesc: data['nameDesc'],
      image: data['image'],
      category: data['category'],
      description: data['description'],
      stock: data['stock'],
      itemCode: data['itemCode'],
      price: checkDouble(data['price']),
    );
  }

  static double checkDouble(dynamic value) {
    String newValue = value.toString();
    return double.parse(newValue);
  }
}
