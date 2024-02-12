
import 'package:kitchen/model/KitchenData/BeanLogin.dart';

class BeanLunchAdd {
  bool? status;
  String? message;
  List<UserData>? data;

  BeanLunchAdd({this.status, this.message, this.data});

  BeanLunchAdd.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new UserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
