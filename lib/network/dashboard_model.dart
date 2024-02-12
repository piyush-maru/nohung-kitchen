import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kitchen/network/EndPoints.dart';
import 'package:kitchen/utils/Constants.dart';
import '../model/KitchenData/BeanGetDashboard.dart';
import '../model/KitchenData/BeanLogin.dart';
import '../utils/Utils.dart';

class DashboardModel extends ChangeNotifier {
  BeanGetDashboard? beanGetDashboard;

  Future<BeanGetDashboard> getHomeScreen() async {

    BeanLogin beanLogin = await Utils.getUser();
    http.Response response = await http.post(
        Uri.parse("$testingUrl${EndPoints.get_dashboard_detail}"),
        body: {"token": "123456789", "kitchen_id": beanLogin.data!.id});

    if (response.statusCode == 200) {
      BeanGetDashboard dashboard =
          BeanGetDashboard.fromJson(json.decode(response.body));
      return dashboard;
    } else {
      throw Exception("Something went wrong");
    }
  }
}
