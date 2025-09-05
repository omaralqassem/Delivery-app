class Orders {
  final String orderId;
  final String customerId;
  final String? driverId;
  String status;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Product> items;

  Orders({
    required this.orderId,
    required this.customerId,
    required this.driverId,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory Orders.fromJson(Map<String, dynamic> json) {
    final List<Product> items = (json['items'] as List)
        .map((itemJson) => Product.fromJson(itemJson))
        .toList();

    return Orders(
      orderId: json['id'].toString(),
      customerId: json['customer_id'].toString(),
      driverId: json['driver_id']?.toString(),
      status: json['status'],
      totalPrice: double.parse(json['total_price']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      items: items,
    );
  }
}

class Product {
  final String productId;
  final String orderId;
  final int quantity;
  final double unitPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.productId,
    required this.orderId,
    required this.quantity,
    required this.unitPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'].toString(),
      orderId: json['order_id'].toString(),
      quantity: json['quantity'],
      unitPrice: double.parse(json['unit_price']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
