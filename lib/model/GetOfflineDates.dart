class GetOfflineDates {
  GetOfflineDates({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<OfflineData> data;

  factory GetOfflineDates.fromJson(Map<String, dynamic> json) => GetOfflineDates(
    status: json["status"],
    message: json["message"],
    data: List<OfflineData>.from(json["data"].map((x) => OfflineData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class OfflineData {
  OfflineData({
    required this.id,
    required this.date,
  });

  String id;
  DateTime date;

  factory OfflineData.fromJson(Map<String, dynamic> json) => OfflineData(
    id: json["id"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
  };
}
