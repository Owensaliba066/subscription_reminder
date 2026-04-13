import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:subscription_reminder/main.dart';
import 'package:subscription_reminder/services/notification_service.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Hive.initFlutter();
    await Hive.openBox('subscriptions');
    await NotificationService.initialize();
  });

  testWidgets('App loads home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SubscriptionReminderApp());
    await tester.pumpAndSettle();

    expect(find.text('Subscription Reminder'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
