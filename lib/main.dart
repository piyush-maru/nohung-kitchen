import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 import 'package:intl/intl.dart';
import 'package:kitchen/Menu/AddMealScreen.dart';
import 'package:kitchen/Menu/MenuITemSelectedScreen.dart';
import 'package:kitchen/Order/OrderScreen.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/network/Delivery/Get_delivery.dart';
import 'package:kitchen/network/Feedback_model/Feedback_model.dart';
import 'package:kitchen/network/NotificationRepo.dart';
import 'package:kitchen/network/OrderRepo/active_orders_repo.dart';
import 'package:kitchen/network/OrderRepo/live_order_model.dart';
import 'package:kitchen/network/OrderRepo/order_history_model.dart';
import 'package:kitchen/network/OrderRepo/order_request_model.dart';
import 'package:kitchen/network/UserModel.dart';
import 'package:kitchen/network/dashboard_model.dart';
import 'package:kitchen/network/package_detail_provider.dart';
import 'package:kitchen/src/presentation/screens/CustomerChatScreen.dart';
import 'package:kitchen/src/presentation/screens/DashboardScreen.dart';
import 'package:kitchen/src/presentation/screens/ForgotPasswordScreen.dart';
import 'package:kitchen/src/presentation/screens/HomeBaseScreen.dart';
import 'package:kitchen/src/presentation/screens/LoginSignUpScreen.dart';
import 'package:kitchen/src/presentation/screens/SplashScreen.dart';
import 'package:kitchen/src/providers/audio_player_provider/audio_player_provider.dart';
import 'package:kitchen/utils/Log.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network/PaymentRepo/PaymentModel.dart';
import 'network/kitchen_screen_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // LocalNotificationService.initialize();
  // await FirebaseMessaging.instance.getInitialMessage();

  // FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
  final token = await FirebaseMessaging.instance.getToken();
  print("token is $token");

  FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
    print("nikhil");
    await ApiProvider().addFirebaseToken(token);
  });

  _initLog();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) async {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserModel()),
          ChangeNotifierProvider(create: (context) => FeedBackModel()),
          ChangeNotifierProvider(create: (context) => GetDeliveryModel()),
          ChangeNotifierProvider(create: (context) => NotifyModel()),
          ChangeNotifierProvider(create: (context) => AudioPlayerProvider()),
          ChangeNotifierProvider(
              create: (context) => TransactionHistoryModel()),
          ChangeNotifierProvider(create: (context) => KitchenDetailsModel()),
          ChangeNotifierProvider(create: (context) => OrderHistoryModel()),
          ChangeNotifierProvider(create: (context) => OrderRequestModel()),
          ChangeNotifierProvider(create: (context) => LiveOrderController()),
          ChangeNotifierProvider(create: (context) => DashboardModel()),
          ChangeNotifierProvider(create: (context) => ActiveOrderModel()),
          ChangeNotifierProvider(create: (context) => PackageDetailProvider())
        ],
        child: App(),
      ),
    );
  });
}

void _initLog() async {
  Log.init();
  Log.setLevel(Level.ALL);
  await Firebase.initializeApp();
}
//

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

String dateTimeFormat(String time, String format) {
  return DateFormat(format).format(DateTime.parse(time));
}

class AppState extends State<App> {
  late final FirebaseMessaging _messaging;

  requestFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // TODO: handle the received notifications
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
      print('User declined or has not accepted permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  void initState() {
    super.initState();
    requestFCM();
  }

  // static Future init(
  //     {required FlutterLocalNotificationsPlugin
  //         flutterLocalNotificationsPlugin}) async {
  //   var initAndroidSettings =
  //       AndroidInitializationSettings("mipmap/ic_launcher");
  //   var ios = DarwinInitializationSettings();
  //   final initializationSettings =
  //       InitializationSettings(android: initAndroidSettings, iOS: ios);
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  // static Future notificationDetails(
  //     {var id = 0,
  //     required String title,
  //     required String body,
  //     var payload,
  //     required FlutterLocalNotificationsPlugin
  //         flutterLocalNotificationsPlugin}) async {
  //   AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //           "high_importance_channel5", "high_importance_channel6",
  //           importance: Importance.max,
  //           sound: RawResourceAndroidNotificationSound("kitchen"),
  //           priority: Priority.max,
  //           playSound: true);
  //
  //   var not = NotificationDetails(android: androidNotificationDetails);
  //   await flutterLocalNotificationsPlugin.show(0, title, body, not);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Food App",
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) => makeRoute(
                context: context,
                routeName: settings.name ?? "",
                arguments: settings.arguments ?? ""),
            maintainState: true,
            fullscreenDialog: false,
          );
        });
  }

  Widget makeRoute(
      {@required BuildContext? context,
      @required String? routeName,
      Object? arguments}) {
    final Widget child = _buildRoute(
        context: context!, routeName: routeName ?? '', arguments: arguments!);
    return child;
  }

  Widget _buildRoute({
    @required BuildContext? context,
    @required String? routeName,
    Object? arguments,
  }) {
    switch (routeName) {
      case '/':
        return SplashScreen();
      case '/loginSignUp':
        return LoginSignUpScreen();
      case '/homebase':
        return HomeBaseScreen();
      case '/dashboard':
        return DashboardScreen(false);
      case '/addMeals':
        return AddMealScreen();
      case '/forgot':
        return ForgotPasswordScreen();
      case '/menuItemSelected':
        return MenuITemSelectedScreen();
      case '/userLogin':
        return UserLogin();
      case '/adminChat':
        return CustomerChatScreen();
      case '/orders':
        return OrderScreen(false, 0);

      // case '/notifications':
      //   return Notifications();
      default:
        throw 'Route $routeName is not defined';
    }
  }
}


Future<bool?> getKitchenStatus() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool('kitchen_status');
}

Future<bool> saveKitchenStatus(bool kitchenStatus) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.setBool("kitchen_status", kitchenStatus);
}

Future<int?> getOrdersRequestCount() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getInt('orders_request_count');
}

Future<bool> saveOrdersRequestCount(int ordersCount) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.setInt("orders_request_count", ordersCount);
}
