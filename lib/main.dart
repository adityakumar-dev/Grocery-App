import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/Services/providers/gocery_list_provider.dart';
import 'package:grocery_app/app_routes.dart';
import 'package:grocery_app/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GroceryListProvider(),
        )
      ],
      child: MaterialApp(
        title: "Grocery App",
        initialRoute: '/',
        routes: app_routes,
      ),
    );
  }
}
