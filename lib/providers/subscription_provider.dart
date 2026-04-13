import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/subscription.dart';

class SubscriptionProvider extends ChangeNotifier {
  final List<Subscription> _subscriptions = [];

  List<Subscription> get subscriptions => List.unmodifiable(_subscriptions);

  Future<void> loadSubscriptions() async {
    final box = Hive.box('subscriptions');

    _subscriptions.clear();

    for (final entry in box.toMap().entries) {
      final value = entry.value;

      if (value is Map) {
        final subscription = Subscription.fromMap(
          Map<dynamic, dynamic>.from(value),
          hiveKey: entry.key,
        );
        _subscriptions.add(subscription);
      }
    }

    _subscriptions.sort((a, b) => a.renewalDate.compareTo(b.renewalDate));
    notifyListeners();
  }

  Future<void> addSubscription(Subscription subscription) async {
    final box = Hive.box('subscriptions');

    final key = await box.add(subscription.toMap());

    final savedSubscription = subscription.copyWith(hiveKey: key);

    _subscriptions.add(savedSubscription);
    _subscriptions.sort((a, b) => a.renewalDate.compareTo(b.renewalDate));
    notifyListeners();
  }

  Future<void> deleteSubscription(dynamic hiveKey) async {
    final box = Hive.box('subscriptions');

    await box.delete(hiveKey);
    _subscriptions.removeWhere(
      (subscription) => subscription.hiveKey == hiveKey,
    );
    notifyListeners();
  }
}
