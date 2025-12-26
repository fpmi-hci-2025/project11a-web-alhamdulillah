import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'services/cart_service.dart';
import 'utils/provider.dart';
import 'pages/main_navigation_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create services
    final cart = CartModel();

    return ChangeNotifierProvider(
      notifier: cart,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Махачкала',
        theme: ThemeData(
          fontFamily: 'Roboto',
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8B4513),
          ),
        ),
        home: const MainNavigationPage(),
      ),
    );
  }
}
