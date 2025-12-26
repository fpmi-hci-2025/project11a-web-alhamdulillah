import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';
import '../models/cart_item.dart';

class CartModel extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  String? _promoCode;
  double _discountPercent = 0.0;
  
  void add(MenuItemModel item) {
    if (_items.containsKey(item.id)) {
      _items[item.id]!.quantity++;
    } else {
      _items[item.id] = CartItem(item: item, quantity: 1);
    }
    notifyListeners();
  }

  void remove(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void changeQuantity(String id, int newQuantity) {
    if (_items.containsKey(id)) {
      if (newQuantity <= 0) {
        _items.remove(id);
      } else {
        _items[id]!.quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    _promoCode = null;
    _discountPercent = 0.0;
    notifyListeners();
  }

  bool applyPromoCode(String code) {
    // Mock promo codes
    final promoCodes = {
      'SUMMER10': 10.0,
      'WELCOME20': 20.0,
      'SAVE15': 15.0,
    };
    
    if (promoCodes.containsKey(code.toUpperCase())) {
      _promoCode = code.toUpperCase();
      _discountPercent = promoCodes[code.toUpperCase()]!;
      notifyListeners();
      return true;
    }
    return false;
  }

  List<CartItem> get items => _items.values.toList();

  double get subtotal {
    double sum = 0;
    for (final cartItem in _items.values) {
      sum += cartItem.totalPrice;
    }
    return sum;
  }

  double get discount => subtotal * (_discountPercent / 100);

  double get total {
    return subtotal - discount;
  }

  String? get promoCode => _promoCode;
  double get discountPercent => _discountPercent;

  int get count => _items.length;
  
  int get totalItems {
    int sum = 0;
    for (final cartItem in _items.values) {
      sum += cartItem.quantity;
    }
    return sum;
  }
}

