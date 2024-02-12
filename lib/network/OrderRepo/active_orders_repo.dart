import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../model/GetActiveOrder.dart';
import 'package:http/http.dart' as http;

import '../../model/KitchenData/BeanLogin.dart';
import '../../utils/Constants.dart';
import '../../utils/Utils.dart';
import '../ApiProvider.dart';
import '../EndPoints.dart';
class ActiveOrderModel extends ChangeNotifier{

  GetActiveOrder? getActiveOrder;

  Future<GetActiveOrder> getActiveOrders() async {
    BeanLogin userBean = await Utils.getUser();
    print("$testingUrl${EndPoints.get_active_orders}");
    print( {
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
      "filter_fromdate": "",
      "filter_todate": "",
      "filter_order_number": ""
    });
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.get_active_orders}"), body: {
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
      "filter_fromdate": "",
      "filter_todate": "",
      "filter_order_number": ""
    });
    if (response.statusCode == 200) {
      GetActiveOrder activeOrder= GetActiveOrder.fromJson(json.decode(response.body),);
      print(response.body);
      return activeOrder;
    } else {
      throw Exception("Something went wrong");
    }
  }

}