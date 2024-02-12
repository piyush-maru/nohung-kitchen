class BeanGetDashboard {
  bool? status;
  String? message;
  DashboardData? data;

  BeanGetDashboard({this.status, this.message, this.data});

  BeanGetDashboard.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DashboardData.fromJson(json['data']) : null;
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

class DashboardData {
  String? kitchenName;
  String? kitchenAddress;
  String? profileImage;
  int? activeOrders;
  int? upcomingOrders;
  int? pendingOrders;
  int? completedOrders;
  int? cancelledOrders;
  int? activeDeliveries;
  int? preparing;
  int? ready;
  int? outForDelivery;
  int? profit;
  int? loss;
  String? availableStatus;
  String? description;

  DashboardData(
      {this.kitchenName,
        this.availableStatus,
      this.kitchenAddress,
      this.activeOrders,
      this.profileImage,
      this.upcomingOrders,
      this.pendingOrders,
      this.completedOrders,
      this.activeDeliveries,
      this.cancelledOrders,
      this.preparing,
      this.ready,
      this.outForDelivery,
      this.profit,
      this.loss,
      this.description});
// "kitchen_name": "krishna kitchen",
//         "kitchen_address": "madhapur",
//         "description": "Quality food",
//         "profile_image": "https://nohungkitchen.notionprojects.tech/assets/uploaded/profile/1655475331_scaled_image_picker6082480565329265955.jpg",
//         "pending_orders": 121,
//         "completed_orders": 28,
//         "upcoming_orders": 8,
//         "cancelled_orders": 22,
//         "active_orders": 45,
//         "active_deliveries": 0,
//         "preparing": 12,
//         "ready": 26,
//         "out_for_delivery": 7,
//         "profit": 2950,
//         "loss": 485
  DashboardData.fromJson(Map<String, dynamic> json) {
    kitchenName = json['kitchen_name'];
    kitchenAddress = json['kitchen_address'];
    description = json['description'];
    profileImage = json['profile_image'];
    upcomingOrders = json['upcoming_orders'];
    pendingOrders = json['pending_orders'];
    cancelledOrders = json['cancelled_orders'];
    completedOrders = json['completed_orders'];
    activeOrders = json['active_orders'];
    activeDeliveries = json['active_deliveries'];
    preparing = json['preparing'];
    ready = json['ready'];
    outForDelivery = json['out_for_delivery'];
    profit = json['profit'];
    loss = json['loss'];
    availableStatus=json['available_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kitchen_name'] = this.kitchenName;
    data['kitchen_address'] = this.kitchenAddress;
    data['profile_image'] = this.profileImage;
    data['active_orders'] = this.activeOrders;
    data['upcoming_orders'] = this.upcomingOrders;
    data['pending_orders'] = this.pendingOrders;
    data['cancelled_orders'] = this.cancelledOrders;
    data['completed_orders'] = this.completedOrders;
    data['active_deliveries'] = this.activeDeliveries;
    data['preparing'] = this.preparing;
    data['ready'] = this.ready;
    data['out_for_delivery'] = this.outForDelivery;
    data['profit'] = this.profit;
    data['loss'] = this.loss;
    data['description'] = this.description;
    data['available_status']=this.availableStatus;
    return data;
  }
}
