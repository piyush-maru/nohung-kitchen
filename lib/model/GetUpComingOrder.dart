class GetUpComingOrder {
  bool? status;
  String? message;
  List<UpcomingData>? updata;

  GetUpComingOrder({this.status, this.message, this.updata});

  GetUpComingOrder.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      updata = [];
      json['data'].forEach((v) {
        updata!.add(new UpcomingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.updata != null) {
      data['data'] = this.updata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpcomingData {
  String? deliveryDate;
  List<GetUpComingOrderData>? data;

  UpcomingData({this.deliveryDate, this.data});

  UpcomingData.fromJson(Map<String, dynamic> json) {
    deliveryDate = json['delivery_date'];
    if (json['orders'] != null) {
      data = [];
      json['orders'].forEach((v) {
        data!.add(new GetUpComingOrderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivery_date'] = this.deliveryDate;
    if (this.data != null) {
      data['orders'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetUpComingOrderData {
  String? orderId;
  String? orderItemId;
  String? customerName;
  String? customerMobilenumber;
  String? customerImage;
  String? orderNumber;
  String? orderDate;
  String? orderType;
  String? delivery_date;
  String? orderItems;
  String? time;
  String? deliveryAddress;
  String? menuFor;
  String? specialInstruction;

  GetUpComingOrderData(
      {this.orderId,
      this.orderItemId,
      this.customerName,
      this.customerMobilenumber,
      this.customerImage,
      this.orderNumber,
      this.orderDate,
      this.orderType,
      this.delivery_date,
      this.orderItems,
      this.time,
      this.deliveryAddress,
      this.menuFor,
      this.specialInstruction,
      });
  //  "order_id": "324",
  //                 "orderitems_id": "1551",
  // "customer_name": "kranthi",
  // "customer_mobilenumber": "9975791116",
  // "customer_image": "https://nohungkitchen.notionprojects.tech/assets/uploaded/profile/Group36171656670695.png",
  // "order_number": "85333776",
  // "order_date": "2022-09-13",
  // "time": "10:30:00",
  // "order_items": "Veg Sweet Corn Soup + Veg Clear Soup",
  // "delivery_address": "SECURITY CABIN, BOLLINENI HOMES, Bollineni Homes Rd, Sri Sai Nagar, Madhapur, Telangana 500081, India",
  // "menu_for": "Lunch"
  GetUpComingOrderData.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderItemId = json['orderitems_id'];
    customerName = json['customer_name'];
    customerMobilenumber = json['customer_mobilenumber'];
    customerImage = json['customer_image'];
    orderNumber = json['order_number'];
    orderType = json['order_type'];
    delivery_date = json['delivery_date'];
    orderDate = json['order_date'];
    time = json['time'];
    orderItems = json['order_items'];
    deliveryAddress = json['delivery_address'];
    menuFor = json['menu_for'];
    specialInstruction = json['special_instruction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['orderitems_id'] = this.orderItemId;
    data['customer_name'] = this.customerName;
    data['customer_mobilenumber'] = this.customerMobilenumber;
    data['order_number'] = this.orderNumber;
    data['order_date'] = this.orderDate;
    data['order_type'] = this.orderType;
    data['delivery_date'] = this.delivery_date;
    data['time'] = this.time;
    data['order_items'] = this.orderItems;
    data['delivery_address'] = this.deliveryAddress;
    data['menu_for'] = this.menuFor;
    data['special_instruction'] = this.specialInstruction;
    return data;
  }
}
