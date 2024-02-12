// class GetActiveOrder {
//   bool? status;
//   String? message;
//   List<GetActiveOrderData>? data;
//
//   GetActiveOrder({this.status, this.message, this.data});
//
//   GetActiveOrder.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = [];
//       json['data'].forEach((v) {
//         data!.add(new GetActiveOrderData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class GetActiveOrderData {
//   String? orderId;
//   String? orderItemsId;
//   String? customerName;
//   String? customerMobilenumber;
//   String? customerImage;
//   String? orderType;
//   String? orderNumber;
//   String? orderDate;
//   String? fromDate;
//   String? menuFor;
//   String? orderItems;
//   String? orderStatus;
//   String? deliveryAddress;
//   String? itemStatus;
//   String? status;
//
//   GetActiveOrderData(
//       {
//       this.orderId,
//       this.customerName,
//       this.customerMobilenumber,
//       this.customerImage,
//       this.orderType,
//       this.orderNumber,
//       this.orderDate,
//       this.fromDate,
//       this.menuFor,
//       this.orderItems,
//       this.orderStatus,
//       this.deliveryAddress,
//       this.status,
//       this.itemStatus,
//       this.orderItemsId});
//             // "order_id": "337",
//             // "orderitems_id": "1596",
//             // "customer_name": "kranthi",
//             // "customer_mobilenumber": "9975791116",
//             // "customer_image": "https://nohungkitchen.notionprojects.tech/assets/uploaded/profile/Group36171656670695.png",
//             // "order_type": "package",
//             // "order_number": "66685549",
//             // "order_date": "Sep 01st, 2022",
//             // "delivery_fromtime": "12:30:00",
//             // "menu_for": "Lunch",
//             // "order_items": "Veg Sweet Corn Soup",
//             // "order_status": "Assigned to Rider",
//             // "status": "1",
//             // "item_status": "1",
//             // "delivery_address": "152, dsds, Villa-86, SRI AMIYA RESIDENCY, Laxmi Nagar, Hyderabad, Telangana 500084, India"
//   GetActiveOrderData.fromJson(Map<String, dynamic> json) {
//     orderId = json['order_id'];
//     orderItemsId = json['orderitems_id'];
//     customerName = json['customer_name'];
//     customerMobilenumber = json['customer_mobilenumber'];
//     customerImage = json['customer_image'];
//     orderType = json['order_type'];
//     orderNumber = json['order_number'];
//     orderDate = json['order_date'];
//     fromDate = json['delivery_fromtime'];
//     menuFor = json['menu_for'];
//     orderItems = json['order_items'];
//     orderStatus = json['order_status'];
//     status = json['status'];
//     itemStatus = json['item_status'];
//     deliveryAddress = json['delivery_address'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['order_id'] = this.orderId;
//     data['orderitems_id'] = this.orderItemsId;
//     data['customer_name'] = this.customerName;
//     data['customer_mobilenumber'] = this.customerMobilenumber;
// //     data['customer_image'] = this.customerImage;
// //     data['order_type'] = this.orderType;
// //     data['order_number'] = this.orderNumber;
// //     data['order_date'] = this.orderDate;
// //     data['delivery_fromtime'] = this.fromDate;
// //     data['menu_for'] = this.menuFor;
// //     data['order_items'] = this.orderItems;
// //     data['order_status'] = this.orderStatus;
// //     data['status'] = this.status;
// //     data['item_status'] = this.itemStatus;
// //     data['delivery_address'] = this.deliveryAddress;
// //     return data;
// //   }
// // }
//
//
// class GetActiveOrder {
//   GetActiveOrder({
//     required this.status,
//     required this.message,
//     required this.data,
//   });
//
//   bool status;
//   String message;
//   List<GetActiveOrderData> data;
//
//   factory GetActiveOrder.fromJson(Map<String, dynamic> json) => GetActiveOrder(
//     status: json["status"],
//     message: json["message"],
//     data: List<GetActiveOrderData>.from(json["data"].map((x) => GetActiveOrderData.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//   };
// }
//
// class GetActiveOrderData {
//   GetActiveOrderData({
//     required this.orderId,
//     required this.orderItemsId,
//     required this.customerName,
//     required this.customerMobileNumber,
//     required this.customerImage,
//     required this.orderType,
//     required this.orderNumber,
//     required this.orderDate,
//     required this.deliveryFromTime,
//     required this.pickupTime,
//     required this.packageName,
//      this.menuFor,
//     required this.orderItems,
//     required this.orderStatus,
//     required this.status,
//     required this.itemStatus,
//     required this.deliveryAddress,
//   });
//
//   String orderId;
//   String orderItemsId;
//   String customerName;
//   String customerMobileNumber;
//   String customerImage;
//   String orderType;
//   String orderNumber;
//   String orderDate;
//   String deliveryFromTime;
//   String pickupTime;
//   String packageName;
//   String? menuFor;
//   String orderItems;
//   String orderStatus;
//   String status;
//   String itemStatus;
//   String deliveryAddress;
//
//   factory GetActiveOrderData.fromJson(Map<String, dynamic> json) => GetActiveOrderData(
//     orderId: json["order_id"],
//     orderItemsId: json["orderitems_id"],
//     customerName: json["customer_name"],
//     customerMobileNumber: json["customer_mobilenumber"],
//     customerImage: json["customer_image"],
//     orderType: json["order_type"],
//     orderNumber: json["order_number"],
//     orderDate: json["order_date"],
//     deliveryFromTime: json["delivery_fromtime"],
//     pickupTime: json["pickup_time"]!,
//     packageName: json["package_name"]!,
//     menuFor: json["menu_for"],
//     orderItems: json["order_items"],
//     orderStatus: json["order_status"]!,
//     status: json["status"],
//     itemStatus: json["item_status"],
//     deliveryAddress: json["delivery_address"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "order_id": orderId,
//     "orderitems_id": orderItemsId,
//     "customer_name": customerName,
//     "customer_mobilenumber": customerMobileNumber,
//     "customer_image": customerImage,
//     "order_type": orderType,
//     "order_number": orderNumber,
//     "order_date": orderDate,
//     "delivery_fromtime": deliveryFromTime,
//     "pickup_time": pickupTime,
//     "package_name": packageName,
//     "menu_for": menuFor,
//     "order_items": orderItems,
//     "order_status": orderStatus,
//     "status": status,
//     "item_status": itemStatus,
//     "delivery_address": deliveryAddress,
//   };
// }


