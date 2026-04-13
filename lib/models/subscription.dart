class Subscription {
  final String id;
  final dynamic hiveKey;
  final String name;
  final double price;
  final DateTime renewalDate;
  final String location;
  final DateTime createdAt;

  Subscription({
    required this.id,
    required this.hiveKey,
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

  factory Subscription.fromMap(Map<dynamic, dynamic> map, {dynamic hiveKey}) {
    final createdAt =
        DateTime.tryParse(map['createdAt']?.toString() ?? '') ?? DateTime.now();

    return Subscription(
      id: map['id']?.toString().isNotEmpty == true
          ? map['id'].toString()
          : createdAt.microsecondsSinceEpoch.toString(),
      hiveKey: hiveKey,
      name: map['name']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      renewalDate:
          DateTime.tryParse(map['renewalDate']?.toString() ?? '') ??
          DateTime.now(),
      location: map['location']?.toString() ?? 'Unknown location',
      createdAt: createdAt,
    );
  }

  Subscription copyWith({
    String? id,
    dynamic hiveKey,
    String? name,
    double? price,
    DateTime? renewalDate,
    String? location,
    DateTime? createdAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      hiveKey: hiveKey ?? this.hiveKey,
      name: name ?? this.name,
      price: price ?? this.price,
      renewalDate: renewalDate ?? this.renewalDate,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
