class GetOrderTrialRequest {
  bool? status;
  String? message;
  List<GetOrderTrialRequestData>? data;

  GetOrderTrialRequest({this.status, this.message, this.data});

  GetOrderTrialRequest.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new GetOrderTrialRequestData.fromJson(v));
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

class GetOrderTrialRequestData {
  String? orderId;
  String? customerName;
  String? customerMobilenumber;
  String? customerImage;
  String? orderNumber;
  String? orderDate;
  String? orderItems;
  String? status;
  String? deliveryAddress;
  String? orderAmount;
  String? totalBill;

  GetOrderTrialRequestData(
      {this.orderId,
      this.customerName,
      this.customerMobilenumber,
      this.customerImage,
      this.orderNumber,
      this.orderDate,
      this.orderItems,
      this.status,
      this.deliveryAddress,
      this.orderAmount,
      this.totalBill});
// "order_id": "345",
// "customer_name": "kranthi",
// "customer_mobilenumber": "9975791116",
// "customer_image": "https://nohungkitchen.notionprojects.tech/assets/uploaded/profile/Group361716566706951663046306.png",
// "order_number": "78219187",
// "order_date": "2022-09-13",
// "order_items": "Paneer Pasanda + Tandoori Chicken",
// "status": "Pending",
// "delivery_address": "door no 45, hyd, H.No.1-90/2/D/67, Hi-Tech City Rd, Behind Image Hospital, 2nd Lane, Vinayaka Nagar, Hi-Tech City, Madhapur, Arunodaya Colony, Vittal Rao Nagar, Hyderabad, Telangana 500081, India",
// "order_amount": "10949.00",
// "total_bill": "12924.00"
  GetOrderTrialRequestData.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    customerName = json['customer_name'];
    customerMobilenumber = json['customer_mobilenumber'];
    customerImage = json['customer_image'];
    orderNumber = json['order_number'];
    orderDate = json['order_date'];
    orderItems = json['order_items'];
    status = json['status'];
    deliveryAddress = json['delivery_address'];
    orderAmount = json['order_amount'];
    totalBill = json['total_bill'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['customer_name'] = this.customerName;
    data['customer_mobilenumber'] = this.customerMobilenumber;
    data['customer_image'] = this.customerImage;
    data['order_number'] = this.orderNumber;
    data['order_date'] = this.orderDate;
    data['order_items'] = this.orderItems;
    data['status'] = this.status;
    data['delivery_address'] = this.deliveryAddress;
    data['order_amount'] = this.orderAmount;
    data['total_bill'] = this.totalBill;
    return data;
  }
}