class GetActiveOrder {
  bool status;
  String message;
  List<GetActiveOrderData> data;

  GetActiveOrder({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetActiveOrder.fromJson(Map<String, dynamic> json) => GetActiveOrder(
    status: json["status"],
    message: json["message"],
    data: List<GetActiveOrderData>.from(json["data"].map((x) => GetActiveOrderData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class GetActiveOrderData {
  String orderId;
  String orderItemsId;
  String customerName;
  String customerMobileNumber;
  String customerImage;
  String orderType;
  String orderNumber;
  String orderDate;
  String deliveryFromTime;
  String pickupTime;
  String packageName;
  String menuFor;
  String orderItems;
  String orderStatus;
  String status;
  String itemStatus;
  String deliveryAddress;
  String specialInstruction;

  GetActiveOrderData({
    required this.orderId,
    required this.orderItemsId,
    required this.customerName,
    required this.customerMobileNumber,
    required this.customerImage,
    required this.orderType,
    required this.orderNumber,
    required this.orderDate,
    required this.deliveryFromTime,
    required this.pickupTime,
    required this.packageName,
    required this.menuFor,
    required this.orderItems,
    required this.orderStatus,
    required this.status,
    required this.itemStatus,
    required this.deliveryAddress,
    required this.specialInstruction,
  });

  factory GetActiveOrderData.fromJson(Map<String, dynamic> json) => GetActiveOrderData(
    orderId: json["order_id"],
    orderItemsId: json["orderitems_id"],
    customerName: json["customer_name"],
    customerMobileNumber: json["customer_mobilenumber"],
    customerImage: json["customer_image"],
    orderType: json["order_type"],
    orderNumber: json["order_number"],
    orderDate: json["order_date"],
    deliveryFromTime: json["delivery_fromtime"],
    pickupTime: json["pickup_time"],
    packageName: json["package_name"],
    menuFor: json["menu_for"],
    orderItems: json["order_items"],
    orderStatus: json["order_status"],
    status: json["status"],
    itemStatus: json["item_status"],
    deliveryAddress: json["delivery_address"],
    specialInstruction: json["special_instruction"],
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
    "delivery_fromtime": deliveryFromTime,
    "pickup_time": pickupTime,
    "package_name": packageName,
    "menu_for": menuFor,
    "order_items": orderItems,
    "order_status": orderStatus,
    "status": status,
    "item_status": itemStatus,
    "delivery_address": deliveryAddress,
    "special_instruction": specialInstruction,
  };
}

