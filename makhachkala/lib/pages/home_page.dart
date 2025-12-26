import 'package:flutter/material.dart';
import '../models/restaurant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  // Mock данные для ресторанов
  final List<Restaurant> _restaurants = [
    Restaurant(
      id: '1',
      name: 'Махачкала Центр',
      address: 'ул. Ленина, 45',
      distance: 0.5,
      rating: 4.8,
      isOpen: true,
    ),
    Restaurant(
      id: '2',
      name: 'Махачкала Вокзал',
      address: 'Привокзальная пл., 1',
      distance: 1.2,
      rating: 4.9,
      isOpen: true,
    ),
    Restaurant(
      id: '3',
      name: 'Махачкала Парк',
      address: 'ул. Парковая, 23',
      distance: 2.1,
      rating: 4.7,
      isOpen: false,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF8B4513), // Оранжево-коричневый фон
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Logo
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'M',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Махачкала',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Дагестанская кухня',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.person, color: Colors.white),
                ],
              ),
            ),
            
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск ресторанов...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Special offer card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFFFFEB3B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Специальное предложение',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Шаурма за 5Р!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Только сегодня - невероятная цена',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.fastfood,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Quick actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickAction(
                    icon: Icons.restaurant_menu,
                    label: 'Меню',
                    onTap: () {},
                  ),
                  _buildQuickAction(
                    icon: Icons.shopping_cart,
                    label: 'Заказы',
                    onTap: () {},
                  ),
                  _buildQuickAction(
                    icon: Icons.star,
                    label: 'Бонусы',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Nearest restaurants
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Ближайшие рестораны',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = _restaurants[index];
                          return _buildRestaurantCard(restaurant);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
          },
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.orange),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(Restaurant restaurant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  restaurant.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: restaurant.isOpen
                      ? Colors.green
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  restaurant.isOpen ? 'Открыто' : 'Закрыто',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                restaurant.address,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '${restaurant.distance} км',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const Spacer(),
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                restaurant.rating.toString(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

