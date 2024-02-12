// class GetorderHistory {
//   bool? status;
//   String? message;
//   Data? data;
//
//   GetorderHistory({this.status, this.message, this.data});
//
//   GetorderHistory.fromJson(Map<String, dynamic> json) {
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
//   int? booked;
//   int? paid;
//   int? cancelled;
//   String? totalSales;
//   String? projectedSalesTomorrow;
//   List<OrderHistory>? orderHistory;
//
//   Data(
//       {this.booked,
//       this.paid,
//       this.cancelled,
//       this.totalSales,
//       this.projectedSalesTomorrow,
//       this.orderHistory});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     booked = json['booked'];
//     paid = json['paid'];
//     cancelled = json['cancelled'];
//     totalSales = json['total_sales'];
//     projectedSalesTomorrow = json['projected_sales_tomorrow'];
//     if (json['order_history'] != null) {
//       orderHistory = [];
//       json['order_history'].forEach((v) {
//         orderHistory!.add(new OrderHistory.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['booked'] = this.booked;
//     data['paid'] = this.paid;
//     data['cancelled'] = this.cancelled;
//     data['total_sales'] = this.totalSales;
//     data['projected_sales_tomorrow'] = this.projectedSalesTomorrow;
//     if (this.orderHistory != null) {
//       data['order_history'] = this.orderHistory!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class OrderHistory {
//   String? orderId;
//   String? orderType;
//   String? packageType;
//   String? customerName;
//   String? customerMobilenumber;
//   String? customerImage;
//   String? orderNumber;
//   String? orderDate;
//   String? weeklyPlan;
//   String? monthlyPlan;
//   String? trialOrder;
//   String? deliveryAddress;
//   String? totalBill;
//   String? orderStatus;
//   String? status;
//
//   OrderHistory(
//       {this.orderId,
//       this.orderType,
//       this.packageType,
//       this.customerName,
//       this.customerMobilenumber,
//       this.customerImage,
//       this.orderNumber,
//       this.orderDate,
//       this.weeklyPlan,
//       this.monthlyPlan,
//       this.trialOrder,
//       this.deliveryAddress,
//       this.totalBill,
//       this.orderStatus,
//       this.status});
// // "order_id": "320",
// //    "order_type": "package",
// //    "package_type": "weekly",
// //    "customer_name": "Kranthi",
// //    "customer_mobilenumber": "9975791116",
// //    "order_number": "49192962",
// //    "order_date": "Aug 04th, 2022",
// //    "weekly_plan": "Breakfast",
// //    "monthly_plan": "",
// //    "trial_order": "",
// //    "delivery_address": "KOTHA, KK, 9WGR+2XG, Dandugadda, Raghavendra Colony, Kothakota, Telangana 509381, India",
// //    "total_bill": "0.00"
//   OrderHistory.fromJson(Map<String, dynamic> json) {
//     orderId = json['order_id'];
//     orderType = json['order_type'];
//     packageType = json['package_type'];
//     customerName = json['customer_name'];
//     customerMobilenumber = json['customer_mobilenumber'];
//     customerImage = json['customer_image'];
//     orderNumber = json['order_number'];
//     orderDate = json['order_date'];
//     weeklyPlan = json['weekly_plan'];
//     monthlyPlan = json['monthly_plan'];
//     trialOrder = json['trial_order'];
//     deliveryAddress = json['delivery_address'];
//     totalBill = json['total_bill'];
//     orderStatus = json['order_status'];
//     status = json['status'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['order_id'] = this.orderId;
//     data['order_type'] = this.orderType;
//     data['package_type'] = this.packageType;
//     data['customer_name'] = this.customerName;
//     data['customer_mobilenumber'] = this.customerMobilenumber;
//     data['customer_image'] = this.customerImage;
//     data['order_number'] = this.orderNumber;
//     data['order_date'] = this.orderDate;
//     data['weekly_plan'] = this.weeklyPlan;
//     data['monthly_plan'] = this.monthlyPlan;
//     data['trial_order'] = this.trialOrder;
//     data['delivery_address'] = this.deliveryAddress;
//     data['total_bill'] = this.totalBill;
//     data['order_status'] = this.orderStatus;
//     data['status'] = this.status;
//     return data;
//   }
// }


