import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import 'add_subscription_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Reminder'),
        centerTitle: true,
      ),
      body: Consumer<SubscriptionProvider>(
        builder: (context, provider, child) {
          final subscriptions = provider.subscriptions;

          if (subscriptions.isEmpty) {
            return const _EmptyState();
          }

          return _SubscriptionList(subscriptions: subscriptions);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddSubscriptionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.subscriptions_outlined,
              size: 80,
              color: Colors.blueGrey,
            ),
            SizedBox(height: 16),
            Text(
              'No subscriptions added yet.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add your first subscription.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionList extends StatelessWidget {
  final List<Subscription> subscriptions;

  const _SubscriptionList({required this.subscriptions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: subscriptions.length,
      itemBuilder: (context, index) {
        return _SubscriptionCard(subscription: subscriptions[index]);
      },
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final Subscription subscription;

  const _SubscriptionCard({required this.subscription});

  int _daysRemaining(DateTime renewalDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(
      renewalDate.year,
      renewalDate.month,
      renewalDate.day,
    );

    return target.difference(today).inDays;
  }

  String _buildRemainingText(int days) {
    if (days < 0) {
      return 'Renewal date passed';
    }
    if (days == 0) {
      return 'Due today';
    }
    if (days == 1) {
      return '1 day remaining';
    }
    return '$days days remaining';
  }

  @override
  Widget build(BuildContext context) {
    final days = _daysRemaining(subscription.renewalDate);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.subscriptions)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    subscription.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete Subscription'),
                          content: Text(
                            'Are you sure you want to delete "${subscription.name}"?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );

                    if (shouldDelete == true) {
                      await context
                          .read<SubscriptionProvider>()
                          .deleteSubscription(subscription.id);

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${subscription.name} deleted successfully.',
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.euro, size: 18),
                const SizedBox(width: 6),
                Text(
                  subscription.price.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 6),
                Text(
                  DateFormat('dd/MM/yyyy').format(subscription.renewalDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    subscription.location,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: days <= 3 ? Colors.orange.shade100 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _buildRemainingText(days),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: days <= 3
                      ? Colors.orange.shade900
                      : Colors.blue.shade900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
