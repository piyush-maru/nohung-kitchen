

class LiveOrderModel1 {
  bool? status;
  String? message;
  Data? data;

  LiveOrderModel1({this.status, this.message, this.data});

  LiveOrderModel1.fromJson(Map<String, dynamic> json) {
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
  List<Orders>? orders;
  List<BreakfastOrders>? breakfastOrders;
  List<LunchOrders>? lunchOrders;
  List<DinnerOrders>? dinnerOrders;
  List<PreOrders>? preOrders;
  dynamic totalOrders;
  dynamic totalBreakfastOrders;
  dynamic totalLunchOrders;
  dynamic totalDinnerOrders;
  dynamic totalPreOrders;
  dynamic currentDate;

  Data(
      {this.orders,
        this.breakfastOrders,
        this.lunchOrders,
        this.dinnerOrders,
        this.preOrders,
        this.totalOrders,
        this.totalBreakfastOrders,
        this.totalLunchOrders,
        this.totalDinnerOrders,
        this.totalPreOrders,
        this.currentDate,});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }if (json['breakfast_orders'] != null) {
      breakfastOrders = <BreakfastOrders>[];
      json['breakfast_orders'].forEach((v) {
        breakfastOrders!.add(new BreakfastOrders.fromJson(v));
      });
    }if (json['lunch_orders'] != null) {
      lunchOrders = <LunchOrders>[];
      json['lunch_orders'].forEach((v) {
        lunchOrders!.add(new LunchOrders.fromJson(v));
      });
    }if (json['dinner_orders'] != null) {
      dinnerOrders = <DinnerOrders>[];
      json['dinner_orders'].forEach((v) {
        dinnerOrders!.add(new DinnerOrders.fromJson(v));
      });
    }if (json['pre_orders'] != null) {
      preOrders = <PreOrders>[];
      json['pre_orders'].forEach((v) {
        preOrders!.add(new PreOrders.fromJson(v));
      });
    }
    totalOrders = json['total_orders'];
    totalBreakfastOrders = json['total_breakfast_orders'];
    totalLunchOrders = json['total_lunch_orders'];
    totalDinnerOrders = json['total_dinner_orders'];
    totalPreOrders = json['total_pre_orders'];
    currentDate = json['current_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    if (this.breakfastOrders != null) {
      data['breakfast_orders'] = this.breakfastOrders!.map((v) => v.toJson()).toList();
    }
    if (this.lunchOrders != null) {
      data['lunch_orders'] = this.lunchOrders!.map((v) => v.toJson()).toList();
    }
    if (this.dinnerOrders != null) {
      data['dinner_orders'] = this.dinnerOrders!.map((v) => v.toJson()).toList();
    }
    if (this.preOrders != null) {
      data['pre_orders'] = this.preOrders!.map((v) => v.toJson()).toList();
    }
    data['total_orders'] = this.totalOrders;
    data['total_breakfast_orders'] = this.totalBreakfastOrders;
    data['total_lunch_orders'] = this.totalLunchOrders;
    data['total_dinner_orders'] = this.totalDinnerOrders;
    data['total_pre_orders'] = this.totalPreOrders;
    data['current_date'] = this.currentDate;
    return data;
  }
}

class Orders {
  String? orderId;
  String? orderitemsId;
  String? orderType;
  String? orderNumber;
  String? deliveryDate;
  String? pickupTime;
  String? mealFor;
  String? itemName;
  String? status;
  String? itemStatus;
  String? isSubscription;
  String? orderTypes;
  CustomerDetail? customerDetail;
  String? specialInstruction;

  Orders(
      {this.orderId,
        this.orderitemsId,
        this.orderType,
        this.orderNumber,
        this.deliveryDate,
        this.pickupTime,
        this.mealFor,
        this.itemName,
        this.status,
        this.itemStatus,
        this.isSubscription,
        this.orderTypes,
        this.customerDetail,
        this.specialInstruction});

