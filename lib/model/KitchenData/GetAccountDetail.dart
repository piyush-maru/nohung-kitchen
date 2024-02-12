//
//
//
// class GetAccountDetails {
//   bool? status;
//   String? message;
//   Data? data;
//
//   GetAccountDetails({this.status, this.message, this.data});
//
//   GetAccountDetails.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   String? userId;
//   String? kitchenId;
//   String? kitchenName;
//   String? description;
//   String? address;
//   String? email;
//   String? mobileNumber;
//   String? password;
//   String? typeOfFirm;
//   List<String>? typeOfFood;
//   List<ShiftTiming>? shiftTiming;
//   List<String>? openDays;
//   List<String>? typeOfMeals;
//   String? totalRating;
//   String? menuFile;
//   String? documentFile;
//   String? profileImage;
//   String? availableStatus;
//   String? breakfastFromTime;
//   String? breakfastToTime;
//   String? lunchFromTime;
//   String? lunchToTime;
//   String? dinnerFromTime;
//   String? dinnerToTime;
//
//   Data(
//       {this.userId,
//         this.kitchenId,
//         this.kitchenName,
//         this.description,
//         this.address,
//         this.email,
//         this.mobileNumber,
//         this.password,
//         this.typeOfFirm,
//         this.typeOfFood,
//         this.shiftTiming,
//         this.openDays,
//         this.typeOfMeals,
//         this.totalRating,
//         this.menuFile,
//         this.documentFile,
//         this.profileImage,
//         this.availableStatus,
//         this.breakfastFromTime,
//         this.breakfastToTime,
//         this.lunchFromTime,
//         this.lunchToTime,
//         this.dinnerFromTime,
//         this.dinnerToTime});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     userId = json['user_id']??"";
//     kitchenId = json['kitchenid']??"";
//     kitchenName = json['kitchen_name']??"";
//     description = json['description']??"";
//     address = json['address']??"";
//     email = json['email']??"";
//     mobileNumber = json['mobile_number']??"";
//     password = json['password']??"";
//     typeOfFirm = json['type_of_firm']??"";
//     typeOfFood = json['type_of_food'];
//     if (json['shift_timing'] != null) {
//       shiftTiming = <ShiftTiming>[];
//       json['shift_timing'].forEach((v) {
//         shiftTiming!.add(new ShiftTiming.fromJson(v));
//       });
//     }
//     openDays = json['open_days'];
//     typeOfMeals = json['type_of_meals'];
//     totalRating = json['totalrating']??"";
//     menuFile = json['menufile']??"";
//     documentFile = json['documentfile']??"";
//     profileImage = json['profile_image']??"";
//     availableStatus = json['available_status']??"";
//     breakfastFromTime = json['breakfast_fromtime']??"";
//     breakfastToTime = json['breakfast_totime']??"";
//     lunchFromTime = json['lunch_fromtime']??"";
//     lunchToTime = json['lunch_totime']??"";
//     dinnerFromTime = json['dinner_fromtime']??"";
//     dinnerToTime = json['dinner_totime']??"";
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['user_id'] = this.userId;
//     data['kitchenid'] = this.kitchenId;
//     data['kitchen_name'] = this.kitchenName;
//     data['description'] = this.description;
//     data['address'] = this.address;
//     data['email'] = this.email;
//     data['mobile_number'] = this.mobileNumber;
//     data['password'] = this.password;
//     data['type_of_firm'] = this.typeOfFirm;
//     data['type_of_food'] = this.typeOfFood;
//     if (this.shiftTiming != null) {
//       data['shift_timing'] = this.shiftTiming!.map((v) => v.toJson()).toList();
//     }
//     data['open_days'] = this.openDays;
//     data['type_of_meals'] = this.typeOfMeals;
//     data['totalrating'] = this.totalRating;
//     data['menufile'] = this.menuFile;
//     data['documentfile'] = this.documentFile;
//     data['profile_image'] = this.profileImage;
//     data['available_status'] = this.availableStatus;
//     data['breakfast_fromtime'] = this.breakfastFromTime;
//     data['breakfast_totime'] = this.breakfastToTime;
//     data['lunch_fromtime'] = this.lunchFromTime;
//     data['lunch_totime'] = this.lunchToTime;
//     data['dinner_fromtime'] = this.dinnerFromTime;
//     data['dinner_totime'] = this.dinnerToTime;
//     return data;
//   }
// }
//
// class ShiftTiming {
//   String? fromTime;
//   String? toTime;
//
//   ShiftTiming({this.fromTime, this.toTime});
//
//   ShiftTiming.fromJson(Map<String, dynamic> json) {
//     fromTime = json['from_time'];
//     toTime = json['to_time'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['from_time'] = this.fromTime;
//     data['to_time'] = this.toTime;
//     return data;
//   }
// }




