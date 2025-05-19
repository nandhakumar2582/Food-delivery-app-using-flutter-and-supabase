class CartItem {
  final String id;
  final String productId;
  final Map<String, dynamic> productData;
  int quantity;
  final String userId;

  CartItem({
    required this.id,
    required this.productId,
    required this.productData,
    required this.quantity,
    required this.userId,
  });

  factory CartItem.fromJson(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      productId: map['product_id'] ?? '',
      productData: Map<String, dynamic>.from(map['product_data'] ?? {}),
      quantity: map['quantity'] ?? 1,
      userId: map['user_id'] ?? '',
    );
  }
}
