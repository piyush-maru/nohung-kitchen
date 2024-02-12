import 'dart:async';

import 'package:flutter/material.dart';
 import 'package:kitchen/model/GetOrderHistory.dart';
import 'package:kitchen/network/OrderRepo/order_history_model.dart';
import 'package:kitchen/network/OrderRepo/order_request_model.dart';
import 'package:kitchen/src/presentation/screens/DashboardScreen.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:provider/provider.dart';

class OrdersHistory extends StatefulWidget {
  final bool? fromDashboard;
  final String? order;
  final String? filter;

  const OrdersHistory(
      {Key? key, this.fromDashboard = false, this.filter, this.order})
      : super(key: key);

  @override
  _OrdersHistoryState createState() => _OrdersHistoryState();
}

class _OrdersHistoryState extends State<OrdersHistory> {
  String dropdownValue1 = "";
  Future<GetOrderHistory?>? _future;

  int activeOrder = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    setState(() {
      final orderHistoryModel =
          Provider.of<OrderHistoryModel>(context, listen: false);
      _future = orderHistoryModel.getOrderHistory(dropdownValue1 == "All Orders"
          ? "all"
          : dropdownValue1 == "Active Orders"
              ? "active"
              : dropdownValue1 == "Completed Orders"
                  ? "completed"
                  : dropdownValue1 == "Cancelled Orders"
                      ? "cancelled"
                      : widget.order == "cancelled"
                          ? "cancelled"
                          : widget.order == "completed"
                              ? "completed"
                              : "all");
    });
    const twentyMillis = Duration(seconds: 2);
    timer = Timer.periodic(twentyMillis, (timer) {
      if (kitchenStatus == true || kitchenStatus == null) {
        final orderRequest =
            Provider.of<OrderRequestModel>(context, listen: false);
        getOrderRequest2(context);
        // _future = getOrders(context);
      } else {
        timer.cancel();
      }
    });
  }

  var ordersList = <String>[
    'All Order',
    'Active Orders',
    'Completed Orders',
    'Cancelled Orders'
  ];

  Future<void> _pullRefresh() async {
    setState(() {
      final orderHistoryModel =
          Provider.of<OrderHistoryModel>(context, listen: false);
      _future = orderHistoryModel.getOrderHistory(dropdownValue1 == "All Orders"
          ? "all"
          : dropdownValue1 == "Active Orders"
              ? "active"
              : dropdownValue1 == "Completed Orders"
                  ? "completed"
                  : dropdownValue1 == "Cancelled Orders"
                      ? "cancelled"
                      : widget.order == "cancelled"
                          ? "cancelled"
                          : widget.order == "completed"
                              ? "completed"
                              : "all");
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderHistoryModel = Provider.of<OrderHistoryModel>(context, listen: false);
    return Scaffold(
      appBar: (widget.fromDashboard!)
          ? AppBar(
              backgroundColor: AppConstant.appColor,
              title: Text(
                "Completed Orders",
                style: TextStyle(fontFamily: AppConstant.fontRegular),
              ),
            )
          : null,
      /* ? AppBar(
                backgroundColor: AppConstant.appColor,
              )
            : AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                toolbarHeight: 12.5,
              ),*/
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: FutureBuilder<GetOrderHistory?>(
            future: _future,
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null
                  ? SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 12, right: 12, bottom: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DropdownButton<String>(
                                      elevation: 5,
                                      hint: Text(
                                        dropdownValue1.isEmpty
                                            ? "All Orders"
                                            : dropdownValue1,
                                        style: TextStyle(
                                            fontFamily:
                                                AppConstant.fontRegular),
                                      ),
                                      items: <String>[
                                        'All Orders',
                                        'Active Orders',
                                        'Completed Orders',
                                        'Cancelled Orders'
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                fontFamily:
                                                    AppConstant.fontRegular),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          dropdownValue1 = value!;
                                          _pullRefresh();

                                          orderHistoryModel.getOrderHistory(
                                              value == "Active Orders"
                                                  ? "active"
                                                  : value == "Completed Orders"
                                                      ? "completed"
                                                      : value ==
                                                              "Cancelled Orders"
                                                          ? "cancelled"
                                                          : "all");
                                        });
                                      },
                                    ),
                                    DropdownButton<String>(
                                      elevation: 5,
                                      hint: Text(
                                        "Active Orders :${snapshot.data!.data[0].totalActiveOrders.total}",
                                        style: TextStyle(
                                            fontFamily:
                                                AppConstant.fontRegular),
                                      ),
                                      items: <String>[
                                        'Active Orders : ${snapshot.data!.data[0].totalActiveOrders.total}',
                                        'Order Now : ${snapshot.data!.data[0].totalActiveOrders.orderNow}',
                                        'Weekly Orders :${snapshot.data!.data[0].totalActiveOrders.weekly} ',
                                        'Monthly Orders : ${snapshot.data!.data[0].totalActiveOrders.monthly}'
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                fontFamily:
                                                    AppConstant.fontRegular),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        dropdownValue1 = value!;
                                      },
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DropdownButton<String>(
                                    elevation: 5,
                                    hint: Text(
                                      "Completed Order : ${snapshot.data!.data[0].totalCompletedOrders.total}",
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontRegular),
                                    ),
                                    items: <String>[
                                      'Completed Orders : ${snapshot.data!.data[0].totalCompletedOrders.total}',
                                      'Order Now : ${snapshot.data!.data[0].totalCompletedOrders.orderNow} ',
                                      'Weekly :  ${snapshot.data!.data[0].totalCompletedOrders.weekly}',
                                      'Monthly : ${snapshot.data!.data[0].totalCompletedOrders.monthly}'
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                              fontFamily:
                                                  AppConstant.fontRegular),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {},
                                  ),
                                  DropdownButton<String>(
                                    elevation: 5,
                                    hint: Text(
                                      "Total Orders : ${snapshot.data!.data[0].totalOrders.total}",
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontRegular),
                                    ),
                                    items: <String>[
                                      'Total Orders : ${snapshot.data!.data[0].totalOrders.total}',
                                      'Order Now : ${snapshot.data!.data[0].totalOrders.orderNow}',
                                      'Weekly : ${snapshot.data!.data[0].totalOrders.weekly}',
                                      'Monthly : ${snapshot.data!.data[0].totalOrders.monthly}'
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                              fontFamily:
                                                  AppConstant.fontRegular),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (_) {},
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                                itemCount: snapshot.data!.data.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, idx) {
                                  return Container(
                                    child: ListView.builder(
                                        padding: EdgeInsets.only(
                                            bottom: 72, left: 12, right: 12),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data!.data[idx]
                                            .orderHistory.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SubscriptionView(
                                                    orderItems: snapshot
                                                        .data!
                                                        .data[idx]
                                                        .orderHistory[index]
                                                        .orderItems,
                                                    orderType: snapshot
                                                        .data!
                                                        .data[idx]
                                                        .orderHistory[index]
                                                        .orderType,
                                                    orderID: snapshot
                                                        .data!
                                                        .data[idx]
                                                        .orderHistory[index]
                                                        .orderNumber,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            snapshot
                                                                .data!
                                                                .data[idx]
                                                                .orderHistory[
                                                                    index]
                                                                .customerName,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    AppConstant
                                                                        .fontBold),
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            "${snapshot.data!.data[idx].orderHistory[index].orderDateTime.substring(0, 10)}",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    AppConstant
                                                                        .fontRegular),
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            "Ordered time: ${snapshot.data!.data[idx].orderHistory[index].orderDateTime.substring(10, 19)}",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    AppConstant
                                                                        .fontRegular),
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '${snapshot.data!.data[idx].orderHistory[index].orderNumber}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        AppConstant
                                                                            .fontRegular),
                                                              ),
                                                              SizedBox(
                                                                width: 4,
                                                              ),
                                                              Text(
                                                                "|",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: AppConstant
                                                                        .appColor),
                                                              ),
                                                              SizedBox(
                                                                width: 4,
                                                              ),
                                                              Text(
                                                                "${snapshot.data!.data[idx].orderHistory[index].orderType}",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        AppConstant
                                                                            .fontRegular),
                                                              ),
                                                              SizedBox(
                                                                width: 4,
                                                              ),
                                                              snapshot
                                                                      .data!
                                                                      .data[idx]
                                                                      .orderHistory[
                                                                          index]
                                                                      .menuFor
                                                                      .contains(
                                                                          "-")
                                                                  ? Text("")
                                                                  : Text(
                                                                      "|",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              AppConstant.appColor),
                                                                    ),
                                                              SizedBox(
                                                                width: 6,
                                                              ),
                                                              Text(
                                                                "${snapshot.data!.data[idx].orderHistory[index].menuFor.contains("-") ? "" : snapshot.data!.data[idx].orderHistory[index].menuFor}",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        AppConstant
                                                                            .fontRegular),
                                                              ),
                                                            ],
                                                          ),
                                                          /*Row(
                                                     children: [
                                                      // for(int i=0;i<snapshot.data!.data[idx].orderHistory[index].orderItems.length;i++)
                                                       snapshot.data!.data[idx].orderHistory[index].orderType=="Order Now"
                                                           ? Row(
                                                             children: [
                                                               Text("Items: ",
                                                                 // "${AppConstant.rupee} ${snapshot.data!.data[idx].orderHistory[idx].orderItems[index].itemPrice}",
                                                                 style: TextStyle(fontFamily: AppConstant.fontRegular),
                                                               ),
                                                               Container(
                                                                 alignment: Alignment.topLeft,
                                                                 height: 16,
                                                                 width: 110,
                                                                 color: Colors.red,
                                                                 child: ListView.builder(
                                                                     shrinkWrap: true,
                                                                      scrollDirection: Axis.horizontal,
                                                                      itemCount: snapshot.data!.data[idx].orderHistory[index].orderItems.length,
                                                                      physics: NeverScrollableScrollPhysics(),
                                                         itemBuilder: (context, i) {
                                                                   return Text(
                                                                     '${snapshot.data!.data[idx].orderHistory[index].orderItems[i].itemName.toString().replaceAll('[', '').replaceAll(']', '') + ","}',
                                                                     maxLines: 2,
                                                                     overflow: TextOverflow.ellipsis,
                                                                     style: TextStyle(color: Colors.black, fontFamily: AppConstant.fontRegular),
                                                                   );
                                                                 },),
                                                               ),
                                                             ],
                                                           ):
                                                       Text(
                                                         'Package: ${snapshot.data!.data[idx].orderHistory[index].packageName}',
                                                         style: TextStyle(color: Colors.black, fontFamily: AppConstant.fontRegular),
                                                       ),
                                                       Text(
                                                         " | ",
                                                         style: TextStyle(fontSize: 20, color: AppConstant.appColor),
                                                       ),
                                                       snapshot.data!.data[idx].orderHistory[index].orderType=="Order Now"
                                                           ? Text("Items",
                                                        // "${AppConstant.rupee} ${snapshot.data!.data[idx].orderHistory[idx].orderItems[index].itemPrice}",
                                                         style: TextStyle(fontFamily: AppConstant.fontRegular),
                                                       )
                                                           :Text("Package",
                                                         //"${AppConstant.rupee} ${snapshot.data!.data[idx].orderHistory[index].packageName}",
                                                         style: TextStyle(fontFamily: AppConstant.fontRegular),
                                                       ),
                                                     ],
                                                   ),*/
                                                          /* Row(
                                                      children: [
                                                        Text(
                                                          '${snapshot.data!.data[idx].orderHistory[index].orderNumber}',
                                                          style: TextStyle(color: Colors.black, fontFamily: AppConstant.fontRegular),
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          "|",
                                                          style: TextStyle(fontSize: 20, color: AppConstant.appColor),
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          "${snapshot.data!.data[idx].orderHistory[index].orderType}",
                                                          style: TextStyle(fontFamily: AppConstant.fontRegular),
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        snapshot.data!.data[idx].orderHistory[index].menuFor.contains("-")
                                                            ? Text("")
                                                            : Text(
                                                                "|",
                                                                style: TextStyle(fontSize: 20, color: AppConstant.appColor),
                                                              ),
                                                        SizedBox(
                                                          width: 6,
                                                        ),
                                                        Text(
                                                          "${snapshot.data!.data[idx].orderHistory[index].menuFor.contains("-") ? "" : snapshot.data!.data[idx].orderHistory[index].menuFor}",
                                                          style: TextStyle(fontFamily: AppConstant.fontRegular),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "${snapshot.data!.data[idx].orderHistory[index].packageName == "-" ? "" : snapshot.data!.data[idx].orderHistory[index].packageName}"
                                                          .toUpperCase(),
                                                      style: TextStyle(fontFamily: AppConstant.fontRegular),
                                                    ),
                                                    SizedBox(
                                                      height: 6,
                                                    ),
                                                    Row(children: [
                                                      Text(
                                                        "${snapshot.data!.data[idx].orderHistory[index].orderDateTime.substring(0, 10)}",
                                                        style: TextStyle(fontFamily: AppConstant.fontRegular),
                                                      ),
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                      Text(
                                                        "|",
                                                        style: TextStyle(fontFamily: AppConstant.fontBold, color: AppConstant.appColor),
                                                      ),
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                      Text(
                                                        "${snapshot.data!.data[idx].orderHistory[index].orderDateTime.substring(11, snapshot.data!.data[idx].orderHistory[index].orderDateTime.length)}",
                                                        style: TextStyle(fontFamily: AppConstant.fontRegular),
                                                      ),
                                                    ])*/
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Column(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          SubscriptionView(
                                                                    orderItems: snapshot
                                                                        .data!
                                                                        .data[
                                                                            idx]
                                                                        .orderHistory[
                                                                            index]
                                                                        .orderItems,
                                                                    orderType: snapshot
                                                                        .data!
                                                                        .data[
                                                                            idx]
                                                                        .orderHistory[
                                                                            index]
                                                                        .orderType,
                                                                    orderID: snapshot
                                                                        .data!
                                                                        .data[
                                                                            idx]
                                                                        .orderHistory[
                                                                            index]
                                                                        .orderNumber,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Card(
                                                              elevation: 10,
                                                              shadowColor:
                                                                  AppConstant
                                                                      .appColor,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                //set border radius more than 50% of height and width to make circle
                                                              ),
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 35,
                                                                width: 110,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  /*boxShadow: [
                                                              BoxShadow(
                                                          //color: Colors.grey,//AppConstant.appColor,
                                                                //color: Colors.black.withOpacity(0.5),
                                                                offset: Offset(0.5, 1.0),
                                                                //(x,y)
                                                                blurRadius: 1.0,
                                                              ),
                                                            ],*/
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  border: Border.all(
                                                                      color: AppConstant
                                                                          .appColor),
                                                                ),
                                                                child: Text(
                                                                  "VIEW",
                                                                  style: TextStyle(
                                                                      color: AppConstant
                                                                          .appColor,
                                                                      fontFamily:
                                                                          AppConstant
                                                                              .fontRegular,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 110,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {},
                                                              style: ButtonStyle(
                                                                  elevation: MaterialStateProperty.all(0),
                                                                  backgroundColor: MaterialStateProperty.all(snapshot.data!.data[idx].orderHistory[index].status == "Active"
                                                                      ? Colors.yellow
                                                                      : snapshot.data!.data[idx].orderHistory[index].status == "Rejected"
                                                                          ? Colors.red
                                                                          : snapshot.data!.data[idx].orderHistory[index].status == "Cancelled"
                                                                              ? Colors.red
                                                                              : snapshot.data!.data[idx].orderHistory[index].status == "Completed"
                                                                                  ? Colors.green
                                                                                  : snapshot.data!.data[idx].orderHistory[index].status == "Rejected"
                                                                                      ? AppConstant.appColor
                                                                                      : snapshot.data!.data[idx].orderHistory[index].status == "Pending"
                                                                                          ? Colors.yellow
                                                                                          : snapshot.data!.data[idx].orderHistory[index].status == "Refunded"
                                                                                              ? Colors.green
                                                                                              : Colors.blue)),
                                                              child: Text(
                                                                "${snapshot.data!.data[idx].orderHistory[index].status}",
                                                                style: TextStyle(
                                                                    color: snapshot.data!.data[idx].orderHistory[index].status == "Pending"
                                                                        ? Colors.black
                                                                        : snapshot.data!.data[idx].orderHistory[index].status == "Active"
                                                                            ? Colors.black
                                                                            : Colors.white,
                                                                    fontFamily: AppConstant.fontRegular),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      // for(int i=0;i<snapshot.data!.data[idx].orderHistory[index].orderItems.length;i++)
                                                      snapshot
                                                                  .data!
                                                                  .data[idx]
                                                                  .orderHistory[
                                                                      index]
                                                                  .orderType ==
                                                              "Order Now"
                                                          ? Row(
                                                              children: [
                                                                Text(
                                                                  "Items: ",
                                                                  // "${AppConstant.rupee} ${snapshot.data!.data[idx].orderHistory[idx].orderItems[index].itemPrice}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          AppConstant
                                                                              .fontBold),
                                                                ),
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  height: 16,
                                                                  //width: 110,
                                                                  // color: Colors.red,
                                                                  child: ListView
                                                                      .builder(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: snapshot
                                                                        .data!
                                                                        .data[
                                                                            idx]
                                                                        .orderHistory[
                                                                            index]
                                                                        .orderItems
                                                                        .length,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    itemBuilder:
                                                                        (context,
                                                                            i) {
                                                                      int j = 0;
                                                                      j = i + 1;
                                                                      return Text(
                                                                        '${j != snapshot.data!.data[idx].orderHistory[index].orderItems.length ? snapshot.data!.data[idx].orderHistory[index].orderItems[i].itemName.toString().replaceAll('[', ',').replaceAll(']', '') + ", " : snapshot.data!.data[idx].orderHistory[index].orderItems[i].itemName.toString().replaceAll('[', ',').replaceAll(']', '') + ""}',
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.visible,
                                                                        softWrap:
                                                                            false,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily: AppConstant.fontRegular),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Row(
                                                              children: [
                                                                Text(
                                                                  'Package: ',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        AppConstant
                                                                            .fontBold,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${snapshot.data!.data[idx].orderHistory[index].packageName}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          AppConstant
                                                                              .fontRegular),
                                                                ),
                                                              ],
                                                            ),
                                                      /*snapshot.data!.data[idx].orderHistory[index].orderType=="Order Now"
                                                        ?Container(
                                                      alignment: Alignment.topLeft,
                                                      height: 16,
                                                      //width: 110,
                                                      // color: Colors.red,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        scrollDirection: Axis.horizontal,
                                                        itemCount: snapshot.data!.data[idx].orderHistory[index].orderItems.length,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemBuilder: (context, i) {
                                                          return Text("${AppConstant.rupee} ${snapshot.data!.data[idx].orderHistory[idx].orderItems[i].itemPrice}",
                                                            style: TextStyle(fontFamily: AppConstant.fontRegular),
                                                          );
                                                        },),
                                                    )
                                                        :Text("Package",
                                                      //"${AppConstant.rupee} ${snapshot.data!.data[idx].orderHistory[index].packageName}",
                                                      style: TextStyle(fontFamily: AppConstant.fontRegular),
                                                    ),*/
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  Divider(
                                                    color: Colors.black,
                                                    thickness: 2,
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  )
                                                ]),
                                          );
                                        }),
                                  );
                                })
                          ]),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      alignment: Alignment.center,
                      child: Text(
                        "LOADING.......",
                        style: TextStyle(fontFamily: AppConstant.fontBold),
                      ),
                    );
            }),
      ),
    );
  }
}

