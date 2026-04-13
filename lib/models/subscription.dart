class Subscription {
  final String name;
  final double price;
  final DateTime renewalDate;
  final String location;
  final DateTime createdAt;

  Subscription({
    required this.name,
    required this.price,
    required this.renewalDate,
    required this.location,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'renewalDate': renewalDate.toIso8601String(),
      'location': location,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Subscription.fromMap(Map<dynamic, dynamic> map) {
    return Subscription(
      name: map['name']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      renewalDate:
          DateTime.tryParse(map['renewalDate']?.toString() ?? '') ??
          DateTime.now(),
      location: map['location']?.toString() ?? 'Unknown location',
      createdAt:
          DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
