

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:pushdemo/detail_screen.dart';
import 'package:pushdemo/services/fmc_token.dart';
import 'package:pushdemo/services/notification_services.dart';

import 'list_screen.dart';



FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  FMCTokenService fmcTokenService = FMCTokenService();
  // String fmcToken = '';

  //
  // void showNotification(){
  //   AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails("fmc_demo", "FMC Demo",priority: Priority.max, importance: Importance.max);
  //   DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: true,
  //   );
  //
  //   NotificationDetails notificationDetails =NotificationDetails(
  //     android: androidNotificationDetails,
  //     iOS: darwinNotificationDetails,
  //   );
  //
  //   flutterLocalNotificationsPlugin.show(01, "Test", "this is the body of notification", notificationDetails, payload: "notification_payload");
  // }


  static const AndroidNotificationDetails _androidNotificationDetails =
  AndroidNotificationDetails(
    'high_importance_channel',
    'channel name',
    priority: Priority.max,
    importance: Importance.max,
  );

  static const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    // badgeNumber: int?
    // attachments: List<IOSNotificationAttachment>?
    // subtitle: String?,
    // threadIdentifier: String?
  );

  NotificationDetails platformChannelSpecifics =
  const NotificationDetails(
      android: _androidNotificationDetails,
      iOS: darwinNotificationDetails
  );

  Future<void> showNotifications() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'Notification Title',
      'This is the Notification Body',
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainMethod();
    checkForNotification();
    fmcTokenService.getToken();
  }
  //
  // String getToken() {
  //   fmcToken = fmcTokenService.getToken().then((value) => print(fmcToken)) as String;
  //   print('token : $fmcToken');
  //   return fmcToken;
  // }

 /* @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    print("firebase push: on background ");
    final value = message.data;
    print("firebase push: $value");
    print("firebase push: $notification");
  }*/

  Future<void> mainMethod() async {
    await NotificationService().init();
    await NotificationService().requestIOSPermissions(flutterLocalNotificationsPlugin);
  }

 void checkForNotification() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("firebase push: on foreground ");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      final value = message.data;
      print("firebase push: $notification");
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification?.title,
        notification?.body,
        platformChannelSpecifics,
        payload: value['navigateTo'],
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("firebase push: on openedApp ");
      print("firebase push: data ${message.data} ");
      // RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;
      final payloadData = message.data['navigateTo'];
      if(payloadData != null && payloadData.isNotEmpty){
        if(payloadData == 'details'){
          await Get.to(() => DetailScreen(title: payloadData,));
        }
        if(payloadData == 'list'){
          await Get.to(() => ListScreen(title: payloadData,));
        }
      }
    });


    RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    print("firebase push: get Initial Message ");
    print("firebase push: data ${remoteMessage?.data} ");

    if(remoteMessage != null){
      final payloadData = remoteMessage.data['navigateTo'];
      if(payloadData != null && payloadData.isNotEmpty){
        if(payloadData == 'details'){
          await Get.to(() => DetailScreen(title: payloadData,));
        }
        if(payloadData == 'list'){
          await Get.to(() => ListScreen(title: payloadData,));
        }
      }
      }
      // return;
    // //
    // NotificationAppLaunchDetails? details = await
    //     flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    // if(details != null){
    //   if(details.didNotificationLaunchApp){
    //     print("firebase push:  didNotificationLaunchApp = ${details.didNotificationLaunchApp} ");

        // NotificationResponse? response = details.notificationResponse;
        // if(response != null){
        //   String? payload = response.payload;
        //   log("Notification Payload : $payload");
        // }
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            // ElevatedButton(onPressed: () => getToken(), child: const Text("get token")),
            // Text(
            //   fmcToken,
            //   style: Theme.of(context).textTheme.headline4,
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNotifications,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
