import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/model/grocery_model.dart';

class GroceryListProvider extends ChangeNotifier {
  final List<GroceryItem> _groceryList = [];
  double _totalPrice = 0.0;
  String? userId;

  List<GroceryItem> get groceryList => _groceryList;
  double get totalPrice => _totalPrice;

  Future<void> getUserId() async {
    userId = FirebaseAuth.instance.currentUser?.uid;
  }

  CollectionReference getUserCollection() {
    if (userId == null) {
      throw Exception('User ID is not set.');
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('grocery_data');
  }

  void _updatePrice() {
    _totalPrice = _groceryList.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  void addGroceryList(data) {
    _groceryList.addAll(data);
    notifyListeners();
  }

  Future<void> fetchGroceryList() async {
    try {
      if (userId == null) {
        await getUserId();
      }

      final docRef = getUserCollection().doc('grocery_list');
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;

        final items = (data['items'] as List<dynamic>)
            .map((item) => GroceryItem.fromMap(item as Map<String, dynamic>))
            .toList();
        _groceryList.clear();
        _groceryList.addAll(items);
        _updatePrice();
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching grocery list: $e');
    }
  }

  Future<void> addUpdateData() async {
    try {
      if (userId == null) {
        await getUserId();
      }

      final docRef = getUserCollection().doc('grocery_list');

      final data = {
        'items': _groceryList.map((item) => item.toMap()).toList(),
      };

      await docRef.set(data, SetOptions(merge: true));

      _updatePrice();
      notifyListeners();
    } catch (e) {
      print('Error adding/updating data: $e');
    }
  }

  Future<void> addGrocery(GroceryItem groceryItem) async {
    try {
      _groceryList.add(groceryItem);
      await addUpdateData();
      await addUpdateData();
    } catch (e) {
      print('Error adding grocery item: $e');
    }
  }

  Future<void> updateGrocery(int index, GroceryItem groceryItem) async {
    try {
      if (index >= 0 && index < _groceryList.length) {
        _groceryList[index] = groceryItem;
        await addUpdateData();
      }
    } catch (e) {
      print('Error updating grocery item: $e');
    }
  }

  Future<void> removeGrocery(int index) async {
    try {
      if (index >= 0 && index < _groceryList.length) {
        _groceryList.removeAt(index);
        await addUpdateData();
      }
    } catch (e) {
      print('Error removing grocery item: $e');
    }
  }
}
