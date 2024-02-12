class GetOrderDetails {
  GetOrderDetails({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  GetOrderDetailsData data;

  factory GetOrderDetails.fromJson(Map<String, dynamic> json) =>
      GetOrderDetails(
        status: json["status"],
        message: json["message"],
        data: GetOrderDetailsData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class GetOrderDetailsData {
  GetOrderDetailsData({
    required this.orderId,
    required this.orderItemId,
    required this.orderType,
    required this.orderNumber,
    required this.orderDate,
    // required this.orderFrom,
    this.order_delivery_date,
    required this.customerName,
    this.specialInstruction,
      required this.itemsDetail,
    required this.discount,
    required this.package,
    this.packageName,
    required this.packagingCharge,

    required this.reason,
    required this.category,
    required this.amount,
    required this.netAmount,

    required this.total,
    required this.status,
    required this.itemStatus,
    required this.order_now_delivery_date,
    required this.isDivert,
    required this.deliveryDate,
    required this.pickupTime,
  });

  String orderId;
  String orderItemId;
  String orderType;
  String orderNumber;
  String orderDate;
  // String orderFrom;
  String? order_delivery_date;
  String customerName;
  dynamic specialInstruction;
  final List<ItemsDetail>? itemsDetail;
  String discount;
  String? packageName;
  String package;
  String packagingCharge;

  String reason;
  String category;
  String amount;
  String netAmount;

  String total;
  String status;
  String itemStatus;
  dynamic order_now_delivery_date;
  String isDivert;
  String deliveryDate;
  String pickupTime;

  factory GetOrderDetailsData.fromJson(Map<String, dynamic> json) =>
      GetOrderDetailsData(
        orderId: json["order_id"],
        orderItemId: json["order_item_id"],
        orderType: json["ordertype"],
        orderNumber: json["order_number"],
        orderDate: json["order_date"],
        // orderFrom: json["order_from"],
        order_delivery_date: json["order_delivery_date"] ?? "",
        customerName: json["customer_name"],
        specialInstruction: json["special_instruction"],
        itemsDetail: json["items_detail"] == null
            ? []
            : List<ItemsDetail>.from(
            json["items_detail"]!.map((x) => ItemsDetail.fromJson(x))),
        discount: json["discount"],
        packageName: json["package_name"],
        package: json["package"],
        packagingCharge: json["packaging_charge"],
        reason: json["reason"],
        category: json["category"],
        amount: json["amount"],
        netAmount: json["net_amount"],
        total: json["total"],
        status: json["status"],
        itemStatus: json["item_status"],
        order_now_delivery_date: json["order_now_delivery_date"],
        isDivert: json["is_divert"],
        deliveryDate: json["delivery_date"],
        pickupTime: json["pickup_time"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_item_id": orderItemId,
        "ordertype": orderType,
        "order_number": orderNumber,
        "order_date": orderDate,
        // "order_from": orderFrom,
        "order_delivery_date": order_delivery_date,
        "customer_name": customerName,
        "special_instruction": specialInstruction,
    "items_detail": itemsDetail == null
        ? []
        : List<dynamic>.from(itemsDetail!.map((x) => x.toJson())),        "discount": discount,
        "package": package,
        "package_name": packageName,
        "packaging_charge": packagingCharge,
        "reason": reason,
        "category": category,
        "amount": amount,
        "net_amount": netAmount,
        "total": total,
        "status": status,
        "item_status": itemStatus,
        "order_now_delivery_date": order_now_delivery_date,
        "is_divert": isDivert,
        "delivery_date": deliveryDate,
        "pickup_time": pickupTime,
      };
}

class ItemsDetail {
  final String? quantity;
  final String? itemName;

  ItemsDetail({
    this.quantity,
    this.itemName,
  });

  factory ItemsDetail.fromJson(Map<String, dynamic> json) => ItemsDetail(
    quantity: json["quantity"],
    itemName: json["item_name"],
  );

  Map<String, dynamic> toJson() => {
    "quantity": quantity,
    "item_name": itemName,
  };
}
