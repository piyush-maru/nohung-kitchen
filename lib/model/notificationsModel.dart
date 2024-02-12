class NotificationModel {
  NotificationModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<NotificationData> data;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    status: json["status"],
    message: json["message"],
    data: List<NotificationData>.from(json["data"].map((x) => NotificationData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NotificationData {
  NotificationData({
    required this.senderName,
    required this.senderImage,
    required this.message,
    required this.type,
    required this.time,
  });

  String senderName;
  String senderImage;
  String  message;
  String  type;
  String time;

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    senderName: json["sender_name"],
    senderImage: json["sender_image"],
    message: json["message"],
    type: json["type"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "sender_name": senderName,
    "sender_image": senderImage,
    "message": message,
    "type": type,
    "time": time,
  };
}

