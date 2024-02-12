// import 'dart:async';
// import 'dart:io';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:kitchen/Order/ActiveScreen.dart';
// import 'package:kitchen/Order/OrdersHistory.dart';
// import 'package:kitchen/Order/RequestScreen.dart';
// import 'package:kitchen/Order/UpcomingScreen.dart';
// import 'package:kitchen/main.dart';
// import 'package:kitchen/model/BeanGetOrderRequest.dart';
// import 'package:kitchen/model/GetActiveOrder.dart';
// import 'package:kitchen/model/GetOrderHistory.dart';
// import 'package:kitchen/model/GetUpComingOrder.dart';
// import 'package:kitchen/model/KitchenData/BeanLogin.dart';
// import 'package:kitchen/network/ApiProvider.dart';
// import 'package:kitchen/network/OrderRepo/active_orders_repo.dart';
// import 'package:kitchen/network/OrderRepo/order_request_model.dart';
// import 'package:kitchen/res.dart';
// import 'package:kitchen/src/presentation/screens/HomeBaseScreen.dart';
// import 'package:kitchen/utils/Constants.dart';
// import 'package:kitchen/utils/Utils.dart';
// import 'package:kitchen/utils/constant/ui_constants.dart';
// import 'package:provider/provider.dart';
// class OrderScreen extends StatefulWidget {
//   final bool? currentTablSelected;
//   final int? index;
//
//   OrderScreen(this.currentTablSelected, this.index);
//
//   @override
//   _OrderScreenState createState() => _OrderScreenState();
// }
//
// class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   var isSelected = 0;
//   var userId;
//   BeanLogin? userBean;
//   TabController? _tabController;
//   var activeCount;
//   var orderRequestCount;
//   var upcomingCount;
//   var orderHistoryCount;
//   Future<GetActiveOrder>? future;
//   bool isLodingDesable = false;
//   Timer? timer;
//   bool? kitchenStatus = true;
//
//   int difference = 0;
//   bool isBackground = false;
//   List mydata = [];
//
//   @override
//   void initState() {
//     getUser().then((value) {});
//     final activeModel = Provider.of<ActiveOrderModel>(context, listen: false);
//
//     activeModel.getActiveOrders();
//     getActiveOrder(context);
//     getOrderRequest(context);
//     getUpComingOrder(context);
//
//     print("+++++++++++++++++++++upcoming data${upcomingCount}");
//     _tabController = TabController(length: 4, vsync: this);
//     _tabController!.addListener(_handleTabSelection);
//     super.initState();
//     const twentyMillis = Duration(seconds: 20);
//     timer = Timer.periodic(twentyMillis, (timer) {
//       if (widget.currentTablSelected!) {
//         if (kitchenStatus == true || kitchenStatus == null) {
//           final orderRequest =
//               Provider.of<OrderRequestModel>(context, listen: false);
//           getOrderRequest(context);
//           // _future = getOrders(context);
//         } else {
//           timer.cancel();
//         }
//       }
//     });
//   }
//
//   Future getUser() async {
//     userBean = await Utils.getUser();
//     userId = userBean!.data!.id.toString();
//     setState(() {});
//   }
//
//   // To reset all the applied filter.
//   void _handleTabSelection() {
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         drawer: MyDrawers(),
//
//         appBar: AppBar(
//           elevation: 0,
//           centerTitle: false,
//           backgroundColor: AppConstant.appColor,
//           leading: InkWell(
//               onTap: () {
//                 setState(() {
//                   _scaffoldKey.currentState!.openDrawer();
//                 });
//               },
//               child: Image.asset(
//                 Res.ic_menu,
//                 width: 10,
//                 height: 10,
//                 color: Colors.white,
//               )),
//
//           title:poppinsText(
//               maxLines: 3,
//               txt: _tabController!.index == 0
//                   ? "Request Orders (${orderRequestCount == null ? 0 : orderRequestCount})"
//                   : _tabController!.index == 1
//                   ? "Active Orders (${activeCount == null ? 0 : activeCount})"
//                   : _tabController!.index == 2
//                   ? "Upcoming Orders (${mydata.length == null ? 0 : mydata.length})"
//                   : "Order History",
//               fontSize: 25,
//               textAlign: TextAlign.center,
//               weight: FontWeight.w500),
//
//         ),
//
//
//         backgroundColor: AppConstant.appColor,
//         key: _scaffoldKey,
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 60,
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(20),
//                       topLeft: Radius.circular(20))),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
//                 child: TabBar(
//                   indicator: BoxDecoration(
//                     borderRadius: BorderRadius.circular(
//                       10.0,
//                     ),
//                     color: AppConstant.appColor,
//                   ),
//                   isScrollable: true,
//                   labelStyle:
//                       TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                   indicatorSize: TabBarIndicatorSize.label,
//                   controller: _tabController,
//                   labelColor: Colors.white,
//                   unselectedLabelColor: Colors.black,
//                   tabs: [
//                     Container(
//                       decoration: BoxDecoration(
//                           color: (_tabController!.index == 0)
//                               ? AppConstant.appColor
//                               : AppConstant.appColor,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Tab(
//                           text: 'Request',
//                         ),
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                           color: (_tabController!.index == 1)
//                               ? AppConstant.appColor
//                               : AppConstant.appColor,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Tab(
//                           text: 'Active',
//                         ),
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                           color: (_tabController!.index == 2)
//                               ? AppConstant.appColor
//                               : AppConstant.appColor,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Tab(
//                           text: 'Upcoming',
//                         ),
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                           color: (_tabController!.index == 3)
//                               ? AppConstant.appColor
//                               : AppConstant.appColor,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Tab(
//                           text: 'Order History',
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   // first tab bar view widget
//                   RequestScreen(
//                       /*currentTablSelected:widget.currentTablSelected!*/),
//                   ActiveScreen(refreshOrdersCallback: () {
//                     setState(() {
//                       future =
//                           context.read<ActiveOrderModel>().getActiveOrders();
//                     });
//                   }),
//                   UpcomingScreen(),
//                   OrdersHistory(),
//                   // TrialRequestScreen(),
//                   //LiveOrdersScreen(),
//                   // second tab bar view widget
//                 ],
//               ),
//             ),
//           ],
//         ));
//   }
//
//   Future<GetActiveOrder?> getActiveOrder(BuildContext context) async {
//     try {
//       var userBean = await Utils.getUser();
//       FormData from = FormData.fromMap({
//         "kitchen_id": userBean.data!.id.toString(),
//         "token": "123456789",
//         "filter_fromdate": '2021-10-8',
//         "filter_todate": "",
//         "filter_order_number": ""
//       });
//
//       GetActiveOrder? bean = await ApiProvider().getActiveOrder();
//
//       if (bean.status == true) {
//         setState(() {
//           activeCount = bean.data.length;
//         });
//
//         return bean;
//       } else {
//         print("  286 ${bean.message}");
//         // Utils.showToast(bean.message, context);
//       }
//     } on HttpException catch (exception) {
//       print(exception);
//     } catch (exception) {}
//     return null;
//   }
//   final player = AudioPlayer();
//   Future<BeanGetOrderRequest> getOrderRequest(BuildContext context) async {
//     int? lenght = await getOrdersRequestCount();
//     var userBean = await Utils.getUser();
//     FormData from = FormData.fromMap({
//       "kitchen_id": userBean.data!.id,
//       "token": "123456789",
//     });
//     BeanGetOrderRequest bean = await ApiProvider().getOrderRequest();
//     if (bean.data!.length > (lenght ?? 0)) {
//       setState(() {
//       });
//     }
//     if (bean.status == true) {
//       if (!isBackground) {
//         saveOrdersRequestCount(bean.data!.length);
//       }
//       setState(() {
//         orderRequestCount = bean.data!.length;
//       });
//     }
//     return bean;
//   }
//
//   Future<GetUpComingOrder?> getUpComingOrder(BuildContext context) async {
//     try {
//       var userBean = await Utils.getUser();
//       FormData from = FormData.fromMap({
//         "kitchen_id": userBean.data!.id.toString(),
//         "token": "123456789",
//         "filter_fromdate": '',
//         "filter_todate": "",
//         "filter_order_number": ""
//       });
//
//       GetUpComingOrder? bean = await ApiProvider().getUpComingOrder();
//
//       if (bean.status == true) {
//         setState(() {
//           upcomingCount = bean.updata!.length;
//
//           for (int i = 0; i < bean.updata!.length; i++) {
//             for (int j = 0; j < bean.updata![i].data!.length; j++) {
//               mydata.add(j);
//             }
//           }
//           print("+++++++++++++++++++++upcoming data${mydata.length}");
//           print("+++++++++++++++++++++upcoming data${bean.updata!.length}");
//         });
//
//         return bean;
//       } else {
//         print("  416 ${bean.message}");
//
//       }
//     } on HttpException catch (exception) {
//       print(exception);
//     } catch (exception) {}
//     return null;
//   }
//
//   Future<GetOrderHistory?> getOrderHistory(BuildContext context) async {
//     try {
//       var userBean = await Utils.getUser();
//       FormData from = FormData.fromMap({
//         "kitchen_id": userBean.data!.id.toString(),
//         "token": "123456789",
//       });
//
//       GetOrderHistory? bean = await ApiProvider().getOrderHistory();
//
//       if (bean.status == true) {
//         setState(() {
//           upcomingCount = bean.data.length;
//         });
//
//         return bean;
//       } else {
//         print("  444 ${bean.message}");
//
//         // Utils.showToast(bean.message, context);
//       }
//     } on HttpException catch (exception) {
//       print(exception);
//     } catch (exception) {}
//     return null;
//   }
// }
