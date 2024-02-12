import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/model/live_order_model.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/utils/Utils.dart';
import 'package:logger/logger.dart';
import '../../model/KitchenData/BeanLogin.dart';


class LiveOrderController extends ChangeNotifier {
  Future<LiveOrderModel1> live(/*String orderType*/) async {
    BeanLogin? userBean = await Utils.getUser();
    FormData from = FormData.fromMap({
      "token": "123456789",
      "kitchen_id": userBean.data!.id,
     // "page_no": 1,
     // "order_status": "all",
     // "order_type": orderType,
    });

    LiveOrderModel1? bean = await ApiProvider().liveOrdesr(/*orderType*/);
    if (bean!.status == true) {
      print("=============================>bean>>${bean!.status}");
      return bean;
    } else {
      return bean;
    }
  }
}