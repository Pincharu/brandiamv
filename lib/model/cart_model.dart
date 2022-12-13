class CartModel {
  final String id;
  final String image;
  final String name;
  final double price;
  final int stock;
  final int quantity;
  final String productID;

  const CartModel({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.stock,
    required this.quantity,
    required this.productID,
  });

  factory CartModel.fromMap(Map data, String id) {
    return CartModel(
      id: id,
      name: data['name'] ?? '',
      price: (data['price'] == null) ? 0.0 : data['price'].toDouble(),
      stock: data['stock'] ?? 0,
      image: data['image'] ?? '',
      quantity: data['quantity'] ?? 0,
      productID: data['productID'],
    );
  }
}
