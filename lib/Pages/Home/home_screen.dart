import 'package:flutter/material.dart';
import 'package:grocery_app/Pages/Add%20Grocery/add_grocery_Screen.dart';
import 'package:grocery_app/Pages/qrPage/qr_page.dart';
import 'package:grocery_app/Pages/qrPage/qr_scanner_page.dart';
import 'package:grocery_app/Services/Auth/auth_service.dart';
import 'package:grocery_app/Services/providers/gocery_list_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<GroceryItem> groceryList = [
  //   GroceryItem(
  //       name: 'Milk',
  //       quantity: 1,
  //       date: DateTime.now().add(const Duration(days: 1)),
  //       price: 1.0),
  //   GroceryItem(
  //       name: 'Eggs',
  //       quantity: 12,
  //       price: 2.1,
  //       date: DateTime.now().add(Duration(days: 3))),
  //   GroceryItem(
  //       name: 'Bread',
  //       quantity: 2,
  //       price: 10.0,
  //       date: DateTime.now().add(Duration(days: 2))),
  // ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final groceryListProvider =
          Provider.of<GroceryListProvider>(context, listen: false);
      // groceryListProvider.fetchGroceryList();
      // groceryListProvider.addGroceryList(groceryList);
      groceryListProvider.fetchGroceryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: const Text('Grocery List'),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 5),
            child: IconButton(
              icon: const Icon(Icons.qr_code),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrScannerPage(),
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 5),
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => Navigator.pushNamed(context, '/add'),
            ),
          ),
          Container(
            child: IconButton(
                onPressed: () {
                  AuthService().signOut(context);
                },
                icon: const Icon(Icons.logout)),
          )
        ],
      ),
      body: Consumer<GroceryListProvider>(
        builder: (context, groceryListProvider, child) {
          return groceryListProvider.groceryList.isEmpty
              ? const Center(child: Text("Grocery Items Not found"))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Total Cost: \$${groceryListProvider.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        itemCount: groceryListProvider.groceryList.length,
                        itemBuilder: (context, index) {
                          final item = groceryListProvider.groceryList[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        QrScreen(groceryItem: item),
                                  )),
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Text(
                                'Quantity: ${item.quantity} | Price: \$${item.price.toStringAsFixed(2)} | Date: ${DateFormat('yyyy-MM-dd').format(item.date)}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddGroceryScreen(
                                            item: item, index: index),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () async {
                                      final shouldDelete =
                                          await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Delete Item'),
                                          content: const Text(
                                              'Are you sure you want to delete this item?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (shouldDelete == true) {
                                        groceryListProvider
                                            .removeGrocery(index);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
