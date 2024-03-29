// ignore_for_file: deprecated_member_use

import 'package:kitchen/model/GetCategoryItems.dart';

class EditCategoryItem {
  bool? status;
  String? message;
  List<dynamic>? data;

  EditCategoryItem({this.status, this.message, this.data});

  EditCategoryItem.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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