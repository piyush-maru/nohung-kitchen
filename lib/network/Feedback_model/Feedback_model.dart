import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kitchen/utils/Constants.dart';
import '../../model/GetFeedback.dart';
import '../../model/KitchenData/BeanLogin.dart';
import '../../utils/Utils.dart';
import '../EndPoints.dart';

class FeedBackModel extends ChangeNotifier {

  GetFeedback? _getFeedback;

  Future<GetFeedback?> getFeedback() async {
    BeanLogin user = await Utils.getUser();

    http.Response response = await http.post(
        Uri.parse("$testingUrl/${EndPoints.get_feedback}"),
        body: {"token": "123456789", "user_id": user.data!.id});

    if (response.statusCode == 200) {
      GetFeedback feedback = GetFeedback.fromJson(json.decode(response.body));
      return feedback;
    } else {
      throw Exception("Something went wrong");
    }
  }
}
