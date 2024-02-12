import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kitchen/model/BeanGetOrderRequest.dart';
import 'package:kitchen/network/EndPoints.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:logger/logger.dart';

import '../../utils/Utils.dart';

class OrderRequestModel extends ChangeNotifier {
  BeanGetOrderRequest? getOrderRequest;
  Logger log = Logger();

  Future<BeanGetOrderRequest> orderRequest() async {
    final userBean = await Utils.getUser();
    http.Response response = await http.post(
        Uri.parse("$testingUrl${EndPoints.get_orders_requests}"),
        body: {"token": "123456789", "kitchen_id": userBean.data!.id});
    print("userID");
    if (response.statusCode == 200) {
      BeanGetOrderRequest beanGetOrderRequest = BeanGetOrderRequest.fromJson(json.decode(response.body));
      // log.e(json.decode(response.body));

      return beanGetOrderRequest;
    } else {
      throw Exception("Something went wrong");
    }
  }
}


