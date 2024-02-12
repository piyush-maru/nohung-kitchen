/*
class PackageDetailsModel {
  bool status;
  String message;
  List<PackageDetailsData> data;

  PackageDetailsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PackageDetailsModel.fromJson(Map<String, dynamic> json) =>
      PackageDetailsModel(
        status: json["status"],
        message: json["message"],
        data: List<PackageDetailsData>.from(
            json["data"].map((x) => PackageDetailsData.fromJson(x))),
      );


  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<String>.from(data.map((x) => x.toJson())),
  };
}

class PackageDetailsData {
  String kitchenId;
  String packageId;
  String packageName;
  String mealFor;
  String mealType;
  String cuisineType;
  String price;
  String subscriptionOrderPriorTiming;
  String description;
  String provideCustomization;
  String weekly;
  String monthly;
  String includingSaturday;
  String includingSunday;
  List<DeliveryTime> deliveryTime;
  List<PackageDetail> packageDetail;

  PackageDetailsData({
    required this.kitchenId,
    required this.packageId,
    required this.packageName,
    required this.mealFor,
    required this.mealType,
    required this.cuisineType,
    required this.price,
    required this.subscriptionOrderPriorTiming,
    required this.description,
    required this.provideCustomization,
    required this.weekly,
    required this.monthly,
    required this.includingSaturday,
    required this.includingSunday,
    required this.deliveryTime,
    required this.packageDetail,
  });

  factory PackageDetailsData.fromJson(Map<String, dynamic> json) =>
      PackageDetailsData(
        kitchenId: json["kitchen_id"],
        packageId: json["package_id"],
        packageName: json["package_name"],
        mealFor: json["mealfor"],
        mealType: json["mealtype"],
        cuisineType: json["cuisinetype"],
        price: json["price"],
        subscriptionOrderPriorTiming: json["subscription_order_prior_timing"],
        description: json["description"],
        provideCustomization: json["provide_customization"],
        weekly: json["weekly"],
        monthly: json["monthly"],
        includingSaturday: json["including_saturday"],
        includingSunday: json["including_sunday"],
        deliveryTime: List<DeliveryTime>.from(
            json["delivery_time"].map((x) => DeliveryTime.fromJson(x))),
        packageDetail: List<PackageDetail>.from(
            json["package_detail"].map((x) => PackageDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "kitchen_id": kitchenId,
    "package_id": packageId,
    "package_name": packageName,
    "mealfor": mealFor,
    "mealtype": mealType,
    "cuisinetype": cuisineType,
    "price": price,
    "subscription_order_prior_timing": subscriptionOrderPriorTiming,
    "description": description,
    "provide_customization": provideCustomization,
    "weekly": weekly,
    "monthly": monthly,
    "including_saturday": includingSaturday,
    "including_sunday": includingSunday,
    "delivery_time":
    List<dynamic>.from(deliveryTime.map((x) => x.toJson())),
    "package_detail":
    List<dynamic>.from(packageDetail.map((x) => x.toJson())),
  };
}

class DeliveryTime {
  String fromTime;
  String toTime;
  String time;

  DeliveryTime({
    required this.fromTime,
    required this.toTime,
    required this.time,
  });

  factory DeliveryTime.fromJson(Map<String, dynamic> json) => DeliveryTime(
    fromTime: json["from_time"],
    toTime: json["to_time"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "from_time": fromTime,
    "to_time": toTime,
    "time": time,
  };
}

class PackageDetail {
  String weeklyPackageId;
  String days;
  String daysName;
  String itemName;
  final String weeklyMealPrice;
  final String monthlyMealPrice;
  List<MenuItem> menuItem;

  PackageDetail({
    required this.weeklyPackageId,
    required this.days,
    required this.daysName,
    required this.weeklyMealPrice,
    required this.monthlyMealPrice,
    required this.itemName,
    required this.menuItem,
  });

  factory PackageDetail.fromJson(Map<String, dynamic> json) => PackageDetail(
    weeklyPackageId: json["weekly_package_id"],
    days: json["days"],
    daysName: json["days_name"],
    itemName: json["item_name"],
    weeklyMealPrice: json["weekly_meal_price"],
    monthlyMealPrice: json["monthly_meal_price"],
    menuItem: List<MenuItem>.from(
        json["menu_item"].map((x) => MenuItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "weekly_package_id": weeklyPackageId,
    "days": days,
    "days_name": daysName,
    "item_name": itemName,
    "weekly_meal_price": weeklyMealPrice,
    "monthly_meal_price": monthlyMealPrice,
    "menu_item": List<dynamic>.from(menuItem.map((x) => x.toJson())),
  };
}

class MenuItem {
  String category;
  List<MenuItemData> menuItems;

  MenuItem({
    required this.category,
    required this.menuItems,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
    category: json["category"],
    menuItems: List<MenuItemData>.from(
        json["menuitems"].map((x) => MenuItemData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "menuitems": List<dynamic>.from(menuItems.map((x) => x.toJson())),
  };
}

class MenuItemData {
  String itemId;
  String itemName;
  String itemQty;
  String itemPrice;

  MenuItemData({
    required this.itemId,
    required this.itemName,
    required this.itemQty,
    required this.itemPrice,
  });

  factory MenuItemData.fromJson(Map<String, dynamic> json) => MenuItemData(
    itemId: json["item_id"],
    itemName: json["item_name"],
    itemQty: json["item_qty"],
    itemPrice: json["item_price"],
  );

  Map<String, dynamic> toJson() => {
    "item_id": itemId,
    "item_name": itemName,
    "item_qty": itemQty,
    "item_price": itemPrice,
  };
}*/

