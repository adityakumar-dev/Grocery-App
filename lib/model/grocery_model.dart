import 'package:cloud_firestore/cloud_firestore.dart';

class GroceryItem {
  String? id;
  String name;
  int quantity;
  double price;
  DateTime date;

  GroceryItem({
    this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.date,
  });

  factory GroceryItem.fromMap(Map<String, dynamic> data, String id) {
    return GroceryItem(
      id: id,
      name: data['name'] ?? '',
      quantity: data['quantity'] ?? 1,
      price: data['price']?.toDouble() ?? 0.0,
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'date': date.toIso8601String(),
    };
  }
}
