import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/model/grocery_model.dart';

class GroceryListProvider extends ChangeNotifier {
  final List<GroceryItem> _groceryList = [];
  String _docs = '';
  double _totalPrice = 0.0;

  List<GroceryItem> get groceryList => _groceryList;
  String get docs => _docs;
  double get totalPrice => _totalPrice;

  final CollectionReference _groceryCollection =
      FirebaseFirestore.instance.collection('grocery_items');

  void setDocs(String doc) {
    _docs = doc;
    notifyListeners();
  }

  void _updatePrice() {
    _totalPrice = _groceryList.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  Future<void> fetchGroceryList() async {
    try {
      final querySnapshot = await _groceryCollection.get();
      _groceryList.clear();
      _groceryList.addAll(querySnapshot.docs.map((doc) {
        return GroceryItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList());
      _updatePrice();
      notifyListeners();
    } catch (e) {
      // Handle errors
      print('Error fetching grocery list: $e');
    }
  }

  Future<void> addGrocery(GroceryItem groceryItem) async {
    try {
      final docRef = await _groceryCollection.add(groceryItem.toMap());
      groceryItem.id = docRef.id;
      _groceryList.add(groceryItem);
      _updatePrice();
      notifyListeners();
    } catch (e) {
      // Handle errors
      print('Error adding grocery item: $e');
    }
  }

  Future<void> updateGrocery(String docId, GroceryItem groceryItem) async {
    try {
      await _groceryCollection.doc(docId).update(groceryItem.toMap());
      final index = _groceryList.indexWhere((item) => item.id == docId);
      if (index != -1) {
        _groceryList[index] = groceryItem;
        _updatePrice();
        notifyListeners();
      }
    } catch (e) {
      // Handle errors
      print('Error updating grocery item: $e');
    }
  }

  Future<void> removeGrocery(String docId) async {
    try {
      await _groceryCollection.doc(docId).delete();
      _groceryList.removeWhere((item) => item.id == docId);
      _updatePrice();
      notifyListeners();
    } catch (e) {
      // Handle errors
      print('Error removing grocery item: $e');
    }
  }
}
