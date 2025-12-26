import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';
import '../utils/provider.dart';
import '../services/api_service.dart';
import '../services/order_service.dart';
import '../config/app_config.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _promoController = TextEditingController();
  final ApiService _api = ApiService(baseUrl);
  final OrderService _orderService = OrderService(baseUrl);
  final double _deliveryCost = 50.0;
  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ChangeNotifierProvider.of<CartModel>(context);
    
    return Material(
      color: Colors.white,
      child: cart.items.isEmpty
          ? const Center(
              child: Text(
                'Корзина пуста',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                // Items list
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (context, index) {
                      final cartItem = cart.items[index];
                      return _CartItemRow(
                        cartItem: cartItem,
                        api: _api,
                      );
                    },
                  ),
                ),
                
                // Promo code section
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Промокод',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _promoController,
                              decoration: InputDecoration(
                                hintText: 'Введите промокод',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              final code = _promoController.text.trim();
                              if (code.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Введите промокод'),
                                  ),
                                );
                                return;
                              }
                              if (cart.applyPromoCode(code)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Промокод "$code" применен! Скидка ${cart.discountPercent.toStringAsFixed(0)}%'),
                                  ),
                                );
                                setState(() {});
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Неверный промокод'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B4513),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Применить'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Order summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(
                      top: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Итого',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Сумма заказа'),
                          Text(
                            '${cart.subtotal.toStringAsFixed(0)}P',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      if (cart.promoCode != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Скидка (${cart.promoCode})'),
                            Text(
                              '-${cart.discount.toStringAsFixed(0)}P',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Доставка'),
                          Text(
                            '${_deliveryCost.toStringAsFixed(0)}P',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Всего',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${(cart.total + _deliveryCost).toStringAsFixed(0)}P',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isPlacingOrder ? null : () => _placeOrder(context, cart),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B4513),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isPlacingOrder
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Оформить заказ',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _placeOrder(BuildContext context, CartModel cart) async {
    setState(() {
      _isPlacingOrder = true;
    });

    try {
      // Получаем информацию о покупателе из профиля
      final customerInfo = {
        'name': 'Иван Иванов', // TODO: получить из профиля
        'phone': '+7 (999) 123-45-67',
        'email': 'ivan@example.com',
        'address': 'ул. Ленина, д. 45, кв. 12',
      };

      await _orderService.createOrder(
        items: cart.items,
        customerInfo: customerInfo,
        total: cart.total,
        deliveryCost: _deliveryCost,
        promoCode: cart.promoCode,
      );

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('Заказ оформлен'),
            content: Text(
              'Ваш заказ на сумму ${(cart.total + _deliveryCost).toStringAsFixed(0)}P успешно оформлен!',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  cart.clear();
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка оформления заказа: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }
}

class _CartItemRow extends StatelessWidget {
  final CartItem cartItem;
  final ApiService api;

  const _CartItemRow({
    super.key,
    required this.cartItem,
    required this.api,
  });

  @override
  Widget build(BuildContext context) {
    final cart = ChangeNotifierProvider.of<CartModel>(context);
    final price = double.tryParse(cartItem.item.price) ?? 0;
    
    return Row(
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 60,
            height: 60,
            child: cartItem.item.imageUrl.isEmpty
                ? Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.fastfood),
                  )
                : Image.network(
                    api.fullImageUrl(cartItem.item.imageUrl),
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
              Text(
                cartItem.item.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${price.toStringAsFixed(0)}P',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        // Quantity controls
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                cart.changeQuantity(cartItem.item.id, cartItem.quantity - 1);
              },
            ),
            Text(
              '${cartItem.quantity}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                cart.changeQuantity(cartItem.item.id, cartItem.quantity + 1);
              },
            ),
          ],
        ),
        // Delete button
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            cart.remove(cartItem.item.id);
          },
        ),
      ],
    );
  }
}

