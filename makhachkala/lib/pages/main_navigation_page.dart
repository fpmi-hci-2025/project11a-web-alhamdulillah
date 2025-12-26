import 'package:flutter/material.dart';
import '../utils/provider.dart';
import '../services/cart_service.dart';
import 'home_page.dart';
import 'menu_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const MenuPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = ChangeNotifierProvider.of<CartModel>(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(), // Для плавного свайпа
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 8,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Главная',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: 'Меню',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart),
                  if (cart.count > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cart.count}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Корзина',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }
}

