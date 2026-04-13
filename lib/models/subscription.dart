class Subscription {
  final String id;
  final String name;
  final double price;
  final DateTime renewalDate;
  final String location;
  final DateTime createdAt;

  Subscription({
    required this.id,
    required this.name,
    required this.price,
    required this.renewalDate,
    required this.location,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'renewalDate': renewalDate.toIso8601String(),
      'location': location,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Subscription.fromMap(Map<dynamic, dynamic> map) {
    final createdAt =
        DateTime.tryParse(map['createdAt']?.toString() ?? '') ?? DateTime.now();

    return Subscription(
      id: map['id']?.toString().isNotEmpty == true
          ? map['id'].toString()
          : createdAt.microsecondsSinceEpoch.toString(),
      name: map['name']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      renewalDate:
          DateTime.tryParse(map['renewalDate']?.toString() ?? '') ??
          DateTime.now(),
      location: map['location']?.toString() ?? 'Unknown location',
      createdAt: createdAt,
    );
  }
}
