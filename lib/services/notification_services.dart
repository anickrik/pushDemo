
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:pushdemo/detail_screen.dart';
import 'package:pushdemo/list_screen.dart';


class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService =
  NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  //instance of FlutterLocalNotificationsPlugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  Future<void> init() async {

    //Initialization Settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    //Initialization Settings for iOS
    DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
        onDidReceiveLocalNotification:
            (int? id, String? title, String? body, String? payload) async {}
    );

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);

    // final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    // await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    // final didNotificationLaunchApp =
    //     notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
    //
    // if (didNotificationLaunchApp) {
    //
    //   print("on launch app state");
    //
    //   var payload = notificationAppLaunchDetails?.notificationResponse;
    //   print("$payload");
    //   onSelectNotification(payload!);
    // } else {
    //   await flutterLocalNotificationsPlugin.initialize(
    //       initializationSettings,
    //       // onDidReceiveBackgroundNotificationResponse:onSelectNotification,
    //       onDidReceiveNotificationResponse:onSelectNotification,
    //   );
    //       }

    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
         onDidReceiveNotificationResponse:onSelectNotification,

          // when i use below function it shows me this error
          // onDidReceiveBackgroundNotificationResponse: onSelectNotification,
    );

  }

  Future<void> requestIOSPermissions(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }


   Future onSelectNotification(NotificationResponse notificationResponse) async {
    print("firebase: onSelect Notification ");
    final payloadData = notificationResponse.payload;
    print("payload $payloadData");
    if(payloadData != null && payloadData.isNotEmpty){
      if(payloadData == 'details'){
        await Get.to(() => DetailScreen(title: payloadData,));
      }
      if(payloadData == 'list'){
        await Get.to(() => ListScreen(title: payloadData,));
      }
    }
  }

  //
  // Future didReceiveBackgroundNotificationResponse(NotificationResponse response) async{
  //   print(" In DidReceiveBackgroundNotificationResponse");
  //   String? title = response.payload;
  //   if(title != null && title.isNotEmpty){
  //     await Get.to(() => DetailScreen(title: title,));
  //   }
  //   log("No Data in payload");
  // }
  //
  // Future didReceiveNotificationResponse(NotificationResponse response) async {
  //   print("in didReceiveNotificationResponse");
  //   String? title = response.payload;
  //   if(title != null && title.isNotEmpty){
  //     await Get.to(() => DetailScreen(title: title,));
  //   }
  //   log("No Data in payload");
  // }

}
