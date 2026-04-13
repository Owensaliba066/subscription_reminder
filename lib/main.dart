import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'providers/subscription_provider.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('subscriptions');
  await NotificationService.initialize();

  runApp(const SubscriptionReminderApp());
}

class SubscriptionReminderApp extends StatelessWidget {
  const SubscriptionReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SubscriptionProvider()..loadSubscriptions(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Subscription Reminder',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
