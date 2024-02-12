

class BeanGetLiveOrders {
  BeanGetLiveOrders({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  LiveOrderData data;

  factory BeanGetLiveOrders.fromJson(Map<String, dynamic> json) => BeanGetLiveOrders(
    status: json["status"],
    message: json["message"],
    data: LiveOrderData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class LiveOrderData {
  LiveOrderData({
    required this.pagination,
    required this.liveOrders,
  });

  Pagination pagination;
  List<LiveOrder> liveOrders;

  factory LiveOrderData.fromJson(Map<String, dynamic> json) => LiveOrderData(
    pagination: Pagination.fromJson(json["pagination"]),
    liveOrders: List<LiveOrder>.from(json["live_orders"].map((x) => LiveOrder.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pagination": pagination.toJson(),
    "live_orders": List<dynamic>.from(liveOrders.map((x) => x.toJson())),
  };
}

class LiveOrder {
  LiveOrder({
    required this.orderId,
    required this.orderItemsId,
    required this.customerName,
    required this.customerMobileNumber,
    required this.customerImage,
    required this.orderType,
    required this.orderNumber,
    required this.orderDate,
    required this.amount,
    required this.orderStatus,
    required this.status,
    required this.itemStatus,
  });

  String orderId;
  String orderItemsId;
  String customerName;
  String customerMobileNumber;
  String customerImage;
  String orderType;
  String orderNumber;
  String orderDate;
  String amount;
  String orderStatus;
  String status;
  String itemStatus;

  factory LiveOrder.fromJson(Map<String, dynamic> json) => LiveOrder(
    orderId: json["order_id"],
    orderItemsId: json["orderitems_id"],
    customerName: json["customer_name"],
    customerMobileNumber: json["customer_mobilenumber"],
    customerImage: json["customer_image"],
    orderType: json["order_type"],
    orderNumber: json["order_number"],
    orderDate: json["order_date"],
    amount: json["amount"],
    orderStatus: json["order_status"],
    status: json["status"],
    itemStatus: json["item_status"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "orderitems_id": orderItemsId,
    "customer_name": customerName,
    "customer_mobilenumber": customerMobileNumber,
    "customer_image": customerImage,
    "order_type": orderType,
    "order_number": orderNumber,
    "order_date": orderDate,
    "amount": amount,
    "order_status": orderStatus,
    "status": status,
    "item_status": itemStatus,
  };
}

class Pagination {
  Pagination({
    required this.totalRecord,
    required this.currentPage,
    required this.totalPage,
  });

  int totalRecord;
  String currentPage;
  int totalPage;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    totalRecord: json["total_record"],
    currentPage: json["current_page"],
    totalPage: json["total_page"],
  );

  Map<String, dynamic> toJson() => {
    "total_record": totalRecord,
    "current_page": currentPage,
    "total_page": totalPage,
  };
}



// class BeanGetLiveOrders {
//   bool? status;
//   String? message;
//   LiveLiveOrderData? data;
//
//   BeanGetLiveOrders({this.status, this.message, this.data});
//
//   BeanGetLiveOrders.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//         data = LiveData.fromJson(json["data"]);
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     data['data'] = this.data!.toJson();
//     return data;
//   }
// }
//
// class LiveData {
//   int? totalOrders;
//   List<BeanGetLiveOrdersData>? data;
//
//   LiveData({this.totalOrders, this.data});
//
//   LiveData.fromJson(Map<String, dynamic> json) {
//     totalOrders = json['total_orders'];
//     if (json['live_orders'] != null) {
//       data = [];
//       json['live_orders'].forEach((v) {
//         data!.add(new BeanGetLiveOrdersData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['total_orders'] = this.totalOrders;
//     if (this.data != null) {
//       data['live_orders'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class BeanGetLiveOrdersData {
//   String? orderId;
//   String? orderItemId;
//   String? customerName;
//   String? customerMobilenumber;
//   String? customerImage;
//   String? orderType;
//   String? orderNumber;
//   String? orderDate;
//   String? amount;
//   String? orderStatus;
//   String? status;
//   String? itemStatus;
//
//   BeanGetLiveOrdersData(
//       {this.orderId,
//       this.orderItemId,
//       this.customerName,
//       this.customerMobilenumber,
//       this.customerImage,
//       this.orderType,
//       this.orderNumber,
//       this.orderDate,
//       this.amount,
//       this.orderStatus,
//       this.status,
//       this.itemStatus
//       });
//
//   BeanGetLiveOrdersData.fromJson(Map<String, dynamic> json) {
//     orderId = json['order_id'];
//     orderItemId = json['orderitems_id'];
//     customerName = json['customer_name'];
//     customerMobilenumber = json['customer_mobilenumber'];
//     customerImage = json['customer_image'];
//     orderType = json['order_type'];
//     orderNumber = json['order_number'];
//     orderDate = json['order_date'];
//     amount = json['amount'];
//     orderStatus = json['order_status'];
//     status = json['status'];
//     itemStatus = json['item_status'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['order_id'] = this.orderId;
//     data['orderitems_id'] = this.orderItemId;
//     data['customer_name'] = this.customerName;
//     data['customer_mobilenumber'] = this.customerMobilenumber;
//     data['customer_image'] = this.customerImage;
//     data['order_type'] = this.orderType;
//     data['order_number'] = this.orderNumber;
//     data['order_date'] = this.orderDate;
//     data['amount'] = this.amount;
//     data['order_status'] = this.orderStatus;
//     data['status'] = this.status;
//     data['item_status'] = this.itemStatus;
//     return data;
//   }
// }
