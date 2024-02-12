import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:kitchen/utils/Constants.dart';
import '../../model/GetTrackDeliveries.dart';
import 'package:http/http.dart' as http;
import '../../model/KitchenData/BeanLogin.dart';
import '../../utils/Utils.dart';
import '../EndPoints.dart';
class GetDeliveryModel extends ChangeNotifier{

  Future<GetTrackDeliveries?> geTrackDeliveries() async {
    BeanLogin user = await Utils.getUser();
      http.Response response =
      await http.post(Uri.parse("$testingUrl/${EndPoints.get_track_deliveries}"), body: {
        "kitchen_id": user.data!.id,
        "token": "123456789",
      });
      if(response.statusCode==200) {
       GetTrackDeliveries deliveries =GetTrackDeliveries.fromJson(json.decode(response.body));
       return deliveries;
      }else{
        throw Exception("Something went wrong");
      }
  }
}