  Orders.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderitemsId = json['orderitems_id'];
    orderType = json['order_type'];
    orderNumber = json['order_number'];
    deliveryDate = json['delivery_date'];
    pickupTime = json['pickup_time'];
    mealFor = json['meal_for'];
    itemName = json['item_name'];
    status = json['status'];
    itemStatus = json['item_status'];
    isSubscription = json['is_subscription'];
    orderTypes = json['orderType'];
    customerDetail = json['customer_detail'] != null
        ? new CustomerDetail.fromJson(json['customer_detail'])
        : null;
    specialInstruction = json['special_instruction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['orderitems_id'] = this.orderitemsId;
    data['order_type'] = this.orderType;
    data['order_number'] = this.orderNumber;
    data['delivery_date'] = this.deliveryDate;
    data['pickup_time'] = this.pickupTime;
    data['meal_for'] = this.mealFor;
    data['item_name'] = this.itemName;
    data['status'] = this.status;
    data['item_status'] = this.itemStatus;
    data['is_subscription'] = this.isSubscription;
    data['orderType'] = this.orderTypes;
    if (this.customerDetail != null) {
      data['customer_detail'] = this.customerDetail!.toJson();
    }
    data['special_instruction'] = this.specialInstruction;
    return data;
  }
}
class BreakfastOrders {
  String? orderId;
  String? orderitemsId;
  String? orderType;
  String? orderNumber;
  String? deliveryDate;
  String? pickupTime;
  String? mealFor;
  String? itemName;
  String? status;
  String? itemStatus;
  String? isSubscription;
  String? orderTypes;
  CustomerDetail? customerDetail;
  String? specialInstruction;

  BreakfastOrders(
      {this.orderId,
        this.orderitemsId,
        this.orderType,
        this.orderNumber,
        this.deliveryDate,
        this.pickupTime,
        this.mealFor,
        this.itemName,
        this.status,
        this.itemStatus,
        this.isSubscription,
        this.orderTypes,
        this.customerDetail,
        this.specialInstruction});

  BreakfastOrders.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderitemsId = json['orderitems_id'];
    orderType = json['order_type'];
    orderNumber = json['order_number'];
    deliveryDate = json['delivery_date'];
    pickupTime = json['pickup_time'];
    mealFor = json['meal_for'];
    itemName = json['item_name'];
    status = json['status'];
    itemStatus = json['item_status'];
    isSubscription = json['is_subscription'];
    orderTypes = json['orderType'];
    customerDetail = json['customer_detail'] != null
        ? new CustomerDetail.fromJson(json['customer_detail'])
        : null;
    specialInstruction = json['special_instruction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['orderitems_id'] = this.orderitemsId;
    data['order_type'] = this.orderType;
    data['order_number'] = this.orderNumber;
    data['delivery_date'] = this.deliveryDate;
    data['pickup_time'] = this.pickupTime;
    data['meal_for'] = this.mealFor;
    data['item_name'] = this.itemName;
    data['status'] = this.status;
    data['item_status'] = this.itemStatus;
    data['is_subscription'] = this.isSubscription;
    data['orderType'] = this.orderTypes;
    if (this.customerDetail != null) {
      data['customer_detail'] = this.customerDetail!.toJson();
    }
    data['special_instruction'] = this.specialInstruction;
    return data;
  }
}
class LunchOrders {
  String? orderId;
  String? orderitemsId;
  String? orderType;
  String? orderNumber;
  String? deliveryDate;
  String? pickupTime;
  String? mealFor;
  String? itemName;
  String? status;
  String? itemStatus;
  String? isSubscription;
  String? orderTypes;
  CustomerDetail? customerDetail;
  String? specialInstruction;

  LunchOrders(
      {this.orderId,
        this.orderitemsId,
        this.orderType,
        this.orderNumber,
        this.deliveryDate,
        this.pickupTime,
        this.mealFor,
        this.itemName,
        this.status,
        this.itemStatus,
        this.isSubscription,
        this.orderTypes,
        this.customerDetail,
        this.specialInstruction});

  LunchOrders.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderitemsId = json['orderitems_id'];
    orderType = json['order_type'];
    orderNumber = json['order_number'];
    deliveryDate = json['delivery_date'];
    pickupTime = json['pickup_time'];
    mealFor = json['meal_for'];
    itemName = json['item_name'];
    status = json['status'];
    itemStatus = json['item_status'];
    isSubscription = json['is_subscription'];
    orderTypes = json['orderType'];
    customerDetail = json['customer_detail'] != null
        ? new CustomerDetail.fromJson(json['customer_detail'])
        : null;
    specialInstruction = json['special_instruction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['orderitems_id'] = this.orderitemsId;
    data['order_type'] = this.orderType;
    data['order_number'] = this.orderNumber;
    data['delivery_date'] = this.deliveryDate;
    data['pickup_time'] = this.pickupTime;
    data['meal_for'] = this.mealFor;
    data['item_name'] = this.itemName;
    data['status'] = this.status;
    data['item_status'] = this.itemStatus;
    data['is_subscription'] = this.isSubscription;
    data['orderType'] = this.orderTypes;
    if (this.customerDetail != null) {
      data['customer_detail'] = this.customerDetail!.toJson();
    }
    data['special_instruction'] = this.specialInstruction;
    return data;
  }
}
class DinnerOrders {
  String? orderId;
  String? orderitemsId;
  String? orderType;
  String? orderNumber;
  String? deliveryDate;
  String? pickupTime;
  String? mealFor;
  String? itemName;
  String? status;
  String? itemStatus;
  String? isSubscription;
  String? orderTypes;
  CustomerDetail? customerDetail;
  String? specialInstruction;

