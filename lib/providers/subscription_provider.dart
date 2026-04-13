import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/subscription.dart';

class SubscriptionProvider extends ChangeNotifier {
  final List<Subscription> _subscriptions = [];

  List<Subscription> get subscriptions => List.unmodifiable(_subscriptions);

  Future<void> loadSubscriptions() async {
    final box = Hive.box('subscriptions');
    final storedItems = box.values.toList();

    _subscriptions
      ..clear()
      ..addAll(
        storedItems
            .map(
              (item) => Subscription.fromMap(Map<dynamic, dynamic>.from(item)),
            )
            .toList(),
      );

    _subscriptions.sort((a, b) => a.renewalDate.compareTo(b.renewalDate));
    notifyListeners();
  }

  Future<void> addSubscription(Subscription subscription) async {
    final box = Hive.box('subscriptions');

    await box.put(subscription.id, subscription.toMap());

    _subscriptions.add(subscription);
    _subscriptions.sort((a, b) => a.renewalDate.compareTo(b.renewalDate));
    notifyListeners();
  }

  Future<void> deleteSubscription(String id) async {
    final box = Hive.box('subscriptions');

    await box.delete(id);
    _subscriptions.removeWhere((subscription) => subscription.id == id);
    notifyListeners();
  }
}
