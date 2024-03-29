class BeanSendMessage {
  bool? status;
  String? message;
  Data? data;

  BeanSendMessage({this.status, this.message, this.data});

  BeanSendMessage.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? msgType;
  String? kitchenid;
  String? foodiesid;
  String? message;
  String? createddate;

  Data(
      {this.msgType,
        this.kitchenid,
        this.foodiesid,
        this.message,
        this.createddate});

  Data.fromJson(Map<String, dynamic> json) {
    msgType = json['msg_type'];
    kitchenid = json['kitchenid'];
    foodiesid = json['foodiesid'];
    message = json['message'];
    createddate = json['createddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg_type'] = this.msgType;
    data['kitchenid'] = this.kitchenid;
    data['foodiesid'] = this.foodiesid;
    data['message'] = this.message;
    data['createddate'] = this.createddate;
    return data;
  }
}