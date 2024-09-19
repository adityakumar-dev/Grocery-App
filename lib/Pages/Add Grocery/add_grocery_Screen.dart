import 'package:flutter/material.dart';
import 'package:grocery_app/Services/providers/gocery_list_provider.dart';
import 'package:grocery_app/model/grocery_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddGroceryScreen extends StatefulWidget {
  final int? index;
  final GroceryItem? item;

  const AddGroceryScreen({super.key, this.item, this.index});

  @override
  State<AddGroceryScreen> createState() => _AddGroceryScreenState();
}

class _AddGroceryScreenState extends State<AddGroceryScreen> {
  late TextEditingController nameController;
  late TextEditingController quantityController;
  late TextEditingController priceController;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item?.name ?? '');
    quantityController =
        TextEditingController(text: widget.item?.quantity.toString() ?? '1');
    priceController = TextEditingController(
        text: widget.item?.price.toStringAsFixed(2) ?? '0.0');
    selectedDate = widget.item?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void _saveItem() async {
    final name = nameController.text;
    final quantity = int.tryParse(quantityController.text) ?? 1;
    final price = double.tryParse(priceController.text) ?? 0.0;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item name is required")),
      );
      return;
    }

    final groceryItem = GroceryItem(
      name: name,
      quantity: quantity,
      price: price,
      date: selectedDate,
    );

    final groceryListProvider =
        Provider.of<GroceryListProvider>(context, listen: false);

    if (widget.item == null) {
      // Adding a new grocery item (Firestore generates ID)
      await groceryListProvider.addGrocery(groceryItem);
    } else {
      // Updating the existing grocery item using Firestore document ID directly
      // final docId = groceryListProvider.getDocumentIdForItem(widget.index!);
      // await groceryListProvider.updateGrocery(docId, groceryItem);
      await groceryListProvider.updateGrocery(widget.index!, groceryItem);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.item == null ? "Add Grocery Item" : "Update Grocery Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildInputCard(
                label: "Item Name",
                icon: Icons.fastfood,
                controller: nameController,
              ),
              const SizedBox(height: 16),
              _buildInputCard(
                label: "Quantity",
                icon: Icons.production_quantity_limits,
                controller: quantityController,
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildInputCard(
                label: "Price",
                icon: Icons.attach_money,
                controller: priceController,
                inputType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              _buildDatePicker(),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveItem,
                icon: const Icon(Icons.save),
                label: Text(
                  widget.item == null ? "Add Grocery" : "Update Grocery",
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Improved input field with icons and rounded corners
  Widget _buildInputCard({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? inputType,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          controller: controller,
          keyboardType: inputType,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ),
    );
  }

  // Date picker with custom card and calendar icon
  Widget _buildDatePicker() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
            style: const TextStyle(fontSize: 16),
          ),
          trailing: IconButton(
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null && pickedDate != selectedDate) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
            icon: const Icon(Icons.calendar_today, color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
