import 'package:grocery_app/Pages/Add%20Grocery/add_grocery_Screen.dart';
import 'package:grocery_app/Pages/Auth/auth_screen.dart';
import 'package:grocery_app/Pages/Home/home_screen.dart';
import 'package:grocery_app/Pages/Splash%20Screen/splash_screen.dart';

final app_routes = {
  '/': (context) => const SplashScreen(),
  '/auth': (context) => const AuthScreen(),
  '/home': (context) => const HomeScreen(),
  '/add': (context) => const AddGroceryScreen(),
};
