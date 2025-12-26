
class Order {
  final String id;
  final DateTime date;
  final List<OrderItem> items;
  final double total;
  final String status; // "completed", "cancelled", "pending"
  
  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    required this.status,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;
  
  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

