import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:kitchen/utils/Constants.dart';
import '../model/GetOfflineDates.dart';
import '../model/KitchenData/GetAccountDetail.dart';
import '../utils/Utils.dart';
import 'EndPoints.dart';

class KitchenDetailsModel extends ChangeNotifier {
  GetAccountDetails? getKitchenDetails;

  Future<GetAccountDetails?> getAccountDetails() async {
    final userBean = await Utils.getUser();
    http.Response response = await http.post(
        Uri.parse("$testingUrl${EndPoints.get_account_detail}"),
        body: {"user_id": userBean.data!.id, "token": "123456789"});

    if (response.statusCode == 200) {
      GetAccountDetails accountDetails =
          GetAccountDetails.fromJson(json.decode(response.body));
      print("=================1>${response.body}");
      print("=================1>${userBean.data!.id}");
      return accountDetails;
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<GetOfflineDates> getOfflineDates() async {
    final userBean = await Utils.getUser();
    http.Response response = await http.post(
        Uri.parse("$testingUrl${EndPoints.get_offline_dates}"),
        body: {"token": "123456789", "kitchen_id": "${userBean.data!.id}"});
    if (response.statusCode == 200) {
      GetOfflineDates getOfflineDates =
          GetOfflineDates.fromJson(json.decode(response.body));
      return getOfflineDates;
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<String> addOfflineDates(dates) async {
    final userBean = await Utils.getUser();
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.add_offile_dates}"), body: {
      "token": "123456789",
      "kitchen_id": "${userBean.data!.id}",
      "dates": jsonEncode(
          dates.map((e) => DateFormat('yyyy-MM-dd').format(e)).toList())
    });

    if (response.statusCode == 200) {
    } else {
      throw Exception("Something went wrong");
    }
    return response.body;

  }

}