//
//
//
//
// class GetOrderHistory {
//   GetOrderHistory({
//     required this.status,
//     required this.message,
//     required this.data,
//   });
//
//   bool status;
//   String message;
//   OrderHistoryData data;
//
//   factory GetOrderHistory.fromJson(Map<String,dynamic> json) => GetOrderHistory(
//     status: json["status"],
//     message: json["message"],
//     data: OrderHistoryData.fromJson(json["data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "data": data.toJson(),
//   };
//
// }
//
// class OrderHistoryData {
//   OrderHistoryData({
//     required this.totalActiveOrders,
//     required this.totalCompletedOrders,
//     required this.totalOrders,
//     required this.orderHistory,
//   });
//
//   TotalOrders totalActiveOrders;
//   TotalOrders totalCompletedOrders;
//   TotalOrders totalOrders;
//   List<OrderHistory> orderHistory;
//
//   factory OrderHistoryData.fromJson(Map<String, dynamic> json) => OrderHistoryData(
//     totalActiveOrders: TotalOrders.fromJson(json["total_active_orders"]),
//     totalCompletedOrders: TotalOrders.fromJson(json["total_completed_orders"]),
//     totalOrders: TotalOrders.fromJson(json["total_orders"]),
//     orderHistory: List<OrderHistory>.from(json["order_history"].map((x) => OrderHistory.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "total_active_orders": totalActiveOrders.toJson(),
//     "total_completed_orders": totalCompletedOrders.toJson(),
//     "total_orders": totalOrders.toJson(),
//     "order_history": List<dynamic>.from(orderHistory.map((x) => x.toJson())),
//   };
// }
//
// class OrderHistory {
//   OrderHistory({
//     required this.orderId,
//     required this.orderType,
//     required this.customerName,
//     required this.orderNumber,
//     required this.orderDateTime,
//     required this.menuFor,
//      this.packageName,
//     required this.subscriptionPeriod,
//     required this.status,
//     required this.orderItems,
//   });
//
//   String orderId;
//   String orderType;
//   String customerName;
//   String orderNumber;
//   String orderDateTime;
//   String menuFor;
//   String? packageName;
//   String subscriptionPeriod;
//   String status;
//   List<OrderItem> orderItems;
//
//   factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
//     orderId: json["order_id"],
//     orderType: json["order_type"],
//     customerName: json["customer_name"],
//     orderNumber: json["order_number"],
//     orderDateTime: json["order_date_time"],
//     menuFor: json["menu_for"],
//     packageName: json["package_name"]!,
//     subscriptionPeriod: json["subscription_period"],
//     status: json["status"],
//     orderItems: List<OrderItem>.from(json["order_items"].map((x) => OrderItem.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "order_id": orderId,
//     "order_type": orderType,
//     "customer_name": customerName,
//     "order_number": orderNumber,
//     "order_date_time": orderDateTime,
//     "menu_for": menuFor,
//     "package_name": packageName,
//     "subscription_period": subscriptionPeriod,
//     "status": status,
//     "order_items": List<dynamic>.from(orderItems.map((x) => x.toJson())),
//   };
// }
//
//
// class OrderItem {
//   OrderItem({
//     required this.itemName,
//     required this.cuisine,
//     required this.quantity,
//     required this.itemPrice,
//     required this.deliveryDate,
//     required this.pickupTime,
//     required this.status,
//     required this.totalAmount,
//   });
//
//   String itemName;
//   String cuisine;
//   String quantity;
//   String itemPrice;
//   String deliveryDate;
//   String pickupTime;
//   String status;
//   String totalAmount;
//
//   factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
//     itemName: json["item_name"],
//     cuisine: json["cuisine"],
//     quantity: json["quantity"],
//     itemPrice: json["item_price"],
//     deliveryDate: json["delivery_date"],
//     pickupTime: json["pickup_time"],
//     status: json["status"],
//     totalAmount: json["total_amount"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "item_name": itemName,
//     "cuisine": cuisine,
//     "quantity": quantity,
//     "item_price": itemPrice,
//     "delivery_date": deliveryDate,
//     "pickup_time": pickupTime,
//     "status": status,
//     "total_amount": totalAmount,
//   };
// }
//
//
//
// class TotalOrders {
//   TotalOrders({
//     required this.total,
//     required this.orderNow,
//     required this.weekly,
//     required this.monthly,
//   });
//
//   int total;
//   int orderNow;
//   int weekly;
//   int monthly;
//
//   factory TotalOrders.fromJson(Map<String, dynamic> json) => TotalOrders(
//     total: json["total"],
//     orderNow: json["order_now"],
//     weekly: json["weely"],
//     monthly: json["monthly"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "total": total,
//     "order_now": orderNow,
//     "weely": weekly,
//     "monthly": monthly,
//   };
// }









