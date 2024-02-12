// class BeanGetOrderRequest {
//   BeanGetOrderRequest({
//     required this.status,
//     required this.message,
//     required this.data,
//   });
//
//   bool status;
//   String message;
//   List<RequestData> data;
//
//   factory BeanGetOrderRequest.fromJson(Map<String, dynamic> json) => BeanGetOrderRequest(
//     status: json["status"],
//     message: json["message"],
//     data: List<RequestData>.from(json["data"].map((x) => RequestData.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//   };
// }
//
// class RequestData {
//   RequestData({
//     required this.orderId,
//     required this.orderItemsId,
//     required this.customerName,
//    required this.customerMobileNumber,
//     this.deliveryFromTime,
//     required this.customerImage,
//     required this.orderNumber,
//     required this.orderDate,
//     required this.fromDate,
//     required this.toDate,
//     required this.deliveryAddress,
//     required this.menuFor,
//     required this.orderAmount,
//     required this.totalBill,
//     required this.subscriptionType,
//     required this.orderType,
//     required this.orderItems,
//     required this.weeklyPlan,
//     required this.monthlyPlan,
//   });
//
//   String orderId;
//   String orderItemsId;
//   String customerName;
//   String customerMobileNumber;
//   String? deliveryFromTime;
//   String customerImage;
//   String orderNumber;
//   String orderDate;
//   DateTime fromDate;
//   DateTime toDate;
//   String deliveryAddress;
//   String? menuFor;
//   String orderAmount;
//   String totalBill;
//   String subscriptionType;
//   String orderType;
//   String orderItems;
//   String weeklyPlan;
//   String monthlyPlan;
//
//   factory RequestData.fromJson(Map<String, dynamic> json) => RequestData(
//     orderId: json["order_id"],
//     orderItemsId: json["orderitems_id"],
//     customerName: json["customer_name"],
//     customerMobileNumber: json["customer_mobilenumber"],
//     customerImage: json["customer_image"],
//     deliveryFromTime: json["delivery_fromtime"],
//     orderNumber: json["order_number"],
//     orderDate: json["order_date"],
//     fromDate: DateTime.parse(json["from_date"]),
//     toDate: DateTime.parse(json["to_date"]),
//     deliveryAddress: json["delivery_address"],
//     menuFor: json["menu_for"],
//     orderAmount: json["order_amount"],
//     totalBill: json["total_bill"],
//     subscriptionType: json["subscription_type"],
//     orderType: json["ordertype"],
//     orderItems: json["order_items"],
//     weeklyPlan: json["weekly_plan"],
//     monthlyPlan: json["monthly_plan"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "order_id": orderId,
//     "orderitems_id": orderItemsId,
//     "customer_name": customerName,
//     "customer_mobilenumber": customerMobileNumber,
//     "customer_image": customerImage,
//     "order_number": orderNumber,
//     "order_date": orderDate,
//     "from_date": "${fromDate.year.toString().padLeft(4, '0')}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}",
//     "to_date": "${toDate.year.toString().padLeft(4, '0')}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}",
//     "delivery_address": deliveryAddress,
//     "delivery_fromtime":deliveryFromTime,
//     "menu_for": menuFor,
//     "order_amount": orderAmount,
//     "total_bill": totalBill,
//     "subscription_type": subscriptionType,
//     "ordertype": orderType,
//     "order_items": orderItems,
//     "weekly_plan": weeklyPlan,
//     "monthly_plan": monthlyPlan,
//   };
// }

