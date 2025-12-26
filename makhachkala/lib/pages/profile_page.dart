import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/auth_service.dart';
import '../utils/provider.dart';
import 'login_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Mock user data
  final String userName = 'Иван Иванов';
  final String phone = '+7 (999) 123-45-67';
  final String email = 'ivan@example.com';
  final String defaultAddress = 'ул. Ленина, д. 45, кв. 12';

  // Mock order history
  final List<Order> _orders = [
    Order(
      id: '1',
      date: DateTime(2025, 10, 8),
      items: [
        OrderItem(name: 'Шаурма классическая', quantity: 2, price: 5),
        OrderItem(name: 'Айран', quantity: 1, price: 50),
      ],
      total: 110,
      status: 'completed',
    ),
    Order(
      id: '2',
      date: DateTime(2025, 10, 5),
      items: [
        OrderItem(name: 'Чуду с мясом', quantity: 1, price: 150),
        OrderItem(name: 'Чай черный', quantity: 1, price: 40),
      ],
      total: 190,
      status: 'completed',
    ),
    Order(
      id: '3',
      date: DateTime(2025, 10, 1),
      items: [
        OrderItem(name: 'Шаурма острая', quantity: 1, price: 150),
        OrderItem(name: 'Сок гранатовый', quantity: 1, price: 80),
      ],
      total: 230,
      status: 'cancelled',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[100],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[900],
              child: const SafeArea(
                bottom: false,
                child: Text(
                  'Профиль',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Header with user info
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[900],
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          phone,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfilePage(
                            userName: userName,
                            phone: phone,
                            email: email,
                            defaultAddress: defaultAddress,
                          ),
                        ),
                      ).then((_) {
                        setState(() {});
                      });
                    },
                    child: const Text(
                      'Редактировать',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Bonuses section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Бонусы',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Используйте при следующем заказе',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard('12', 'Заказов'),
                      _buildStatCard('4.9', 'Рейтинг'),
                      _buildStatCard('250 баллов', 'Экономия'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Contact information
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Контактная информация',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.phone, 'Телефон', phone),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.email, 'Email', email),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.location_on,
                    'Адрес по умолчанию',
                    defaultAddress,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Order history
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'История заказов',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          // Refresh orders
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._orders.map((order) => _buildOrderCard(order)),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Show all orders
                      },
                      child: const Text('Показать все'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Logout button
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final auth = ChangeNotifierProvider.of<AuthService>(context);
                    auth.logout();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text(
                        'Выйти',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(Order order) {
    final isCancelled = order.status == 'cancelled';
    final dateStr =
        '${order.date.day} ${_getMonthName(order.date.month)} ${order.date.year}';
    final itemsStr = order.items
        .map((item) => '${item.name} x ${item.quantity}')
        .join(', ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Заказ #${order.id}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isCancelled) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Отменен',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                '${order.total.toStringAsFixed(0)}P',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            dateStr,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            itemsStr,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];
    return months[month - 1];
  }
}