//second

class GetOrderHistory {
  GetOrderHistory({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<OrderHistoryData> data;

  factory GetOrderHistory.fromJson(Map<String, dynamic> json) => GetOrderHistory(
    status: json["status"],
    message: json["message"],
    data: List<OrderHistoryData>.from(json["data"].map((x) => OrderHistoryData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class OrderHistoryData {
  OrderHistoryData({
    required this.totalActiveOrders,
    required this.totalCompletedOrders,
    required this.totalOrders,
    required this.orderHistory,
  });

  TotalOrders totalActiveOrders;
  TotalOrders totalCompletedOrders;
  TotalOrders totalOrders;
  List<OrderHistory> orderHistory;

  factory OrderHistoryData.fromJson(Map<String, dynamic> json) => OrderHistoryData(
    totalActiveOrders: TotalOrders.fromJson(json["total_active_orders"]),
    totalCompletedOrders: TotalOrders.fromJson(json["total_completed_orders"]),
    totalOrders: TotalOrders.fromJson(json["total_orders"]),
    orderHistory: List<OrderHistory>.from(json["order_history"].map((x) => OrderHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_active_orders": totalActiveOrders.toJson(),
    "total_completed_orders": totalCompletedOrders.toJson(),
    "total_orders": totalOrders.toJson(),
    "order_history": List<dynamic>.from(orderHistory.map((x) => x.toJson())),
  };
}

class OrderHistory {
  OrderHistory({
    required this.orderId,
    required this.orderType,
    required this.customerName,
    required this.orderNumber,
    required this.orderDateTime,
    required this.menuFor,
    this.packageName,
    required this.subscriptionPeriod,
    required this.status,
    required this.orderItems,
  });

  String orderId;
  String orderType;
  String customerName;
  String orderNumber;
  String orderDateTime;
  String menuFor;
  String? packageName;
  String subscriptionPeriod;
  String status;
  List<OrderItem> orderItems;

  factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
    orderId: json["order_id"],
    orderType: json["order_type"],
    customerName: json["customer_name"],
    orderNumber: json["order_number"],
    orderDateTime: json["order_date_time"],
    menuFor: json["menu_for"],
    packageName: json["package_name"],
    subscriptionPeriod: json["subscription_period"],
    status: json["status"],
    orderItems: List<OrderItem>.from(json["order_items"].map((x) => OrderItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "order_type": orderType,
    "customer_name": customerName,
    "order_number": orderNumber,
    "order_date_time": orderDateTime,
    "menu_for": menuFor,
    "package_name": packageName,
    "subscription_period": subscriptionPeriod,
    "status": status,
    "order_items": List<dynamic>.from(orderItems.map((x) => x.toJson())),
  };
}

class OrderItem {
  OrderItem({
    required this.itemName,
    required this.cuisine,
    required this.quantity,
    required this.itemPrice,
    required this.deliveryDate,
    required this.pickupTime,
    required this.status,
    required this.totalAmount,
  });

  String itemName;
  String cuisine;
  String quantity;
  String itemPrice;
  String deliveryDate;
  String pickupTime;
  String status;
  String totalAmount;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    itemName: json["item_name"],
    cuisine: json["cuisine"],
    quantity: json["quantity"],
    itemPrice: json["item_price"],
    deliveryDate: json["delivery_date"],
    pickupTime: json["pickup_time"],
    status: json["status"],
    totalAmount: json["total_amount"],
  );

  Map<String, dynamic> toJson() => {
    "item_name": itemName,
    "cuisine": cuisine,
    "quantity": quantity,
    "item_price": itemPrice,
    "delivery_date": deliveryDate,
    "pickup_time": pickupTime,
    "status": status,
    "total_amount": totalAmount,
  };
}

class TotalOrders {
  TotalOrders({
    required this.total,
    required this.orderNow,
    required this.weekly,
    required this.monthly,
  });

  int total;
  int orderNow;
  int weekly;
  int monthly;

  factory TotalOrders.fromJson(Map<String, dynamic> json) => TotalOrders(
    total: json["total"],
    orderNow: json["order_now"],
    weekly: json["weely"],
    monthly: json["monthly"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "order_now": orderNow,
    "weely": weekly,
    "monthly": monthly,
  };
}



