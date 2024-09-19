import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_app/Services/providers/gocery_list_provider.dart';
import 'package:grocery_app/model/grocery_model.dart';
import 'package:provider/provider.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  String _scanResult = 'Scan a QR code';
  GroceryItem _parseQrData(String data) {
    final lines = data.split('\n');
    final dataMap = <String, dynamic>{};

    for (var line in lines) {
      final parts = line.split(':');
      if (parts.length == 2) {
        final key = parts[0].trim().toLowerCase();
        final value = parts[1].trim();

        switch (key) {
          case 'name':
            dataMap['name'] = value;
            break;
          case 'quantity':
            dataMap['quantity'] = int.tryParse(value) ?? 0;
            break;
          case 'price':
            dataMap['price'] = double.tryParse(value) ?? 0.0;
            break;
          case 'date':
            dataMap['date'] = value;
            break;
        }
      }
    }

    return GroceryItem.fromMap(dataMap);
  }

  Future<void> _startScan() async {
    try {
      final scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE, // Scan mode
      );

      if (scanResult != '-1') {
        setState(() {
          _scanResult = scanResult;

          print(_scanResult);
          GroceryItem item = _parseQrData(_scanResult);
        });
        Fluttertoast.showToast(
          msg: "Scanned Result: $scanResult",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (e) {
      print(e.toString());

      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        // backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _scanResult,
              // style: TextStyle(),
              // style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startScan,
              child: const Text('Start Scan'),
            ),
          ],
        ),
      ),
    );
  }
}