/*class GetAccountDetails {
  bool status;
  String message;
  Data data;

  GetAccountDetails({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetAccountDetails.fromJson(Map<String, dynamic> json) => GetAccountDetails(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String userId;
  String kitchenId;
  String kitchenName;
  String description;
  String address;
  String email;
  String mobileNumber;
  String password;
  String typeOfFirm;
  List<String> typeOfFood;
  List<ShiftTiming> shiftTiming;
  List<String> openDays;
  List<String> typeOfMeals;
  String totalRating;
  String menuFile;
  String documentFile;
  String profileImage;
  String availableStatus;
  String breakfastFromTime;
  String breakfastToTime;
  String lunchFromTime;
  String lunchToTime;
  String dinnerFromTime;
  String dinnerToTime;

  Data({
    required this.userId,
    required this.kitchenId,
    required this.kitchenName,
    required this.description,
    required this.address,
    required this.email,
    required this.mobileNumber,
    required this.password,
    required this.typeOfFirm,
    required this.typeOfFood,
    required this.shiftTiming,
    required this.openDays,
    required this.typeOfMeals,
    required this.totalRating,
    required this.menuFile,
    required this.documentFile,
    required this.profileImage,
    required this.availableStatus,
    required this.breakfastFromTime,
    required this.breakfastToTime,
    required this.lunchFromTime,
    required this.lunchToTime,
    required this.dinnerFromTime,
    required this.dinnerToTime,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    kitchenId: json["kitchenid"],
    kitchenName: json["kitchen_name"],
    description: json["description"],
    address: json["address"],
    email: json["email"],
    mobileNumber: json["mobile_number"],
    password: json["password"],
    typeOfFirm: json["type_of_firm"],
    typeOfFood: List<String>.from(json["type_of_food"].map((x) => x)),
    shiftTiming: List<ShiftTiming>.from(json["shift_timing"].map((x) => ShiftTiming.fromJson(x))),
    openDays: List<String>.from(json["open_days"].map((x) => x)),
    typeOfMeals: List<String>.from(json["type_of_meals"].map((x) => x)),
    totalRating: json["totalrating"],
    menuFile: json["menufile"],
    documentFile: json["documentfile"],
    profileImage: json["profile_image"],
    availableStatus: json["available_status"],
    breakfastFromTime: json["breakfast_fromtime"],
    breakfastToTime: json["breakfast_totime"],
    lunchFromTime: json["lunch_fromtime"],
    lunchToTime: json["lunch_totime"],
    dinnerFromTime: json["dinner_fromtime"],
    dinnerToTime: json["dinner_totime"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "kitchenid": kitchenId,
    "kitchen_name": kitchenName,
    "description": description,
    "address": address,
    "email": email,
    "mobile_number": mobileNumber,
    "password": password,
    "type_of_firm": typeOfFirm,
    "type_of_food": List<dynamic>.from(typeOfFood.map((x) => x)),
    "shift_timing": List<dynamic>.from(shiftTiming.map((x) => x.toJson())),
    "open_days": List<dynamic>.from(openDays.map((x) => x)),
    "type_of_meals": List<dynamic>.from(typeOfMeals.map((x) => x)),
    "totalrating": totalRating,
    "menufile": menuFile,
    "documentfile": documentFile,
    "profile_image": profileImage,
    "available_status": availableStatus,
    "breakfast_fromtime": breakfastFromTime,
    "breakfast_totime": breakfastToTime,
    "lunch_fromtime": lunchFromTime,
    "lunch_totime": lunchToTime,
    "dinner_fromtime": dinnerFromTime,
    "dinner_totime": dinnerToTime,
  };
}

class ShiftTiming {
  String fromTime;
  String toTime;

  ShiftTiming({
    required this.fromTime,
    required this.toTime,
  });

  factory ShiftTiming.fromJson(Map<String, dynamic> json) => ShiftTiming(
    fromTime: json["from_time"],
    toTime: json["to_time"],
  );

  Map<String, dynamic> toJson() => {
    "from_time": fromTime,
    "to_time": toTime,
  };
}*/





class GetAccountDetails {
  bool? status;
  String? message;
  Data? data;

  GetAccountDetails({this.status, this.message, this.data});