  DinnerOrders(
      {this.orderId,
        this.orderitemsId,
        this.orderType,
        this.orderNumber,
        this.deliveryDate,
        this.pickupTime,
        this.mealFor,
        this.itemName,
        this.status,
        this.itemStatus,
        this.isSubscription,
        this.orderTypes,
        this.customerDetail,
        this.specialInstruction});

  DinnerOrders.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderitemsId = json['orderitems_id'];
    orderType = json['order_type'];
    orderNumber = json['order_number'];
    deliveryDate = json['delivery_date'];
    pickupTime = json['pickup_time'];
    mealFor = json['meal_for'];
    itemName = json['item_name'];
    status = json['status'];
    itemStatus = json['item_status'];
    isSubscription = json['is_subscription'];
    orderTypes = json['orderType'];
    customerDetail = json['customer_detail'] != null
        ? new CustomerDetail.fromJson(json['customer_detail'])
        : null;
    specialInstruction = json['special_instruction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['orderitems_id'] = this.orderitemsId;
    data['order_type'] = this.orderType;
    data['order_number'] = this.orderNumber;
    data['delivery_date'] = this.deliveryDate;
    data['pickup_time'] = this.pickupTime;
    data['meal_for'] = this.mealFor;
    data['item_name'] = this.itemName;
    data['status'] = this.status;
    data['item_status'] = this.itemStatus;
    data['is_subscription'] = this.isSubscription;
    data['orderType'] = this.orderTypes;
    if (this.customerDetail != null) {
      data['customer_detail'] = this.customerDetail!.toJson();
    }
    data['special_instruction'] = this.specialInstruction;
    return data;
  }
}
class PreOrders {
  String? orderId;
  String? orderitemsId;
  String? orderType;
  String? orderNumber;
  String? deliveryDate;
  String? pickupTime;
  String? mealFor;
  String? itemName;
  String? status;
  String? itemStatus;
  String? isSubscription;
  String? orderTypes;
  CustomerDetail? customerDetail;
  String? specialInstruction;

  PreOrders(
      {this.orderId,
        this.orderitemsId,
        this.orderType,
        this.orderNumber,
        this.deliveryDate,
        this.pickupTime,
        this.mealFor,
        this.itemName,
        this.status,
        this.itemStatus,
        this.isSubscription,
        this.orderTypes,
        this.customerDetail,
        this.specialInstruction});

  PreOrders.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderitemsId = json['orderitems_id'];
    orderType = json['order_type'];
    orderNumber = json['order_number'];
    deliveryDate = json['delivery_date'];
    pickupTime = json['pickup_time'];
    mealFor = json['meal_for'];
    itemName = json['item_name'];
    status = json['status'];
    itemStatus = json['item_status'];
    isSubscription = json['is_subscription'];
    orderTypes = json['orderType'];
    customerDetail = json['customer_detail'] != null
        ? new CustomerDetail.fromJson(json['customer_detail'])
        : null;
    specialInstruction = json['special_instruction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['orderitems_id'] = this.orderitemsId;
    data['order_type'] = this.orderType;
    data['order_number'] = this.orderNumber;
    data['delivery_date'] = this.deliveryDate;
    data['pickup_time'] = this.pickupTime;
    data['meal_for'] = this.mealFor;
    data['item_name'] = this.itemName;
    data['status'] = this.status;
    data['item_status'] = this.itemStatus;
    data['is_subscription'] = this.isSubscription;
    data['orderType'] = this.orderTypes;
    if (this.customerDetail != null) {
      data['customer_detail'] = this.customerDetail!.toJson();
    }
    data['special_instruction'] = this.specialInstruction;
    return data;
  }
}

class CustomerDetail {
  String? customerName;
  String? customerMobilenumber;
  String? customerImage;

  CustomerDetail(
      {this.customerName, this.customerMobilenumber, this.customerImage});

  CustomerDetail.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    customerMobilenumber = json['customer_mobilenumber'];
    customerImage = json['customer_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_name'] = this.customerName;
    data['customer_mobilenumber'] = this.customerMobilenumber;
    data['customer_image'] = this.customerImage;
    return data;
  }
}
