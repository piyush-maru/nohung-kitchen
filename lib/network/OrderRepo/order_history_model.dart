import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:kitchen/model/GetOrderHistory.dart';
import 'package:http/http.dart' as http;
import 'package:kitchen/utils/Constants.dart';
import '../../model/KitchenData/BeanLogin.dart';
import '../../utils/Utils.dart';
import '../EndPoints.dart';

class OrderHistoryModel extends ChangeNotifier{

  GetOrderHistory? orderHistory;


  Future<GetOrderHistory?> getOrderHistory(String OrderStatus) async {
    BeanLogin userBean = await Utils.getUser();

    http.Response response = await http.post(
        Uri.parse("$testingUrl/${EndPoints.get_order_history}"),
        body: {"token": "123456789","kitchen_id": userBean.data!.id, "order_status":OrderStatus});

    if (response.statusCode == 200) {
      GetOrderHistory historyDetails = GetOrderHistory.fromJson(jsonDecode(response.body));

      notifyListeners();
      return historyDetails;
    } else {
      throw Exception("Something went wrong");
    }
  }
}