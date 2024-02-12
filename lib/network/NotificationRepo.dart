import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:kitchen/utils/Constants.dart';
import '../model/KitchenData/BeanLogin.dart';
import '../model/notificationsModel.dart';
import '../utils/Utils.dart';
import 'EndPoints.dart';

class NotifyModel extends ChangeNotifier {
  NotificationModel? notificationModel;
  Future<NotificationModel> getNotifications() async {
    BeanLogin user = await Utils.getUser();

    final http.Response response = await http.post(
        Uri.parse("$testingUrl${EndPoints.get_notification}"),
        body: {"token": "123456789", "kitchen_id": user.data!.id});

    if (response.statusCode == 200) {
      NotificationModel notify =
          NotificationModel.fromJson(json.decode(response.body));
      return notify;
    } else {
      throw Exception("Something went wrong");
    }
  }
}
