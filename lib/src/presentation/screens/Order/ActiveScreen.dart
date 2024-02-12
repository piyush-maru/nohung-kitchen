// import 'dart:async';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
// import 'package:kitchen/model/BeanGetOrderDetails.dart';
// import 'package:kitchen/model/GetActiveOrder.dart';
// import 'package:kitchen/model/ReadyToPickupOrder.dart';
// import 'package:kitchen/network/ApiProvider.dart';
// import 'package:kitchen/network/OrderRepo/order_request_model.dart';
// import 'package:kitchen/res.dart';
// import 'package:kitchen/src/presentation/screens/DashboardScreen.dart';
// import 'package:kitchen/utils/Constants.dart';
// import 'package:kitchen/utils/HttpException.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../model/BeanOrderCancel.dart';
// import '../../../../network/OrderRepo/active_orders_repo.dart';
//
// class ActiveScreen extends StatefulWidget {
//   final bool? fromDashboard;
//   Function refreshOrdersCallback;
//
//   ActiveScreen(
//       {Key? key,
//       this.fromDashboard = false,
//       required this.refreshOrdersCallback})
//       : super(key: key);
//
//   @override
//   _ActiveScreenState createState() => _ActiveScreenState();
// }
//
// enum BestTutorSite { too_busy, food_not_available, shop_closed, others }
//
// class _ActiveScreenState extends State<ActiveScreen>
//     with WidgetsBindingObserver {
//   bool isViewLoading = false;
//   var dropdownValue;
//   List<GetActiveOrderData> data = [];
//   var currentDate = "";
//   var userId;
//   var status = "";
//   var descriptionController = TextEditingController();
//   BestTutorSite _site = BestTutorSite.too_busy;
//   bool isSlided = false;
//   Future<GetActiveOrder>? future;
//   bool isLodingDesable = false;
//   bool isBackground = false;
//   Timer? timer;
//
//   @override
//   void initState() {
//     getCurrentDate();
//
//     super.initState();
//     final activeModel = Provider.of<ActiveOrderModel>(context, listen: false);
//     future = activeModel.getActiveOrders();
//     Future.delayed(Duration.zero, () {
//       activeModel.getActiveOrders().then((value) {});
//     });
//     const twentyMillis = Duration(seconds: 2);
//     timer = Timer.periodic(twentyMillis, (timer) {
//       if (kitchenStatus == true || kitchenStatus == null) {
//         final orderRequest =
//             Provider.of<OrderRequestModel>(context, listen: false);
//         getOrderRequest2(context);
//         // _future = getOrders(context);
//       } else {
//         timer.cancel();
//       }
//     });
//   }
//
//   bool isSwitched = false;
//   var textValue = 'Switch is OFF';
//
//   Future<void> _pullRefresh() async {
//     final activeModel = Provider.of<ActiveOrderModel>(context, listen: false);
//
//     Future.delayed(Duration.zero, () {
//       activeModel.getActiveOrders().then((value) {});
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final activeModel = Provider.of<ActiveOrderModel>(context, listen: false);
//     return Scaffold(
//         appBar: (widget.fromDashboard!)
//             ? AppBar(
//                 backgroundColor: AppConstant.appColor,
//                 title: Text(
//                   "Active Orders",
//                   style: TextStyle(fontFamily: AppConstant.fontRegular),
//                 ),
//               )
//             : AppBar(
//                 backgroundColor: Colors.white,
//                 toolbarHeight: 12.5,
//                 elevation: 0,
//               ),
//         backgroundColor: Colors.white,
//         body: RefreshIndicator(
//             onRefresh: _pullRefresh,
//             child: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               child: FutureBuilder<GetActiveOrder>(
//                   future: activeModel.getActiveOrders(),
//                   builder: (context, snapshot) {
//                     return snapshot.hasData
//                         ? snapshot.data!.data.isEmpty
//                             ? Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                     SvgPicture.asset(
//                                         "assets/images/no_orders.svg"),
//                                     SizedBox(
//                                       height: 12,
//                                     ),
//                                     Center(
//                                       child: Text(
//                                         'No Active Orders',
//                                         style: TextStyle(
//                                             fontFamily: AppConstant.fontBold,
//                                             fontSize: 18),
//                                       ),
//                                     )
//                                   ])
//                             : ListView.builder(
//                                 padding: EdgeInsets.only(bottom: 72),
//                                 shrinkWrap: true,
//                                 physics: NeverScrollableScrollPhysics(),
//                                 itemCount: snapshot.data!.data.length,
//                                 itemBuilder: (context, index) {
//                                   return Container(
//                                     margin: const EdgeInsets.symmetric(
//                                         horizontal: 8, vertical: 8),
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(5),
//                                         boxShadow: [
//                                           BoxShadow(
//                                               color:
//                                                   Colors.black.withOpacity(.25),
//                                               blurRadius: 30),
//                                         ],
//                                         color: snapshot.data!.data[index]
//                                                     .orderType ==
//                                                 "package"
//                                             ? Color.fromARGB(255, 226, 254, 254)
//                                             : Colors.white),
//                                     child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 15, vertical: 8),
//                                             child: Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Row(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Padding(
//                                                       padding: EdgeInsets.only(
//                                                           left: 0),
//                                                       child: snapshot
//                                                                   .data!
//                                                                   .data[index]
//                                                                   .customerImage ==
//                                                               ''
//                                                           ? Image.asset(
//                                                               Res.ic_people,
//                                                               width: 50,
//                                                               height: 50,
//                                                             )
//                                                           : Container(
//                                                               width: 50,
//                                                               height: 50,
//                                                               child:
//                                                                   CircleAvatar(
//                                                                 radius: 45,
//                                                                 backgroundImage:
//                                                                     NetworkImage(
//                                                                   '${snapshot.data!.data[index].customerImage}',
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                     ),
//                                                     SizedBox(width: 10),
//                                                     Expanded(
//                                                       child: Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .spaceBetween,
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Column(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .spaceBetween,
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             children: [
//                                                               Container(
//                                                                 //color:Colors.red,
//                                                                 width: MediaQuery.of(
//                                                                             context)
//                                                                         .size
//                                                                         .width *
//                                                                     0.4,
//                                                                 child: Text(
//                                                                   snapshot
//                                                                       .data!
//                                                                       .data[
//                                                                           index]
//                                                                       .customerName,
//                                                                   maxLines: 2,
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .black,
//                                                                       fontSize:
//                                                                           16,
//                                                                       fontFamily:
//                                                                           AppConstant
//                                                                               .fontBold),
//                                                                 ),
//                                                               ),
//                                                               Text(
//                                                                 '${snapshot.data!.data[index].orderNumber}  ',
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .grey,
//                                                                     fontFamily:
//                                                                         AppConstant
//                                                                             .fontBold),
//                                                               ),
//                                                               Text(
//                                                                 snapshot
//                                                                     .data!
//                                                                     .data[index]
//                                                                     .orderDate,
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .black,
//                                                                     fontSize:
//                                                                         14,
//                                                                     fontFamily:
//                                                                         AppConstant
//                                                                             .fontRegular),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           Column(
//                                                             children: [
//                                                               Text(
//                                                                 "${snapshot.data!.data![index].menuFor!.toUpperCase()}  ",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .red,
//                                                                     fontSize:
//                                                                         16,
//                                                                     fontFamily:
//                                                                         AppConstant
//                                                                             .fontBold),
//                                                               ),
//                                                             ],
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 5),
//                                                 snapshot.data!.data[index]
//                                                             .orderType ==
//                                                         "package"
//                                                     ? Text(
//                                                         "Package : ${snapshot.data!.data[index].packageName}",
//                                                         style: TextStyle(
//                                                             fontFamily:
//                                                                 AppConstant
//                                                                     .fontBold),
//                                                       )
//                                                     : SizedBox(),
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Text(
//                                                           "Menu For ${snapshot.data!.data[index].menuFor}",
//                                                           style: TextStyle(
//                                                               color: Color(
//                                                                   0xffA7A8BC),
//                                                               fontSize: 14,
//                                                               fontFamily:
//                                                                   AppConstant
//                                                                       .fontRegular),
//                                                         ),
//                                                         SizedBox(
//                                                           height: 10,
//                                                         ),
//                                                         Text(
//                                                           "Pick up Time : ${snapshot.data!.data![index].pickupTime}",
//                                                           style: TextStyle(
//                                                               color: Colors.red,
//                                                               fontSize: 14,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     InkWell(
//                                                       onTap: () {
//                                                         setState(() {
//                                                           isViewLoading = true;
//                                                         });
//                                                         showAlertDialog(
//                                                             context,
//                                                             snapshot.data!
//                                                                 .data[index],
//                                                             snapshot
//                                                                 .data!
//                                                                 .data[index]
//                                                                 .pickupTime);
//                                                       },
//                                                       child: Card(
//                                                         elevation: 10,
//                                                         shadowColor: AppConstant
//                                                             .appColor,
//                                                         shape:
//                                                             RoundedRectangleBorder(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(6),
//                                                           //set border radius more than 50% of height and width to make circle
//                                                         ),
//                                                         child: Container(
//                                                           alignment:
//                                                               Alignment.center,
//                                                           height: 35,
//                                                           width: 110,
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             color: Colors.white,
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         6),
//                                                             border: Border.all(
//                                                                 color: AppConstant
//                                                                     .appColor),
//                                                           ),
//                                                           child: Text(
//                                                             "View Order",
//                                                             style: TextStyle(
//                                                                 color: AppConstant
//                                                                     .appColor,
//                                                                 fontFamily:
//                                                                     AppConstant
//                                                                         .fontRegular,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 5),
//                                                 Row(
//                                                   children: [
//                                                     Image.asset(
//                                                       Res.ic_breakfast,
//                                                       width: 20,
//                                                       height: 20,
//                                                     ),
//                                                     SizedBox(width: 10),
//                                                     Flexible(
//                                                       child: Padding(
//                                                         padding:
//                                                             EdgeInsets.only(
//                                                                 left: 5),
//                                                         child: Text(
//                                                           snapshot
//                                                               .data!
//                                                               .data[index]
//                                                               .orderItems,
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.black,
//                                                               fontSize: 14,
//                                                               fontFamily:
//                                                                   AppConstant
//                                                                       .fontBold),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Padding(
//                                                   padding: const EdgeInsets
//                                                       .symmetric(vertical: 8.0),
//                                                   child: Divider(
//                                                       color: Colors.grey),
//                                                 ),
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.end,
//                                                   children: [
//                                                     snapshot.data!.data[index]
//                                                                 .orderStatus ==
//                                                             'Ready to Pick-up'
//                                                         ? Row(children: [
//                                                             Text(
//                                                               "Ready to Pick-Up",
//                                                               style: TextStyle(
//                                                                   fontFamily:
//                                                                       AppConstant
//                                                                           .fontBold,
//                                                                   color: AppConstant
//                                                                       .appColor),
//                                                             ),
//                                                             SizedBox(
//                                                               width: 10,
//                                                             ),
//                                                             Transform.scale(
//                                                                 scale: 1.5,
//                                                                 child: Switch(
//                                                                   onChanged:
//                                                                       (value) {
//                                                                     if (isSwitched ==
//                                                                         false) {
//                                                                       setState(
//                                                                           () {
//                                                                         isSwitched =
//                                                                             true;
//                                                                         isSlided =
//                                                                             true;
//                                                                         acceptDialog(
//                                                                             snapshot.data!.data[index].status.toString(),
//                                                                             snapshot.data!.data[index].orderItemsId);
//                                                                         textValue =
//                                                                             'Switch Button is ON';
//                                                                         isSwitched =
//                                                                             false;
//                                                                       });
//                                                                     } else {
//                                                                       setState(
//                                                                           () {
//                                                                         textValue =
//                                                                             'Switch Button is OFF';
//                                                                       });
//                                                                     }
//                                                                   },
//                                                                   value:
//                                                                       isSwitched,
//                                                                   activeColor:
//                                                                       AppConstant
//                                                                           .appColor,
//                                                                   activeTrackColor:
//                                                                       AppConstant
//                                                                           .appColorLite,
//                                                                   inactiveThumbColor:
//                                                                       Colors
//                                                                           .white70,
//                                                                   inactiveTrackColor:
//                                                                       Colors
//                                                                           .green,
//                                                                 ))
//                                                           ])
//                                                         : GestureDetector(
//                                                             onTap: () {},
//                                                             child: Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                       .symmetric(
//                                                                       vertical:
//                                                                           15.0),
//                                                               child: Container(
//                                                                 width: 200,
//                                                                 height: 42,
//                                                                 decoration:
//                                                                     BoxDecoration(
//                                                                   color: Colors
//                                                                       .black54,
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               20),
//                                                                 ),
//                                                                 child: Row(
//                                                                   mainAxisAlignment:
//                                                                       MainAxisAlignment
//                                                                           .spaceEvenly,
//                                                                   children: [
//                                                                     Text(
//                                                                       snapshot
//                                                                           .data!
//                                                                           .data[
//                                                                               index]
//                                                                           .orderStatus,
//                                                                       style: TextStyle(
//                                                                           color: Colors
//                                                                               .white,
//                                                                           fontSize:
//                                                                               13,
//                                                                           fontFamily:
//                                                                               AppConstant.fontBold),
//                                                                     ),
//                                                                     // (data.orderStatus == 'Order in Preparation') ?
//                                                                     Icon(
//                                                                         Icons
//                                                                             .check,
//                                                                         color: Colors
//                                                                             .white)
//                                                                     //  : Container(),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                   ],
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ]),
//                                   );
//                                 },
//                               )
//                         : Container(
//                             alignment: Alignment.center,
//                             height: 500,
//                             child: CircularProgressIndicator(
//                               color: AppConstant.appColor,
//                             ));
//                   }),
//             )));
//   }
//
//   showAlertDialog(
//       BuildContext context, GetActiveOrderData data, String pickupTime) async {
//     GetOrderDetailsData? orderDetails;
//     orderDetails =
//         await getOrderDetails(context, data.orderId, data.orderItemsId);
//     orderDetails != null
//         ? showDialog<void>(
//             barrierDismissible: true,
//             context: context,
//             builder: (BuildContext context) {
//               return Scaffold(
//                   body: Container(
//                 padding:
//                     const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 color: Colors.white,
//                 child: SingleChildScrollView(
//                   physics: BouncingScrollPhysics(),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Align(
//                           alignment: Alignment.topRight,
//                           child: IconButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               icon: Icon(Icons.cancel))),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text(
//                             "Order Number:",
//                             style: TextStyle(
//                                 color: Colors.blue,
//                                 fontSize: 14,
//                                 fontFamily: AppConstant.fontRegular,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "${orderDetails!.orderNumber}",
//                             style: TextStyle(
//                                 color: Colors.blue,
//                                 fontFamily: AppConstant.fontRegular,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold),
//                             maxLines: 1,
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         width: 10,
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Expanded(
//                             child: Text(
//                               "Order Date:",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontFamily: AppConstant.fontRegular),
//                             ),
//                           ),
//                           Text(
//                             "${orderDetails.orderDate}",
//                             style:
//                                 TextStyle(fontFamily: AppConstant.fontRegular),
//                             maxLines: 1,
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         width: 10,
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Expanded(
//                             child: Text(
//                               "Customer Name:",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontFamily: AppConstant.fontRegular),
//                             ),
//                           ),
//                           Text(
//                             "${data.customerName}",
//                             style:
//                                 TextStyle(fontFamily: AppConstant.fontRegular),
//                             maxLines: 1,
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text(
//                             "Pickup Time: ",
//                             style: TextStyle(
//                                 fontFamily: AppConstant.fontRegular,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.red),
//                           ),
//                           Text(
//                             "$pickupTime",
//                             style: TextStyle(
//                                 fontFamily: AppConstant.fontRegular,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.red),
//                             maxLines: 1,
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         width: 10,
//                         height: 10,
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 8),
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 8),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             boxShadow: [
//                               BoxShadow(
//                                   color: Colors.black.withOpacity(.25),
//                                   blurRadius: 30),
//                             ],
//                             border: Border.all(
//                               color: Color.fromARGB(255, 208, 207, 206),
//                             ),
//                             color: Colors.white),
//                         child: Column(
//                           children: [
//                             ListView.builder(
//                               itemCount: orderDetails.itemsDetail?.length,
//                               shrinkWrap: true,
//                               scrollDirection: Axis.vertical,
//                               physics: BouncingScrollPhysics(),
//                               itemBuilder: (context, index) {
//                                 return Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     Text(
//                                       "${orderDetails!.itemsDetail?[index].quantity} x ${orderDetails.itemsDetail?[index].itemName}",
//                                       style: TextStyle(
//                                           fontFamily: AppConstant.fontRegular),
//                                     ),
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                   ],
//                                 );
//                               },
//                             ),
//                             // Text("Special Instructions : ${data.orderItems}"),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                         height: 10,
//                       ),
//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 8),
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 8),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             boxShadow: [
//                               BoxShadow(
//                                   color: Colors.black.withOpacity(.25),
//                                   blurRadius: 30),
//                             ],
//                             border: Border.all(
//                               color: Color.fromARGB(255, 208, 207, 206),
//                             ),
//                             color: Colors.white),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Special Instructions : ${orderDetails.specialInstruction ?? "N/A"}",
//                               style: TextStyle(
//                                   fontFamily: AppConstant.fontRegular),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 "Discount : ${orderDetails.discount}",
//                                 maxLines: 1,
//                                 textAlign: TextAlign.end,
//                                 style: TextStyle(
//                                     fontFamily: AppConstant.fontRegular,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Text(
//                                 "Subscription : ${orderDetails.package}",
//                                 maxLines: 1,
//                                 textAlign: TextAlign.end,
//                                 style: TextStyle(
//                                     fontFamily: AppConstant.fontBold,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12),
//                               ),
//                               SizedBox(
//                                 height: 12,
//                               ),
//                               Text(
//                                 "Packing Charges : ${orderDetails.packagingCharge}",
//                                 style: TextStyle(
//                                     fontFamily: AppConstant.fontBold,
//                                     fontSize: 12),
//                               ),
//                               SizedBox(
//                                 height: 10,
//                               ),
//                               Text(
//                                 "Total : ${orderDetails.total}",
//                                 maxLines: 1,
//                                 textAlign: TextAlign.end,
//                                 style: TextStyle(
//                                     fontFamily: AppConstant.fontRegular,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               Navigator.of(context).pop();
//                               cancelDialog(context, data, orderDetails!);
//                             },
//                             child: Card(
//                               elevation: 10,
//                               shadowColor: AppConstant.appColor,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(6),
//                                 //set border radius more than 50% of height and width to make circle
//                               ),
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 height: 35,
//                                 width: 110,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(6),
//                                   border:
//                                       Border.all(color: AppConstant.appColor),
//                                 ),
//                                 child: Text(
//                                   "Cancel Order",
//                                   style: TextStyle(
//                                       color: AppConstant.appColor,
//                                       fontFamily: AppConstant.fontRegular,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           /*GestureDetector(
//                             onTap: () {
//                               cancelDialog(context, data, orderDetails!);
//                               //orderCancel(data.orderId, data.orderType);
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.all(15.0),
//                               padding: const EdgeInsets.all(7.0),
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: AppConstant.appColor),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 ' Cancel Order  ',
//                                 style: TextStyle(
//                                     color: AppConstant.appColor,
//                                     fontFamily: AppConstant.fontBold),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),*/
//                           InkWell(
//                             onTap: () {
//                               Navigator.pop(context, true);
//                             },
//                             child: Card(
//                               elevation: 10,
//                               shadowColor: AppConstant.appColor,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(6),
//                                 //set border radius more than 50% of height and width to make circle
//                               ),
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 height: 35,
//                                 width: 110,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(6),
//                                   border:
//                                       Border.all(color: AppConstant.appColor),
//                                 ),
//                                 child: Text(
//                                   " Back ",
//                                   style: TextStyle(
//                                       color: AppConstant.appColor,
//                                       fontFamily: AppConstant.fontRegular,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           /* GestureDetector(
//                             onTap: () {
//                               Navigator.pop(context, true);
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.all(15.0),
//                               padding: const EdgeInsets.all(7.0),
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: AppConstant.appColor),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 ' Back  ',
//                                 style: TextStyle(
//                                     fontFamily: AppConstant.fontBold,
//                                     color: AppConstant.appColor),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),*/
//                         ],
//                       ),
//                       // const SizedBox(
//                       //   height: 20,
//                       // ),
//                     ],
//                   ),
//                 ),
//               ));
//             },
//           )
//         : Container();
//   }
//
//   cancelDialog(BuildContext context, GetActiveOrderData data,
//       GetOrderDetailsData orderDetails) {
//     final activeModel = Provider.of<ActiveOrderModel>(context, listen: false);
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(12))),
//           child: Container(
//             //height: 200,
//             child: Column(mainAxisSize: MainAxisSize.min, children: [
//               SizedBox(
//                 height: 12,
//               ),
//               Align(
//                 alignment: Alignment.topRight,
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 10),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Image.asset(
//                       Res.ic_cross_image,
//                       fit: BoxFit.fill,
//                       width: 12,
//                       height: 12,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 24,
//               ),
//               Image.asset(
//                 Res.ic_cancel_image,
//                 fit: BoxFit.fill,
//                 //width: 16,
//                 height: 170,
//               ),
//               SizedBox(
//                 height: 24,
//               ),
//               Text(
//                 " Are you sure you want to \ncancel this order?",
//                 textAlign: TextAlign.center,
//                 style:
//                     TextStyle(fontFamily: AppConstant.fontBold, fontSize: 18),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: Colors.black,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 10),
//                         child: Text(
//                           'NO',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontFamily: AppConstant.fontRegular),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 24,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                       showInformationDialog(context, data, orderDetails);
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: AppConstant.appColor,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 10),
//                         child: Text(
//                           'YES',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontFamily: AppConstant.fontRegular),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 24,
//               ),
//             ]),
//           ),
//         );
//       },
//     );
//   }
//
//   acceptDialog(String status, String orderItemId) {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         final activeModel =
//             Provider.of<ActiveOrderModel>(context, listen: false);
//         return Dialog(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(12))),
//           child: Container(
//             //height: 200,
//             child: Column(mainAxisSize: MainAxisSize.min, children: [
//               SizedBox(
//                 height: 12,
//               ),
//               Align(
//                 alignment: Alignment.topRight,
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 10),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Image.asset(
//                       Res.ic_cross_image,
//                       fit: BoxFit.fill,
//                       width: 12,
//                       height: 12,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 24,
//               ),
//               Image.asset(
//                 Res.ic_pick_up_image,
//                 fit: BoxFit.fill,
//                 //width: 16,
//                 height: 130,
//               ),
//               SizedBox(
//                 height: 24,
//               ),
//               Text(
//                 " Are you sure you want to \npick-up the order?",
//                 textAlign: TextAlign.center,
//                 style:
//                     TextStyle(fontFamily: AppConstant.fontBold, fontSize: 18),
//               ),
//               SizedBox(
//                 height: 14,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: Colors.black,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 10),
//                         child: Text(
//                           'NO',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontFamily: AppConstant.fontRegular),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 24,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                       readyToPickUpOrder(context, orderItemId).then((value) {
//                         setState(() {
//                           activeModel.getActiveOrders();
//                         });
//
//                         //Navigator.of(context).pop();
//                         // Navigator.pop(context, true);
//                         // Navigator.pop(context, true);
//                       });
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: AppConstant.appColor,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 10),
//                         child: Text(
//                           'YES',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontFamily: AppConstant.fontRegular),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 24,
//               ),
//             ]),
//           ),
//         );
//       },
//     );
//   }
//
//   /*Future<void> showInformationDialog(BuildContext context,
//       GetActiveOrderData data, GetOrderDetailsData orderDetails) async {
//     return await showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, setState) {
//             return AlertDialog(
//               content: Container(
//                 height: MediaQuery.of(context).size.height / 2.4,
//                 width: MediaQuery.of(context).size.width,
//                 child: Column(
//                   // crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Image.asset(
//                       Res.ic_cancellatin_image,
//                       fit: BoxFit.fill,
//                       //width: 16,
//                       height: 125,
//                     ),
//                     Expanded(
//                       child: ListTile(
//                         title: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _site = BestTutorSite.too_busy;
//                             });
//                           },
//                           child: Text(
//                             'Too Busy',
//                             style:
//                                 TextStyle(fontFamily: AppConstant.fontRegular),
//                           ),
//                         ),
//                         leading: Radio(
//                           value: BestTutorSite.too_busy,
//                           groupValue: _site,
//                           onChanged: (BestTutorSite? value) {
//                             setState(() {
//                               _site = value!;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: ListTile(
//                         title: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _site = BestTutorSite.food_not_available;
//                             });
//                           },
//                           child: Text(
//                             'Food Not Available',
//                             style:
//                                 TextStyle(fontFamily: AppConstant.fontRegular),
//                           ),
//                         ),
//                         leading: Radio(
//                           value: BestTutorSite.food_not_available,
//                           groupValue: _site,
//                           onChanged: (BestTutorSite? value) {
//                             setState(() {
//                               _site = value!;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: ListTile(
//                         title: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _site = BestTutorSite.shop_closed;
//                             });
//                           },
//                           child: Text(
//                             'Shop Closed',
//                             style:
//                                 TextStyle(fontFamily: AppConstant.fontRegular),
//                           ),
//                         ),
//                         leading: Radio(
//                           value: BestTutorSite.shop_closed,
//                           groupValue: _site,
//                           onChanged: (BestTutorSite? value) {
//                             setState(() {
//                               _site = value!;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: ListTile(
//                         title: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _site = BestTutorSite.others;
//                             });
//                           },
//                           child: Text(
//                             'Others',
//                             style:
//                                 TextStyle(fontFamily: AppConstant.fontRegular),
//                           ),
//                         ),
//                         leading: Radio(
//                           value: BestTutorSite.others,
//                           groupValue: _site,
//                           onChanged: (BestTutorSite? value) {
//                             setState(() {
//                               _site = value!;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 16),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.white,
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: const BorderSide(
//                                   color: Color(0xffd3dde4), width: 3),
//                             ),
//                             labelText: "Reason",
//                             labelStyle: const TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 17,
//                                 fontFamily: AppConstant.fontRegular),
//                           ),
//                           controller: descriptionController,
//                           keyboardType: TextInputType.text,
//                           maxLines: 5,
//                           style: TextStyle(
//                               fontFamily: AppConstant.fontRegular,
//                               fontSize: 14,
//                               color: Colors.black),
//                           //decoration: InputDecoration.collapsed(
//                           //hintText: number == "" ? "Number" : number,
//                           //),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               title: Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   'Reason for Cancellation',
//                   style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
//                 ),
//               ),
//               actions: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//
//                         _site.name=="others"
//                             ? showDialog(
//                                 context: context,
//                                 barrierDismissible: false,
//                                 builder: (BuildContext context) =>
//                                     CupertinoAlertDialog(
//                                   content: Text(
//                                     "Please enter reason to cancel order.",
//                                     style: TextStyle(
//                                         fontFamily: AppConstant.fontRegular),
//                                   ),
//                                   actions: <Widget>[
//                                     // CupertinoDialogAction(
//                                     //   isDefaultAction: true,
//                                     //   child: Text('YES'),
//                                     //   onPressed: () {
//                                     //     Navigator.of(context)
//                                     //         .pop();
//                                     //     // Navigator.pop(context);
//                                     //   },
//                                     // ),
//                                     CupertinoDialogAction(
//                                       child: Text(
//                                         "OK",
//                                         style: TextStyle(
//                                             fontFamily:
//                                                 AppConstant.fontRegular),
//                                       ),
//                                       onPressed: () {
//                                         Navigator.of(context).pop();
//                                         //Navigator.of(context).pop();
//                                       },
//                                     )
//                                   ],
//                                 ),
//                               )
//                             : orderCancel(
//                                     (data.orderType == "trial"
//                                         ? orderDetails.orderId
//                                         : orderDetails.orderItemId),
//                                     data.orderType)
//                                 .then((value) {
//                                 Navigator.pop(context, true);
//                                 Navigator.pop(context, true);
//                               });
//                         //   .then((value) {
//                         // if (value.status) {
//                         //   getActiveOrder(context);
//                         // }
//                         // });
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.all(15.0),
//                         padding: const EdgeInsets.all(7.0),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: AppConstant.appColor),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           ' Cancel Order  ',
//                           style: TextStyle(color: AppConstant.appColor),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context, true);
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.all(15.0),
//                         padding: const EdgeInsets.all(7.0),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: AppConstant.appColor),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           ' Back  ',
//                           style: TextStyle(color: AppConstant.appColor),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           });
//         });
//   }*/
//   Future<void> showInformationDialog(BuildContext context,
//       GetActiveOrderData data, GetOrderDetailsData orderDetails) async {
//     final activeModel = Provider.of<ActiveOrderModel>(context, listen: false);
//     return await showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, setState) {
//             return AlertDialog(
//               content: Container(
//                 height: MediaQuery.of(context).size.height / 2.0,
//                 width: MediaQuery.of(context).size.width,
//                 child: Column(
//                   // crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Image.asset(
//                         Res.ic_cancellatin_image,
//                         fit: BoxFit.fill,
//                         //width: 16,
//                         height: 125,
//                       ),
//                     ),
//                     // SizedBox(height: 24,),
//                     Expanded(
//                       child: ListTile(
//                         title: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _site = BestTutorSite.too_busy;
//                             });
//                           },
//                           child: Text('Too Busy'),
//                         ),
//                         leading: Radio(
//                           value: BestTutorSite.too_busy,
//                           groupValue: _site,
//                           onChanged: (BestTutorSite? value) {
//                             setState(() {
//                               _site = value!;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: ListTile(
//                         title: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _site = BestTutorSite.food_not_available;
//                             });
//                           },
//                           child: Text('Food Not Available'),
//                         ),
//                         leading: Radio(
//                           value: BestTutorSite.food_not_available,
//                           groupValue: _site,
//                           onChanged: (BestTutorSite? value) {
//                             setState(() {
//                               _site = value!;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: ListTile(
//                         title: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _site = BestTutorSite.shop_closed;
//                             });
//                           },
//                           child: Text('Shop Closed'),
//                         ),
//                         leading: Radio(
//                           value: BestTutorSite.shop_closed,
//                           groupValue: _site,
//                           onChanged: (BestTutorSite? value) {
//                             setState(() {
//                               _site = value!;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: ListTile(
//                         title: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _site = BestTutorSite.others;
//                             });
//                           },
//                           child: Text('Others'),
//                         ),
//                         leading: Radio(
//                           value: BestTutorSite.others,
//                           groupValue: _site,
//                           onChanged: (BestTutorSite? value) {
//                             setState(() {
//                               _site = value!;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 16,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: 16),
//                       child: TextField(
//                         decoration: InputDecoration(
//                             contentPadding: EdgeInsets.all(5.0),
//                             filled: true,
//                             fillColor: Colors.white,
//                             enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: const BorderSide(
//                                     color: Colors.grey /*(0xffd3dde4)*/,
//                                     width: 3)),
//                             labelText: "Reason",
//                             labelStyle: const TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 15,
//                                 fontFamily: "CentraleSansRegular")),
//                         controller: descriptionController,
//                         keyboardType: TextInputType.text,
//                         maxLines: 4,
//                         style: TextStyle(
//                             fontFamily: AppConstant.fontRegular,
//                             fontSize: 14,
//                             color: Colors.black),
//                         //decoration: InputDecoration.collapsed(
//                         //hintText: number == "" ? "Number" : number,
//                         //),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Reason for Cancellation',
//                     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Image.asset(
//                       Res.ic_cross_image,
//                       fit: BoxFit.fill,
//                       width: 12,
//                       height: 12,
//                     ),
//                   ),
//                 ],
//               ),
//               actions: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 14),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       /*GestureDetector(
//                         onTap: () {
//                           orderCancel(
//                                   (data.orderType == "trial"
//                                       ? orderDetails.orderId
//                                       : orderDetails.orderItemId),
//                                   data.orderType!)
//                               .then((value) {
//                             Navigator.pop(context, true);
//                             Navigator.pop(context, true);
//                           });
//                           //   .then((value) {
//                           // if (value.status) {
//                           //   getActiveOrder(context);
//                           // }
//                           // });
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.all(15.0),
//                           padding: const EdgeInsets.all(7.0),
//                           decoration: BoxDecoration(
//                               border: Border.all(color: AppConstant.appColor),
//                               borderRadius: BorderRadius.circular(8)),
//                           child: Text(
//                             ' Cancel Order  ',
//                             style: TextStyle(color: AppConstant.appColor),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),*/
//                       InkWell(
//                         onTap: () {
//                           Navigator.pop(context, true);
//                         },
//                         child: Container(
//                           alignment: Alignment.center,
//                           height: 35,
//                           width: 90,
//                           /* decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(6),
//                             border: Border.all(color: AppConstant.appColor),
//                           ),*/
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: Colors.black,
//                           ),
//                           child: Text(
//                             " Back ",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontFamily: AppConstant.fontRegular,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           _site.name == "others" &&
//                                   descriptionController.text.isEmpty
//                               ? cancelReason()
//                               : orderCancel(
//                                       (data.orderType == "trial"
//                                           ? orderDetails.orderId
//                                           : orderDetails.orderItemId),
//                                       data.orderType)
//                                   .then((value) {
//                                   Navigator.pop(context, true);
//                                   /*Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                       builder: (context) => OrderScreen(false, 1,
//                                       )));*/
//                                   //Navigator.pop(context, true);
//                                 });
//                         },
//                         child: Container(
//                           alignment: Alignment.center,
//                           height: 35,
//                           width: 110,
//                           /*decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(6),
//                             border: Border.all(color: AppConstant.appColor),
//                           ),*/
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: AppConstant.appColor,
//                           ),
//                           child: Text(
//                             " Cancel Order ",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontFamily: AppConstant.fontRegular,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//
//                       /*GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context, true);
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.all(15.0),
//                           padding: const EdgeInsets.all(7.0),
//                           decoration: BoxDecoration(
//                               border: Border.all(color: AppConstant.appColor),
//                               borderRadius: BorderRadius.circular(8)),
//                           child: Text(
//                             ' Back  ',
//                             style: TextStyle(color: AppConstant.appColor),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),*/
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           });
//         });
//   }
//
//   Future cancelReason() {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           Future.delayed(Duration(seconds: 1), () {
//             Navigator.of(context).pop(true);
//           });
//           return GestureDetector(
//             child: Dialog(
//               child: Container(
//                 alignment: Alignment.center,
//                 padding: EdgeInsets.all(12),
//                 height: 50,
//                 child: Text(
//                   "Please Enter Reason For Cancel",
//                   style:
//                       TextStyle(fontSize: 20, fontFamily: AppConstant.fontBold),
//                 ),
//               ),
//             ),
//           );
//         });
//   }
//
//   void getCurrentDate() {
//     var now = new DateTime.now();
//     var formatter = new DateFormat('yyyy-MM-dd');
//     currentDate = formatter.format(now);
//   }
//
//   Future? bottomSheetStatus(BuildContext context, String orderItemsId) {
//     showModalBottomSheet(
//         useRootNavigator: true,
//         shape: RoundedRectangleBorder(
//           // <-- for border radius
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(15.0),
//             topRight: Radius.circular(15.0),
//           ),
//         ),
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, setModelState) {
//             return Container(
//               height: 210,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.all(10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Select",
//                           style: TextStyle(
//                               color: Colors.grey,
//                               fontFamily: AppConstant.fontBold,
//                               fontSize: 18),
//                         ),
//                         SizedBox(height: 5),
//                         Container(
//                           height: 5,
//                           width: 80,
//                           decoration: BoxDecoration(
//                             color: AppConstant.appColor,
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (BuildContext context) => CupertinoAlertDialog(
//                           content: Text(
//                             "Are you sure you want to ready to pick-up this order ??",
//                             maxLines: 1,
//                             style:
//                                 TextStyle(fontFamily: AppConstant.fontRegular),
//                           ),
//                           actions: <Widget>[
//                             CupertinoDialogAction(
//                               isDefaultAction: true,
//                               child: Text(
//                                 'YES',
//                                 style: TextStyle(
//                                     fontFamily: AppConstant.fontRegular),
//                               ),
//                               onPressed: () {
//                                 Navigator.pop(context, true);
//                                 // Navigator.of(context).pop();
//                               },
//                             ),
//                             CupertinoDialogAction(
//                               child: Text(
//                                 "NO",
//                                 style: TextStyle(
//                                     fontFamily: AppConstant.fontRegular),
//                               ),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                                 //Navigator.of(context).pop();
//                               },
//                             )
//                           ],
//                         ),
//                       );
//                       // setState(() {
//                       //   //Navigator.pop(context);
//                       //  // status = "Pending";
//                       // });
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         width: 200,
//                         height: 42,
//                         decoration: BoxDecoration(
//                           color: Colors.black,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Ready To Pick Up",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: AppConstant.fontRegular),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   // InkWell(
//                   //   onTap: () {
//                   //     setState(() {
//                   //       Navigator.pop(context);
//                   //       status = "Failed";
//                   //     });
//                   //   },
//                   //   child: Padding(
//                   //     padding: EdgeInsets.all(10),
//                   //     child: Text(
//                   //       "Failed",
//                   //       style: TextStyle(
//                   //           fontSize: 15,
//                   //           color: Colors.black,
//                   //           fontFamily: AppConstant.fontRegular),
//                   //     ),
//                   //   ),
//                   // ),
//                   // InkWell(
//                   //   onTap: () {
//                   //     setState(() {
//                   //       Navigator.pop(context);
//                   //       status = "Confirm";
//                   //     });
//                   //   },
//                   //   child: Padding(
//                   //     padding: EdgeInsets.all(10),
//                   //     child: Text(
//                   //       "Confirm",
//                   //       style: TextStyle(
//                   //           fontSize: 15,
//                   //           color: Colors.black,
//                   //           fontFamily: AppConstant.fontRegular),
//                   //     ),
//                   //   ),
//                   // )
//                 ],
//               ),
//             );
//           });
//           // })
//           //   .then((value) {
//           // setState(() {
//           //   getActiveOrder(context);
//           // });
//         });
//     return null;
//   }
//
//   Future<GetOrderDetailsData?> getOrderDetails(
//       BuildContext context, String orderId, String orderItemId) async {
//     try {
//       FormData from = FormData.fromMap({
//         "kitchen_id": userId.toString(),
//         "token": "123456789",
//         "order_id": orderId,
//         "order_item_id": orderItemId,
//       });
//
//       GetOrderDetailsData? bean =
//           await ApiProvider().getOrderDetails(orderId, orderItemId);
//
//       setState(() {
//         isViewLoading = false;
//       });
//       return bean;
//     } on HttpException catch (exception) {
//       print(exception);
//     } catch (exception) {}
//     return null;
//   }
//
//   Future<ReadyToPickupOrder?> readyToPickUpOrder(
//       BuildContext context, String orderItemsId) async {
//     try {
//       FormData from = FormData.fromMap({
//         "kitchen_id": userId.toString(),
//         "token": '123456789',
//         "orderitems_id": orderItemsId,
//       });
//
//       ReadyToPickupOrder? bean =
//           await ApiProvider().readyToPickupOrder(orderItemsId);
//       final activeModel = Provider.of<ActiveOrderModel>(context, listen: false);
//
//       if (bean.status == true) {
//         activeModel.getActiveOrders().then((value) {
//           setState(() {
//             data = value.data;
//           });
//         });
//         return bean;
//       } else {
//         throw Exception("Something went wrong");
//       }
//     } on HttpException catch (exception) {
//       print(exception);
//     } catch (exception) {}
//     return null;
//   }
//
//   Future<BeanOrderCancel?> orderCancel(String orderId, String orderType) async {
//     try {
//       FormData from = FormData.fromMap({
//         "kitchen_id": userId,
//         "token": "123456789",
//         "order_id": orderId,
//         "ordertype": orderType,
//         "cancellation_type": _site.name,
//         "reason_for_cancellation": descriptionController.text
//       });
//       BeanOrderCancel? bean = await ApiProvider().cancelOrder(
//           orderId, orderType, _site.name, descriptionController.text);
//       final activeModel = Provider.of<ActiveOrderModel>(context, listen: false);
//       if (bean.status == true) {
//         activeModel.getActiveOrders().then((value) {
//           setState(() {
//             data = value.data;
//           });
//         });
//         return bean;
//       } else {
//         throw Exception("Something went wrong");
//       }
//     } on HttpException catch (exception) {
//       print(exception);
//     } catch (exception) {
//       print(exception);
//     }
//     return null;
//   }
// }
