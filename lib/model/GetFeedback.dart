class GetFeedback {
  bool? status;
  String? message;
  Data? data;

  GetFeedback({this.status, this.message, this.data});

  GetFeedback.fromJson(Map<String, dynamic> json) {
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
  String? totalrating;
  String? totalreview;
  String? excellent;
  String? veryGood;
  String? good;
  String? fair;
  String? poor;
  List<Feedback>? feedback;

  Data(
      {this.totalrating,
        this.totalreview,
        this.excellent,
        this.veryGood,
        this.good,
        this.fair,
        this.poor,
        this.feedback});

  Data.fromJson(Map<String, dynamic> json) {
    totalrating = json['totalrating'];
    totalreview = json['totalreview'];
    excellent = json['excellent'];
    veryGood = json['very_good'];
    good = json['good'];
    fair = json['fair'];
    poor = json['poor'];
    if (json['feedback'] != null) {
      feedback = <Feedback>[];
      json['feedback'].forEach((v) {
        feedback!.add(new Feedback.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalrating'] = this.totalrating;
    data['totalreview'] = this.totalreview;
    data['excellent'] = this.excellent;
    data['very_good'] = this.veryGood;
    data['good'] = this.good;
    data['fair'] = this.fair;
    data['poor'] = this.poor;
    if (this.feedback != null) {
      data['feedback'] = this.feedback!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Feedback {
  String? orderId;
  String? orderNumber;
  String? customerName;
  String? customerPhoto;
  String? rating;
  String? message;
  String? foodquality;
  String? taste;
  String? quantity;
  String? createdtime;

  Feedback(
      {this.orderId,
        this.orderNumber,
        this.customerName,
        this.customerPhoto,
        this.rating,
        this.message,
        this.foodquality,
        this.taste,
        this.quantity,
        this.createdtime});

  Feedback.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    customerName = json['customer_name'];
    customerPhoto = json['customer_photo'];
    rating = json['rating'];
    message = json['message'];
    foodquality = json['foodquality'];
    taste = json['taste'];
    quantity = json['quantity'];
    createdtime = json['createdtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_number'] = this.orderNumber;
    data['customer_name'] = this.customerName;
    data['customer_photo'] = this.customerPhoto;
    data['rating'] = this.rating;
    data['message'] = this.message;
    data['foodquality'] = this.foodquality;
    data['taste'] = this.taste;
    data['quantity'] = this.quantity;
    data['createdtime'] = this.createdtime;
    return data;
  }
}





/*class GetFeedback {
  GetFeedback({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  FeedBackData data;

  factory GetFeedback.fromJson(Map<String, dynamic> json) => GetFeedback(
    status: json["status"],
    message: json["message"],
    data: FeedBackData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class FeedBackData {
  FeedBackData({
    required this.totalrating,
    required this.totalreview,
    required this.excellent,
    required this.veryGood,
    required this.good,
    required this.fair,
    required this.poor,
    required this.feedback,
  });

  String totalrating;
  String totalreview;
  String excellent;
  String veryGood;
  String good;
  String fair;
  String poor;
  List<Feedback> feedback;

  factory FeedBackData.fromJson(Map<String, dynamic> json) => FeedBackData(
    totalrating: json["totalrating"],
    totalreview: json["totalreview"],
    excellent: json["excellent"],
    veryGood: json["very_good"],
    good: json["good"],
    fair: json["fair"],
    poor: json["poor"],
    feedback: List<Feedback>.from(json["feedback"].map((x) => Feedback.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalrating": totalrating,
    "totalreview": totalreview,
    "excellent": excellent,
    "very_good": veryGood,
    "good": good,
    "fair": fair,
    "poor": poor,
    "feedback": List<dynamic>.from(feedback.map((x) => x.toJson())),
  };
}

class Feedback {
  Feedback({
    this.customerName,
    required this.customerPhoto,
    required this.rating,
    required this.message,
    required this.foodquality,
    required this.taste,
    required this.quantity,
    required this.createdtime,
  });

  String? customerName;
  String customerPhoto;
  String rating;
  String message;
  String foodquality;
  String taste;
  String quantity;
  DateTime createdtime;

  factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
    customerName: json["customer_name"],
    customerPhoto: json["customer_photo"],
    rating: json["rating"],
    message: json["message"],
    foodquality: json["foodquality"],
    taste: json["taste"],
    quantity: json["quantity"],
    createdtime: DateTime.parse(json["createdtime"]),
  );

  Map<String, dynamic> toJson() => {
    "customer_name": customerName,
    "customer_photo": customerPhoto,
    "rating": rating,
    "message": message,
    "foodquality": foodquality,
    "taste": taste,
    "quantity": quantity,
    "createdtime": createdtime.toIso8601String(),
  };
}*/




// GetFeedback getFeedbackFromJson(String str) =>
//     GetFeedback.fromJson(json.decode(str));
//
// String getFeedbackToJson(GetFeedback data) => json.encode(data.toJson());
//
// class GetFeedback {
//   GetFeedback({
//     this.status,
//     this.message,
//     this.data,
//   });
//
//   bool? status;
//   String? message;
//   Data? data;
//
//   factory GetFeedback.fromJson(Map<String, dynamic> json) => GetFeedback(
//         status: json["status"],
//         message: json["message"],
//         data: Data.fromJson(json["data"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "data": data!.toJson(),
//       };
// }
//
// class Data {
//   Data({
//     this.totalrating,
//     this.totalreview,
//     this.excellent,
//     this.good,
//     this.average,
//     this.poor,
//     this.fair,
//     this.feedback,
//   });
//
//   String? totalrating;
//   String? totalreview;
//   String? excellent;
//   String? good;
//   String? average;
//   String? poor;
//   String? fair;
//   List<Feedback>? feedback;
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         totalrating: json["totalrating"],
//         totalreview: json["totalreview"],
//         excellent: json["excellent"],
//         good: json["good"],
//         average: json["average"],
//         fair: json['fair'],
//         poor: json["poor"],
//
//         feedback: List<Feedback>.from(
//             json["feedback"].map((x) => Feedback.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "totalrating": totalrating,
//         "totalreview": totalreview,
//         "excellent": excellent,
//         "good": good,
//         "average": average,
//         "poor": poor,
//         "fair":fair,
//         "feedback": List<dynamic>.from(feedback!.map((x) => x.toJson())),
//       };
// }
//
// class Feedback {
//   Feedback({
//     this.customerName,
//     this.customerPhoto,
//     this.rating,
//     this.message,
//     this.createdtime,
//     this.foodQuality,
//     this.taste,
//     this.quantity,
//   });
//
//   String? customerName;
//   String? customerPhoto;
//   String? rating;
//   String? message;
//   String? foodQuality;
//   String? taste;
//   String? quantity;
//   DateTime? createdtime;
//
//   factory Feedback.fromJson(Map<String, dynamic> json) => Feedback(
//         customerName: json["customer_name"],
//         customerPhoto: json["customer_photo"],
//         rating: json["rating"],
//         message: json["message"],
//         foodQuality: json["foodquality"],
//         taste: json["taste"],
//         quantity: json["quantity"],
//         createdtime: DateTime.parse(json["createdtime"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "customer_name": customerName,
//         "customer_photo": customerPhoto,
//         "rating": rating,
//         "message": message,
//         "foodquality": foodQuality,
//         "taste": taste,
//         "quantity": quantity,
//         "createdtime": createdtime!.toIso8601String(),
//       };
// }
