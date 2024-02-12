
/*class WalletModel {
  WalletModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Wallets> data;

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    status: json["status"],
    message: json["message"],
    data: List<Wallets>.from(json["data"].map((x) => Wallets.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Wallets {
  Wallets({
    required this.requestedDateTime,
    required this.requestedAmount,
    required this.requestDates,
    required this.releasedAmount,
    required this.status,
  });

  String requestedDateTime;
  String requestedAmount;
  String requestDates;
  String releasedAmount;
  String status;

  factory Wallets.fromJson(Map<String, dynamic> json) => Wallets(
    requestedDateTime: json["requested_date_time"],
    requestedAmount: json["requested_amount"],
    requestDates: json["request_dates"],
    releasedAmount: json["released_amount"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "requested_date_time": requestedDateTime,
    "requested_amount": requestedAmount,
    "request_dates": requestDates,
    "released_amount": releasedAmount,
    "status": status,
  };
}*/



class WalletModel {
  bool? status;
  String? message;
  List<Data>? data;

  WalletModel({this.status, this.message, this.data});

  WalletModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
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

class Data {
  String? requestedDateTime;
  String? actualRequestedAmount;
  String? finalAmount;
  String? category;
  String? addonAmount;
  String? requestedAmount;
  String? requestDates;
  String? commission;
  String? gstOnCommission;
  String? releasedAmount;
  String? status;
  String? reason;
  String? amountSettledOn;

  Data(
      {this.requestedDateTime,
      this.actualRequestedAmount,
      this.finalAmount,
      this.category,
      this.addonAmount,
        this.requestedAmount,
        this.requestDates,
        this.commission,
        this.gstOnCommission,
        this.releasedAmount,
        this.status,
        this.reason,
        this.amountSettledOn,
      });

  Data.fromJson(Map<String, dynamic> json) {
    requestedDateTime = json['requested_date_time'];
    actualRequestedAmount = json['actual_requested_amount'];
    finalAmount = json['final_amount'];
    category = json['category'];
    addonAmount = json['addon_amount'];
    requestedAmount = json['requested_amount'];
    requestDates = json['request_dates'];
    commission = json['commission'];
    gstOnCommission = json['gst_on_commission'];
    releasedAmount = json['released_amount'];
    status = json['status'];
    reason = json['reason'];
    amountSettledOn = json['amount_settled_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requested_date_time'] = this.requestedDateTime;
    data['actual_requested_amount'] = this.actualRequestedAmount;
    data['final_amount'] = this.finalAmount;
    data['category'] = this.category;
    data['addon_amount'] = this.addonAmount;
    data['requested_amount'] = this.requestedAmount;
    data['request_dates'] = this.requestDates;
    data['commission'] = this.commission;
    data['gst_on_commission'] = this.gstOnCommission;
    data['released_amount'] = this.releasedAmount;
    data['status'] = this.status;
    data['reason'] = this.reason;
    data['amount_settled_on'] = this.amountSettledOn;
    return data;
  }
}
