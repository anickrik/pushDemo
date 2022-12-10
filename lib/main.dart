
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/route_manager.dart';
import 'package:pushdemo/services/notification_services.dart';

import 'home_screen.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  print("firebase push: on background ");
  final value = message.data;
  print("firebase push: $value");
  print("firebase push: $notification");
}

  // when remote message contain Data

  // flutterLocalNotificationsPlugin.show(
  //   notification.hashCode,
  //   value['title'],
  //   value['body'],
  //   platformChannelSpecifics,
  //   payload: value['navigateTo'],
  // );
// }

/*
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
*/
AndroidNotificationDetails channel = const AndroidNotificationDetails("high_importance_channel", "FMC Demo",priority: Priority.max, importance: Importance.max);


const AndroidNotificationDetails _androidNotificationDetails =
AndroidNotificationDetails(
  'high_importance_channel',
  'High Importance Channel',
  playSound: true,
  priority: Priority.max,
  importance: Importance.max,
);

const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
  presentAlert: true,
  presentBadge: true,
  presentSound: true,
  // badgeNumber: int?
  // attachments: List<IOSNotificationAttachment>?
  // subtitle: String?,
  // threadIdentifier: String?
);

NotificationDetails platformChannelSpecifics = const NotificationDetails(
    android: _androidNotificationDetails,
    iOS: darwinNotificationDetails
);



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);



/*  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  await NotificationService().requestIOSPermissions(flutterLocalNotificationsPlugin);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);*/
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Push Notification'),
    );
  }
}