  GetAccountDetails.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? kitchenid;
  String? kitchenName;
  String? description;
  String? address;
  String? email;
  String? mobileNumber;
  String? password;
  String? typeOfFirm;
  List<String>? typeOfFood;
  List<String>? kitchentype;
  List<String>? typeofFood;
  List<ShiftTiming>? shiftTiming;
  List<String>? openDays;
  List<String>? typeOfMeals;
  String? totalrating;
  String? menufile;
  String? documentfile;
  String? profileImage;
  String? availableStatus;
  String? breakfastFromtime;
  String? breakfastTotime;
  String? lunchFromtime;
  String? lunchTotime;
  String? dinnerFromtime;
  String? dinnerTotime;
  String? kitchenOpenStatus;

  Data(
      {this.userId,
        this.kitchenid,
        this.kitchenName,
        this.description,
        this.address,
        this.email,
        this.mobileNumber,
        this.password,
        this.typeOfFirm,
        this.typeOfFood,
        this.kitchentype,
        this.typeofFood,
        this.shiftTiming,
        this.openDays,
        this.typeOfMeals,
        this.totalrating,
        this.menufile,
        this.documentfile,
        this.profileImage,
        this.availableStatus,
        this.breakfastFromtime,
        this.breakfastTotime,
        this.lunchFromtime,
        this.lunchTotime,
        this.dinnerFromtime,
        this.dinnerTotime,
        this.kitchenOpenStatus});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    kitchenid = json['kitchenid'];
    kitchenName = json['kitchen_name'];
    description = json['description'];
    address = json['address'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    password = json['password'];
    typeOfFirm = json['type_of_firm'];
    typeOfFood = json['type_of_food'].cast<String>();
    kitchentype = json['kitchentype'].cast<String>();
    typeofFood = json['typeof_food'].cast<String>();
    if (json['shift_timing'] != null) {
      shiftTiming = <ShiftTiming>[];
      json['shift_timing'].forEach((v) {
        shiftTiming!.add(new ShiftTiming.fromJson(v));
      });
    }
    openDays = json['open_days'].cast<String>();
    typeOfMeals = json['type_of_meals'].cast<String>();
    totalrating = json['totalrating'];
    menufile = json['menufile'];
    documentfile = json['documentfile'];
    profileImage = json['profile_image'];
    availableStatus = json['available_status'];
    breakfastFromtime = json['breakfast_fromtime'];
    breakfastTotime = json['breakfast_totime'];
    lunchFromtime = json['lunch_fromtime'];
    lunchTotime = json['lunch_totime'];
    dinnerFromtime = json['dinner_fromtime'];
    dinnerTotime = json['dinner_totime'];
    kitchenOpenStatus = json['kitchen_open_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['kitchenid'] = this.kitchenid;
    data['kitchen_name'] = this.kitchenName;
    data['description'] = this.description;
    data['address'] = this.address;
    data['email'] = this.email;
    data['mobile_number'] = this.mobileNumber;
    data['password'] = this.password;
    data['type_of_firm'] = this.typeOfFirm;
    data['type_of_food'] = this.typeOfFood;
    data['kitchentype'] = this.kitchentype;
    data['typeof_food'] = this.typeofFood;
    if (this.shiftTiming != null) {
      data['shift_timing'] = this.shiftTiming!.map((v) => v.toJson()).toList();
    }
    data['open_days'] = this.openDays;
    data['type_of_meals'] = this.typeOfMeals;
    data['totalrating'] = this.totalrating;
    data['menufile'] = this.menufile;
    data['documentfile'] = this.documentfile;
    data['profile_image'] = this.profileImage;
    data['available_status'] = this.availableStatus;
    data['breakfast_fromtime'] = this.breakfastFromtime;
    data['breakfast_totime'] = this.breakfastTotime;
    data['lunch_fromtime'] = this.lunchFromtime;
    data['lunch_totime'] = this.lunchTotime;
    data['dinner_fromtime'] = this.dinnerFromtime;
    data['dinner_totime'] = this.dinnerTotime;
    data['kitchen_open_status'] = this.kitchenOpenStatus;
    return data;
  }
}

class ShiftTiming {
  String? fromTime;
  String? toTime;

  ShiftTiming({this.fromTime, this.toTime});

  ShiftTiming.fromJson(Map<String, dynamic> json) {
    fromTime = json['from_time'];
    toTime = json['to_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from_time'] = this.fromTime;
    data['to_time'] = this.toTime;
    return data;
  }
}
