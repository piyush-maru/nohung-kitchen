// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class LocalNotificationService {
//   static final FlutterLocalNotificationsPlugin localNotificationsPlugins =
//       FlutterLocalNotificationsPlugin();
//
//   static void initialize() {
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: AndroidInitializationSettings("mipmap/ic_launcher"));
//     localNotificationsPlugins.initialize(initializationSettings);
//   }
//
//   static void display(RemoteMessage remoteMessage) async {
//     final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//     var initializationSettingsAndroid =
//         new AndroidInitializationSettings('ic_stat_transparent_kitchen');
//
//     final NotificationDetails notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//             "high_importance_channel", "Nohung Kitchen Channel",
//             importance: Importance.high,
//             priority: Priority.high,
//             styleInformation: BigPictureStyleInformation(
//                 const DrawableResourceAndroidBitmap("drawable/ic_stat_transparent_kitchen")),
//             largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
//             icon: initializationSettingsAndroid.defaultIcon));
//     await localNotificationsPlugins.initialize(InitializationSettings(
//       android: AndroidInitializationSettings("drawable/ic_stat_transparent_kitchen"),
//     ));
//     // await localNotificationsPlugins.show(id, remoteMessage.notification!.title,
//     //     remoteMessage.notification!.body, notificationDetails);
//   }
// }
