import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/menu_item.dart';
import '../models/cart_item.dart';
import '../services/api_service.dart';
import '../services/cart_service.dart';
import '../utils/provider.dart';
import '../config/app_config.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final ApiService _api = ApiService(baseUrl);
  List<Category> _categories = [];
  List<MenuItemModel> _items = [];
  String? _selectedCategoryId;
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      _categories = await _api.fetchCategories();
      if (_categories.isNotEmpty) {
        _selectedCategoryId = _categories[0].id;
        _items = await _api.fetchMenu(categoryId: _selectedCategoryId);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _selectCategory(String categoryId) async {
    setState(() {
      _loading = true;
      _selectedCategoryId = categoryId;
    });
    try {
      _items = await _api.fetchMenu(categoryId: categoryId);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF8B4513),
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text('Ошибка: $_error'))
              : Column(
                  children: [
                    // Category tabs
                    Container(
                      height: 50,
                      color: Colors.white,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected =
                              category.id == _selectedCategoryId;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ChoiceChip(
                              label: Text(category.name),
                              selected: isSelected,
                              onSelected: (_) => _selectCategory(category.id),
                              selectedColor: const Color(0xFF8B4513),
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Menu items
                    Expanded(
                      child: _items.isEmpty
                          ? const Center(child: Text('Нет товаров'))
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _items.length,
                              itemBuilder: (context, index) {
                                final item = _items[index];
                                return _MenuItemCard(
                                  item: item,
                                  api: _api,
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItemModel item;
  final ApiService api;

  const _MenuItemCard({
    super.key,
    required this.item,
    required this.api,
  });

  @override
  Widget build(BuildContext context) {
    final cart = ChangeNotifierProvider.of<CartModel>(context);
    final price = double.tryParse(item.price) ?? 0;
    final oldPrice = item.oldPrice != null
        ? double.tryParse(item.oldPrice!) ?? 0
        : null;
    final isHit = oldPrice != null && oldPrice > price;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 80,
              height: 80,
              child: item.imageUrl.isEmpty
                  ? Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.fastfood),
                    )
                  : Image.network(
                      api.fullImageUrl(item.imageUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, _) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.fastfood),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isHit)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'ХИТ!',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (isHit) const SizedBox(height: 4),
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (oldPrice != null)
                          Text(
                            '${oldPrice.toStringAsFixed(0)}P ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Text(
                          '${price.toStringAsFixed(0)}P',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B4513),
                          ),
                        ),
                      ],
                    ),
                    _buildCartControls(context, cart),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartControls(BuildContext context, CartModel cart) {
    final cartItem = cart.items.firstWhere(
      (cartItem) => cartItem.item.id == item.id,
      orElse: () => CartItem(item: item, quantity: 0),
    );
    final isInCart = cartItem.quantity > 0;

    if (!isInCart) {
      return ElevatedButton(
        onPressed: item.isAvailable
            ? () {
                cart.add(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Добавлено в корзину'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B4513),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        child: const Text('+ В корзину'),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            if (cartItem.quantity > 1) {
              cart.changeQuantity(item.id, cartItem.quantity - 1);
            } else {
              cart.remove(item.id);
            }
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '${cartItem.quantity}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            cart.changeQuantity(item.id, cartItem.quantity + 1);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            cart.remove(item.id);
          },
        ),
      ],
    );
  }
}