class SubscriptionView extends StatefulWidget {
  final List<OrderItem> orderItems;
  final String orderType;
  final String orderID;

  SubscriptionView(
      {required this.orderItems,
      required this.orderType,
      Key? key,
      required this.orderID})
      : super(key: key);

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Order ID : ${widget.orderID}",
          style: TextStyle(fontFamily: AppConstant.fontRegular),
        ),
        backgroundColor: AppConstant.appColor,
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 100),
          itemCount: widget.orderItems.length,
          itemBuilder: (context, index) {
            int j = 0;
            j = index + 1;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${widget.orderItems[index].deliveryDate}",
                      style: TextStyle(fontFamily: AppConstant.fontRegular),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      "|",
                      style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 20,
                          fontFamily: AppConstant.fontBold),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      "${AppConstant.rupee} ${widget.orderItems[index].itemPrice}",
                      style: TextStyle(fontFamily: AppConstant.fontRegular),
                    ),
                  ],
                ),
                Text(
                  /*j!=widget.orderItems.length?widget.orderItems[index].itemName.replaceAll('[', '').replaceAll(']', '') + "":*/
                  widget.orderItems[index]
                      .itemName /*.replaceAll('[', '').replaceAll(']', '') + "+"*/,
                  style: TextStyle(
                      fontFamily: AppConstant.fontRegular, fontSize: 16),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Pick-up Time: ${widget.orderItems[index].pickupTime}",
                  style: TextStyle(
                      fontFamily: AppConstant.fontRegular, fontSize: 16),
                ),
                Row(
                  children: [
                    /*Text(
                        widget.orderItems[index].cuisine,
                        style: TextStyle(fontFamily: AppConstant.fontRegular),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        "|",
                        style: TextStyle(color: Colors.yellow, fontSize: 20, fontFamily: AppConstant.fontBold),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        widget.orderItems[index].deliveryDate,
                        style: TextStyle(fontFamily: AppConstant.fontRegular),
                      ),*/
                    Spacer(),
                    widget.orderType == "Order Now"
                        ? SizedBox()
                        : ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                widget.orderItems[index].status == "0"
                                    ? Color(0xFF6C757D)
                                    : widget.orderItems[index].status == "1"
                                        ? Color(0xFF007BFF)
                                        : widget.orderItems[index].status == "2"
                                            ? Color(0xFF007BFF)
                                            : widget.orderItems[index].status ==
                                                    "3"
                                                ? Color(0xFF28A745)
                                                : widget.orderItems[index]
                                                            .status ==
                                                        "4"
                                                    ? Color(0xFFDC3545)
                                                    : widget.orderItems[index]
                                                                .status ==
                                                            "5"
                                                        ? Color(0xFFFFC107)
                                                        : widget
                                                                    .orderItems[
                                                                        index]
                                                                    .status ==
                                                                "6"
                                                            ? Color(0xFF28A745)
                                                            : widget
                                                                        .orderItems[
                                                                            index]
                                                                        .status ==
                                                                    "7"
                                                                ? Color(
                                                                    0xFFDC3545)
                                                                : Color(
                                                                    0xFF28A745),
                              ),
                            ),
                            child: Text(
                              widget.orderItems[index].status == "0"
                                  ? "Ready To Pick"
                                  : widget.orderItems[index].status == "1"
                                      ? "Assign To Rider"
                                      : widget.orderItems[index].status == "2"
                                          ? "Start Delivery"
                                          : widget.orderItems[index].status ==
                                                  "3"
                                              ? "Delivered"
                                              : widget.orderItems[index]
                                                          .status ==
                                                      "4"
                                                  ? "Cancelled"
                                                  : widget.orderItems[index]
                                                              .status ==
                                                          "5"
                                                      ? "Pending"
                                                      : widget.orderItems[index]
                                                                  .status ==
                                                              "6"
                                                          ? "Approved"
                                                          : widget
                                                                      .orderItems[
                                                                          index]
                                                                      .status ==
                                                                  "7"
                                                              ? "Rejected"
                                                              : widget.orderItems[index]
                                                                          .status ==
                                                                      "8"
                                                                  ? "Postponed"
                                                                  : "Refunded",
                              style: TextStyle(
                                  fontFamily: AppConstant.fontRegular,
                                  color: widget.orderItems[index].status == "5"
                                      ? Colors.black
                                      : Colors.white),
                            ),
                          )
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Divider(
                  color: Colors.black,
                  thickness: 2,
                )
              ],
            );
          }),
    );
  }
}