class PackageDetailsModel {
  bool? status;
  String? message;
  Data? data;

  PackageDetailsModel({this.status, this.message, this.data});

  PackageDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? packageId;
  String? userId;
  String? packagename;
  String? cuisinetype;
  String? mealtype;
  String? mealfor;
  String? weeklyplantype;
  String? monthlyplantype;
  String? startdate;
  String? includingSaturday;
  String? includingSunday;
  String? monthlyprice;
  String? weeklyprice;
  String? displayInFoodies;
  String? createddate;
  List<PackageDetail>? packageDetail;

  Data(
      {this.packageId,
        this.userId,
        this.packagename,
        this.cuisinetype,
        this.mealtype,
        this.mealfor,
        this.weeklyplantype,
        this.monthlyplantype,
        this.startdate,
        this.includingSaturday,
        this.includingSunday,
        this.monthlyprice,
        this.weeklyprice,
        this.displayInFoodies,
        this.createddate,
        this.packageDetail});

  Data.fromJson(Map<String, dynamic> json) {
    packageId = json['package_id'];
    userId = json['user_id'];
    packagename = json['packagename'];
    cuisinetype = json['cuisinetype'];
    mealtype = json['mealtype'];
    mealfor = json['mealfor'];
    weeklyplantype = json['weeklyplantype'];
    monthlyplantype = json['monthlyplantype'];
    startdate = json['startdate'];
    includingSaturday = json['including_saturday'];
    includingSunday = json['including_sunday'];
    monthlyprice = json['monthlyprice'];
    weeklyprice = json['weeklyprice'];
    displayInFoodies = json['display_in_foodies'];
    createddate = json['createddate'];
    if (json['package_detail'] != null) {
      packageDetail = <PackageDetail>[];
      json['package_detail'].forEach((v) {
        packageDetail!.add(new PackageDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['package_id'] = this.packageId;
    data['user_id'] = this.userId;
    data['packagename'] = this.packagename;
    data['cuisinetype'] = this.cuisinetype;
    data['mealtype'] = this.mealtype;
    data['mealfor'] = this.mealfor;
    data['weeklyplantype'] = this.weeklyplantype;
    data['monthlyplantype'] = this.monthlyplantype;
    data['startdate'] = this.startdate;
    data['including_saturday'] = this.includingSaturday;
    data['including_sunday'] = this.includingSunday;
    data['monthlyprice'] = this.monthlyprice;
    data['weeklyprice'] = this.weeklyprice;
    data['display_in_foodies'] = this.displayInFoodies;
    data['createddate'] = this.createddate;
    if (this.packageDetail != null) {
      data['package_detail'] =
          this.packageDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PackageDetail {
  String? weeklyPackageId;
  String? days;
  String? daysName;
  String? itemName;
  String? weeklyMealPrice;
  String? monthlyMealPrice;
  List<MenuItem>? menuItem;

  PackageDetail(
      {this.weeklyPackageId,
        this.days,
        this.daysName,
        this.itemName,
        this.weeklyMealPrice,
        this.monthlyMealPrice,
        this.menuItem});

  PackageDetail.fromJson(Map<String, dynamic> json) {
    weeklyPackageId = json['weekly_package_id'];
    days = json['days'];
    daysName = json['days_name'];
    itemName = json['item_name'];
    weeklyMealPrice = json['weekly_meal_price'];
    monthlyMealPrice = json['monthly_meal_price'];
    if (json['menu_item'] != null) {
      menuItem = <MenuItem>[];
      json['menu_item'].forEach((v) {
        menuItem!.add(new MenuItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weekly_package_id'] = this.weeklyPackageId;
    data['days'] = this.days;
    data['days_name'] = this.daysName;
    data['item_name'] = this.itemName;
    data['weekly_meal_price'] = this.weeklyMealPrice;
    data['monthly_meal_price'] = this.monthlyMealPrice;
    if (this.menuItem != null) {
      data['menu_item'] = this.menuItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuItem {
  String? category;
  List<Menuitems>? menuitems;

  MenuItem({this.category, this.menuitems});

  MenuItem.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    if (json['menuitems'] != null) {
      menuitems = <Menuitems>[];
      json['menuitems'].forEach((v) {
        menuitems!.add(new Menuitems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    if (this.menuitems != null) {
      data['menuitems'] = this.menuitems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Menuitems {
  String? itemId;
  String? itemName;
  String? itemQty;
  String? itemPrice;

  Menuitems({this.itemId, this.itemName, this.itemQty, this.itemPrice});

  Menuitems.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    itemName = json['item_name'];
    itemQty = json['item_qty'];
    itemPrice = json['item_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['item_name'] = this.itemName;
    data['item_qty'] = this.itemQty;
    data['item_price'] = this.itemPrice;
    return data;
  }
}
