import 'package:cloud_firestore/cloud_firestore.dart';

class GroceryItem {
  final String name;
  final int quantity;
  final double price;
  final DateTime date;

  GroceryItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.date,
  });

  // Convert GroceryItem to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'date': Timestamp.fromDate(date),
    };
  }

  factory GroceryItem.fromMap(Map<String, dynamic> map) {
    return GroceryItem(
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 1,
      price: map['price']?.toDouble() ?? 0.0,
      date: (map['date'] as Timestamp).toDate() ?? DateTime.now(),
    );
  }
}
