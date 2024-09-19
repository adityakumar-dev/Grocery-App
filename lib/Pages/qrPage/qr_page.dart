import 'dart:convert';

import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/model/grocery_model.dart';

class QrScreen extends StatelessWidget {
  final GroceryItem groceryItem;

  const QrScreen({super.key, required this.groceryItem});

  String generateQr() {
    final dm = Barcode.dataMatrix();
    // jsonEncode(groceryItem.toMap());
    return dm.toSvg(
      jsonEncode({
        'name': groceryItem.name,
        'price': groceryItem.price,
        'date': groceryItem.date.toString(),
        'quantity': groceryItem.quantity
      }),
      width: 300,
      height: 300,
    );
  }

  @override
  Widget build(BuildContext context) {
    final qrSvg = generateQr();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Grocery Item QR',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SvgPicture.string(
                  qrSvg,
                  semanticsLabel: 'QR Code',
                ),
              ),
              const SizedBox(height: 20),
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: Colors.green.shade50,
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(color: Colors.green, width: 2),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Text(
              //         'Item Details',
              //         style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             color: Colors.green,
              //             fontSize: 20),
              //       ),
              //       const SizedBox(height: 10),
              //       Text(
              //         'Name: ${groceryItem.name}',
              //         style: TextStyle(
              //             color: Colors.orange, fontWeight: FontWeight.bold),
              //       ),
              //       Text('Quantity: ${groceryItem.quantity}',
              //           style: TextStyle(
              //               color: Colors.orange, fontWeight: FontWeight.bold)),
              //       Text('Price: ${groceryItem.price}',
              //           style: TextStyle(
              //               color: Colors.orange, fontWeight: FontWeight.bold)),
              //       Text('Date: ${groceryItem.date}',
              //           style: TextStyle(
              //               color: Colors.orange, fontWeight: FontWeight.bold)),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
