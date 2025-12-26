class Restaurant {
  final String id;
  final String name;
  final String address;
  final double distance; // в км
  final double rating;
  final bool isOpen;
  
  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.rating,
    required this.isOpen,
  });
}

