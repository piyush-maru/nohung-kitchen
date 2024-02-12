import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kitchen/model/BeanGetOrderRequest.dart';
import 'package:kitchen/model/package_detail_model.dart';
import 'package:kitchen/network/EndPoints.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:logger/logger.dart';

import '../../utils/Utils.dart';

class PackageDetailProvider extends ChangeNotifier {
  Future<PackageDetailsModel> packageDetail(
      {required String package_id,
        required String user_id,
      }) async {
    print({
      'token': "123456789",
      'user_id': user_id,
      'package_id': package_id,
    });
    http.Response response = await http
        .post(Uri.parse("$testingUrl${EndPoints.getPackageDetail}"), body: {
      'token': "123456789",
      'user_id': user_id,
      'package_id': package_id,
    });

    if (response.statusCode == 200) {
      PackageDetailsModel data =
      PackageDetailsModel.fromJson(jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Something went wrong');
    }
  }
}


