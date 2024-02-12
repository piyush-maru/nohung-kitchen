
class AddOfflineData {
  AddOfflineData({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<dynamic> data;

  factory AddOfflineData.fromJson(Map<String, dynamic> json) => AddOfflineData(
    status: json["status"],
    message: json["message"],
    data: List<dynamic>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}
