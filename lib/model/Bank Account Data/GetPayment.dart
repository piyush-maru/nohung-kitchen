


class GetPayment {
  GetPayment({
     this.status,
     this.message,
   required this.data,
  });

  bool? status;
  String? message;
  PaymentData data;

  factory GetPayment.fromJson(Map<String, dynamic> json) => GetPayment(
    status: json["status"],
    message: json["message"],
    data: PaymentData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class PaymentData {
  PaymentData({
    required this.currentBalance,
    required this.withdrawalFromDate,
    required this.pagination,
    required this.transaction,
  });

  String currentBalance;
  DateTime withdrawalFromDate;
  Pagination pagination;
  List<Transaction> transaction;

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
    currentBalance: json["current_balance"],
    withdrawalFromDate: DateTime.parse(json["withdrawal_from_date"]),
    pagination: Pagination.fromJson(json["pagination"]),
    transaction: List<Transaction>.from(json["transaction"].map((x) => Transaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "current_balance": currentBalance,
    "withdrawal_from_date": "${withdrawalFromDate.year.toString().padLeft(4, '0')}-${withdrawalFromDate.month.toString().padLeft(2, '0')}-${withdrawalFromDate.day.toString().padLeft(2, '0')}",
    "pagination": pagination.toJson(),
    "transaction": List<dynamic>.from(transaction.map((x) => x.toJson())),
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

class Transaction {
  Transaction({
    required this.orderId,
    required this.orderItemsId,
    required this.orderDate,
    required this.customerName,
    required this.orderNumber,
    required this.orderType,
    required this.deliveredDateTime,
    required this.amount,
    required this.paymentStatus,
  });

  String orderId;
  String orderItemsId;
  String orderDate;
  String customerName;
  String orderNumber;
  String orderType;
  String deliveredDateTime;
  String amount;
  String paymentStatus;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    orderId: json["order_id"],
    orderItemsId: json["orderitems_id"],
    orderDate: json["order_date"],
    customerName: json["customer_name"],
    orderNumber: json["order_number"],
    orderType: json["order_type"],
    deliveredDateTime: json["delivered_date_time"],
    amount: json["amount"],
    paymentStatus:json["payment_status"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "orderitems_id": orderItemsId,
    "order_date": orderDate,
    "customer_name": customerName,
    "order_number": orderNumber,
    "order_type": orderType,
    "delivered_date_time": deliveredDateTime,
    "amount": amount,
    "payment_status": paymentStatus,
  };
}

List<Transaction> assetList = [];

// enum OrderType { ORDER_NOW, SUBSCRIPTION }
//
// final orderTypeValues = EnumValues({
//   "Order Now": OrderType.ORDER_NOW,
//   "Subscription": OrderType.SUBSCRIPTION
// });
//
// enum PaymentStatus { PENDING }
//
// final paymentStatusValues = EnumValues({
//   "Pending": PaymentStatus.PENDING
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