/*class BeanGetOrderRequest {
  bool? status;
  String? message;
  List<RequestData>? data;

  BeanGetOrderRequest({this.status, this.message, this.data});

  BeanGetOrderRequest.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RequestData>[];
      json['data'].forEach((v) {
        data!.add(new RequestData.fromJson(v));
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

class RequestData {
  String? orderId;
  String? orderItemsId;
  String? customerName;
  String? customerMobileNumber;
  String? customerImage;
  String? orderNumber;
  String? orderDate;
  String? fromDate;
  String? toDate;
  String? pickupTime;
  String? deliveryAddress;
  String? menuFor;
  String? packageName;
  String? orderAmount;
  String? totalBill;
  String? subscriptionType;
  String? orderType;
  String? orderItems;
  String? weeklyPlan;
  String? monthlyPlan;

  RequestData(
      {this.orderId,
        this.orderItemsId,
        this.customerName,
        this.customerMobileNumber,
        this.customerImage,
        this.orderNumber,
        this.orderDate,
        this.fromDate,
        this.toDate,
        this.pickupTime,
        this.deliveryAddress,
        this.menuFor,
        this.orderAmount,
        this.totalBill,
        this.packageName,
        this.subscriptionType,
        this.orderType,
        this.orderItems,
        this.weeklyPlan,
        this.monthlyPlan});

  RequestData.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderItemsId = json['orderitems_id'];
    customerName = json['customer_name'];
    customerMobileNumber = json['customer_mobilenumber'];
    customerImage = json['customer_image'];
    packageName = json['package_name'];
    orderNumber = json['order_number'];
    orderDate = json['order_date'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    pickupTime = json['pickup_time'];
    deliveryAddress = json['delivery_address'];
    menuFor = json['menu_for'];
    orderAmount = json['order_amount'];
    totalBill = json['total_bill'];
    subscriptionType = json['subscription_type'];
    orderType = json['ordertype'];
    orderItems = json['order_items'];
    weeklyPlan = json['weekly_plan'];
    monthlyPlan = json['monthly_plan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['orderitems_id'] = this.orderItemsId;
    data['customer_name'] = this.customerName;
    data['customer_mobilenumber'] = this.customerMobileNumber;
    data['customer_image'] = this.customerImage;
    data['order_number'] = this.orderNumber;
    data['order_date'] = this.orderDate;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['pickup_time'] = this.pickupTime;
    data['package_name'] = this.packageName;
    data['delivery_address'] = this.deliveryAddress;
    data['menu_for'] = this.menuFor;
    data['order_amount'] = this.orderAmount;
    data['total_bill'] = this.totalBill;
    data['subscription_type'] = this.subscriptionType;
    data['ordertype'] = this.orderType;
    data['order_items'] = this.orderItems;
    data['weekly_plan'] = this.weeklyPlan;
    data['monthly_plan'] = this.monthlyPlan;
    return data;
  }
}*/


class BeanGetOrderRequest {
  bool? status;
  String? message;
  List<RequestData1>? data;

  BeanGetOrderRequest({this.status, this.message, this.data});

  BeanGetOrderRequest.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RequestData1>[];
      json['data'].forEach((v) {
        data!.add(new RequestData1.fromJson(v));
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

class RequestData1 {
  String? orderId;
  String? orderitemsId;
  String? customerName;
  String? customerMobilenumber;
  String? customerImage;
  String? orderNumber;
  String? orderDate;
  String? fromDate;
  String? toDate;
  String? pickupTime;
  String? deliveryAddress;
  String? packageName;
  String? menuFor;
  String? orderAmount;
  String? totalBill;
  String? subscriptionType;
  String? ordertype;
  String? orderItems;
  String? weeklyPlan;
  String? monthlyPlan;
  String? tag;
  String? deliveryDate;
  String? isDivert;
  String? specialInstruction;

  RequestData1(
      {this.orderId,
        this.orderitemsId,
        this.customerName,
        this.customerMobilenumber,
        this.customerImage,
        this.orderNumber,
        this.orderDate,
        this.fromDate,
        this.toDate,
        this.pickupTime,
        this.deliveryAddress,
        this.packageName,
        this.menuFor,
        this.orderAmount,
        this.totalBill,
        this.subscriptionType,
        this.ordertype,
        this.orderItems,
        this.weeklyPlan,
        this.monthlyPlan,
        this.tag,
        this.deliveryDate,
        this.isDivert,
        this.specialInstruction
      });

  RequestData1.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderitemsId = json['orderitems_id'];
    customerName = json['customer_name'];
    customerMobilenumber = json['customer_mobilenumber'];
    customerImage = json['customer_image'];
    orderNumber = json['order_number'];
    orderDate = json['order_date'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    pickupTime = json['pickup_time'];
    deliveryAddress = json['delivery_address'];
    packageName = json['package_name'];
    menuFor = json['menu_for'];
    orderAmount = json['order_amount'];
    totalBill = json['total_bill'];
    subscriptionType = json['subscription_type'];
    ordertype = json['ordertype'];
    orderItems = json['order_items'];
    weeklyPlan = json['weekly_plan'];
    monthlyPlan = json['monthly_plan'];
    tag = json['tag'];
    deliveryDate = json['delivery_date'];
    isDivert = json['is_divert'];
    specialInstruction = json['special_instruction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['orderitems_id'] = this.orderitemsId;
    data['customer_name'] = this.customerName;
    data['customer_mobilenumber'] = this.customerMobilenumber;
    data['customer_image'] = this.customerImage;
    data['order_number'] = this.orderNumber;
    data['order_date'] = this.orderDate;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['pickup_time'] = this.pickupTime;
    data['delivery_address'] = this.deliveryAddress;
    data['package_name'] = this.packageName;
    data['menu_for'] = this.menuFor;
    data['order_amount'] = this.orderAmount;
    data['total_bill'] = this.totalBill;
    data['subscription_type'] = this.subscriptionType;
    data['ordertype'] = this.ordertype;
    data['order_items'] = this.orderItems;
    data['weekly_plan'] = this.weeklyPlan;
    data['monthly_plan'] = this.monthlyPlan;
    data['tag'] = this.tag;
    data['delivery_date'] = this.deliveryDate;
    data['is_divert'] = this.isDivert;
    data['special_instruction'] = this.specialInstruction;
    return data;
  }
}
