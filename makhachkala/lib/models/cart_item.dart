import '../models/menu_item.dart';

class CartItem {
  final MenuItemModel item;
  int quantity;
  
  CartItem({
    required this.item,
    this.quantity = 1,
  });
  
  double get totalPrice {
    final price = double.tryParse(item.price) ?? 0;
    return price * quantity;
  }
}

