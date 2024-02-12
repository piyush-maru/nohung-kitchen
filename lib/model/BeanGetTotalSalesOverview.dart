// ignore_for_file: non_constant_identifier_names

class BeanGetTotalSalesOverview {
  bool? status;
  String? message;
  Data? data;

  BeanGetTotalSalesOverview({this.status, this.message, this.data});

  BeanGetTotalSalesOverview.fromJson(Map<String, dynamic> json) {
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
  String? totalEarn;
  TotalEarnPerWeek? totalEarnPerWeek;
  TotalEarnPerMonth? totalEarnPerMonth;

  Data({
    this.totalEarn,
    this.totalEarnPerWeek,
    this.totalEarnPerMonth,
  });

  Data.fromJson(Map<String, dynamic> json) {
    totalEarn = json['total_earn'];
    totalEarnPerWeek = TotalEarnPerWeek.fromJson(json["total_earn_per_week"]);
    // if (json['total_earn_per_week'] != null) {
    //   json['total_earn_per_week'].forEach((v) {
    //     totalEarnPerWeek.add(new TotalEarnPerWeek.fromJson(v));
    //   });
    // }
    totalEarnPerMonth =
        TotalEarnPerMonth.fromJson(json["total_earn_per_month"]);

    // if (json['total_earn_per_month'] != null) {
    //   totalEarnPerMonth = [];
    //   json['total_earn_per_month'].forEach((v) {
    //     totalEarnPerMonth.add(new TotalEarnPerMonth.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_earn'] = totalEarn;
    // if (this.totalEarnPerWeek != null) {
    //   data['total_earn_per_week'] =
    //       this.totalEarnPerWeek.map((v) => v.toJson()).toList();
    // }
    // "data": data.toJson(),
    data['total_earn_per_week'] = totalEarnPerWeek!.toJson();
    data['total_earn_per_month'] = totalEarnPerMonth!.toJson();

    // if (this.totalEarnPerMonth != null) {
    //   data['total_earn_per_month'] =
    //       this.totalEarnPerMonth.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class TotalEarnPerWeek {
  String? week1;
  String? week2;
  String? week3;
  String? week4;
  String? week5;

  TotalEarnPerWeek({
    this.week1,
    this.week2,
    this.week3,
    this.week4,
    this.week5,
  });

  TotalEarnPerWeek.fromJson(Map<String, dynamic> json) {
    week1 = json['week1'];
    week2 = json['week2'];
    week3 = json['week3'];
    week4 = json['week4'];
    week5 = json['week5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['week1'] = this.week1;
    data['week2'] = this.week2;
    data['week3'] = this.week3;
    data['week4'] = this.week4;
    data['week5'] = this.week5;
    return data;
  }
}

class TotalEarnPerMonth {
  dynamic January;
  dynamic February;
  dynamic March;
  dynamic April;
  dynamic May;
  dynamic June;
  dynamic July;
  dynamic August;
  dynamic September;
  dynamic October;
  dynamic November;
  dynamic December;

  TotalEarnPerMonth({
    this.January,
    this.February,
    this.March,
    this.April,
    this.May,
    this.June,
    this.July,
    this.August,
    this.September,
    this.October,
    this.November,
    this.December,
  });
  //       "January": "0.00",
  //       "February": "0.00",
  //       "March": "0.00",
  //       "April": "0.00",
  //       "May": "0.00",
  //       "June": "0.00",
  //       "July": "0.00",
  //       "August": "0.00",
  //       "September": "0.00",
  //       "October": "595.00",
  //       "November": "0.00",
  //       "December": "250.00"
  TotalEarnPerMonth.fromJson(Map<String, dynamic> json) {
    January = json['January'];
    February = json['February'];
    March = json['March'];
    April = json['April'];
    May = json['May'];
    June = json['June'];
    July = json['July'];
    August = json['August'];
    September = json['September'];
    October = json['October'];
    November = json['November'];
    December = json['December'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['January'] = this.January;
    data['February'] = this.February;
    data['March'] = this.March;
    data['April'] = this.April;
    data['May'] = this.May;
    data['June'] = this.June;
    data['July'] = this.July;
    data['August'] = this.August;
    data['September'] = this.September;
    data['October'] = this.October;
    data['November'] = this.November;
    data['December'] = this.December;

    return data;
  }
}
