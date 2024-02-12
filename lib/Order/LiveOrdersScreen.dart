import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/model/BeanGetLiveOrders.dart';
import 'package:kitchen/model/BeanGetOrderDetails.dart';
import 'package:kitchen/model/BeanOrderCancel.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';

import '../model/BeanGetOrderRequest.dart';
import '../model/BeanOrderAccepted.dart';
import '../model/BeanOrderRejected.dart';
import '../model/KitchenData/BeanLogin.dart';

class LiveOrdersScreen extends StatefulWidget {
  final bool? fromDashboard;

  const LiveOrdersScreen({Key? key, this.fromDashboard = false})
      : super(key: key);

  @override
  _LiveOrdersScreenState createState() => _LiveOrdersScreenState();
}

enum BestTutorSite { too_busy, food_not_available, shop_closed, others }

class _LiveOrdersScreenState extends State<LiveOrdersScreen> {
  BeanLogin? userBean;
  BeanGetOrderRequest? requestView;
  bool loading = true;

  List<LiveOrder> data = [];
  List<Pagination> paginationData = [];
  int currentPage = 1;
  int maxPages = 1;
  var currentDate = "";
  var userId;
  var status = "";
  bool isLoading = true;
  bool isViewLoading = false;
  int paymentIndex = 0;
  int page = 1;
  var description_controller = TextEditingController();
  String _selectedText = "All";

  // declare object
  BestTutorSite _site = BestTutorSite.too_busy;
  final scrollController = ScrollController();

  void getUser() async {
    userBean = await Utils.getUser();
    userId = userBean!.data!.id.toString();
  }

  @override
  void initState() {
    getUser();
    // getCurrentDate();
    super.initState();
    scrollController.addListener(() async {
      int positionPercent = (scrollController.position.pixels *
              100 /
              scrollController.position.maxScrollExtent)
          .round();
      if (currentPage < maxPages && !isLoading && positionPercent == 100) {
        isLoading = true;
        await getLiveOrder(
            context,
            _selectedText == items[4]
                ? "ready_to_picked"
                : _selectedText == items[5]
                    ? "assign_to_rider"
                    : _selectedText == items[6]
                        ? "start_delivery"
                        : _selectedText.toLowerCase(),
            page: currentPage + 1);
      } else {
        // scrollController = null;
      }
    });
    Future.delayed(Duration.zero, () {
      getLiveOrder(
          context,
          _selectedText == items[4]
              ? "ready_to_picked"
              : _selectedText == items[5]
                  ? "assign_to_rider"
                  : _selectedText == items[6]
                      ? "start_delivery"
                      : _selectedText.toLowerCase());
    });
  }

  List<String> items = [
    'All',
    'Pending',
    'Approved',
    'Rejected',
    'Ready To picked',
    'Assign To Rider',
    'Start Delivery',
    'Delivered',
    'Cancelled',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.fromDashboard!)
          ? AppBar(
              backgroundColor: AppConstant.appColor,
              title: Text(
                "Live Orders",
                style: TextStyle(fontFamily: AppConstant.fontRegular),
              ),
            )
          : AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: 12.5,
              elevation: 0,
            ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    iconEnabledColor: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    elevation: 5,
                    style: TextStyle(
                        fontFamily: AppConstant.fontRegular,
                        fontSize: 20,
                        color: Colors.black),

                    // Initial Value
                    value: _selectedText,
                    items: [
                      'All',
                      'Pending',
                      'Approved',
                      'Rejected',
                      'Ready To picked',
                      'Assign To Rider',
                      'Start Delivery',
                      'Delivered',
                      'Cancelled',
                    ].map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedText = newValue!;
                        getLiveOrder(
                          context,
                          newValue.toLowerCase(),
                        );
                      });
                    },
                    /*uniqueList.map((country) {
                            return DropdownMenuItem(
                              child: Text(country),
                              value: country,
                            );
                          }).toList()*/
                  ),
                  Text(
                    'Total Orders : ${data.length}',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Container(
                    // height: 25,

                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Text(
                      'LIVE',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    'Today',
                    style: TextStyle(
                        fontSize: 15, fontFamily: AppConstant.fontRegular),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            SizedBox(
              height: 700,
              child: data.isEmpty
                  ? Text(
                      "NO Live Orders",
                      style: TextStyle(fontFamily: AppConstant.fontRegular),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 120),
                      itemCount: data.length + (currentPage < maxPages ? 1 : 0),
                      itemBuilder: (BuildContext context, int index) {
                        return liveOrdersListView(index);
                      }),
            )
          ],
        ),
      ),
    );
  }

  liveOrdersListView(int index) {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: Column(children: [
        Row(
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Text(
                        data[index].customerName.toString().trim(),
                        style: TextStyle(
                            fontFamily: AppConstant.fontBold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        data[index].orderType.toString() == "package"
                            ? "Subscription"
                            : "Order Now",
                        style: TextStyle(
                            fontFamily: AppConstant.fontBold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        "|",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: AppConstant.fontBold,
                            color: Colors.yellow),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        data[index].amount.toString(),
                        style: TextStyle(fontFamily: AppConstant.fontBold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        data[index].orderNumber.toString(),
                        style: TextStyle(fontFamily: AppConstant.fontBold),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "|",
                        style: TextStyle(
                            fontFamily: AppConstant.fontBold,
                            fontSize: 20,
                            color: Colors.yellow),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        data[index].orderDate.toString(),
                        style: TextStyle(fontFamily: AppConstant.fontBold),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                ]),
            SizedBox(
              width: 12,
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    //fixedSize: MaterialStateProperty.all(Size(20, 10)),
                    backgroundColor: MaterialStateProperty.all(data[index]
                                .orderStatus ==
                            "Pending"
                        ? Colors.yellow
                        : data[index].orderStatus == "Assigned to Rider"
                            ? Colors.black.withOpacity(0.5)
                            : data[index].status == "Ready to Picked"
                                ? Colors.grey.withOpacity(0.5)
                                : data[index].orderStatus == "Start Delivery"
                                    ? Colors.black.withOpacity(0.5)
                                    : data[index].orderStatus == "Cancelled"
                                        ? Colors.red
                                        : data[index].orderStatus == "Rejected"
                                            ? Colors.red
                                            : data[index].orderStatus ==
                                                    "Being Prepared"
                                                ? Colors.blue
                                                : Colors.green),
                  ),
                  child: Text(
                    data[index].orderStatus.toString(),
                    style: TextStyle(
                        fontFamily: AppConstant.fontRegular,
                        color: data[index].orderStatus == "Pending"
                            ? Colors.black
                            : Colors.white),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                ElevatedButton(
                  onPressed: ()async{
                    viewLiveOrders(
                        context, data[index].orderId, data[index].orderItemsId);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Text(
                    "View",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ],
        ),
        SizedBox(
          height: 4,
        ),
        Divider(
          color: Colors.black,
          thickness: 1,
        ),
        SizedBox(
          height: 4,
        ),
      ]),
    );
  }

  viewLiveOrders(
      BuildContext context, String orderId, String orderItemId) async {
    GetOrderDetailsData? orderDetails;
    orderDetails = await geteOrderDetails(context, orderId, orderItemId);
    orderDetails != null
        ? showDialog<void>(
            //barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  leading: BackButton(
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  elevation: 0,
                  backgroundColor: Colors.white,
                  title: Text(
                    "${orderDetails!.orderNumber} Details",
                    style: TextStyle(
                        fontFamily: AppConstant.fontRegular,
                        color: Colors.black),
                  ),
                ),
                backgroundColor: Colors.white,
                body: Column(
                  children: <Widget>[
                    Container(
                      //height: MediaQuery.of(context).size.height /
                      // (orderDetails!.itemsDetail!.length >= 3
                      //     ? (orderDetails.itemsDetail!.length >= 4
                      //         ? (orderDetails.itemsDetail!.length >= 5
                      //             ? 1.2
                      //             : 1.3)
                      //         : 1.5)
                      //     : (orderDetails.itemsDetail!.length == 2
                      //         ? 1.6
                      //         : 1.8)),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 20.0, right: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Order Number:",
                                    style: TextStyle(
                                      fontFamily: AppConstant.fontBold,
                                      color: Colors.blue,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${orderDetails.orderNumber}",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14,
                                    fontFamily: AppConstant.fontBold,
                                  ),
                                  maxLines: 1,
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Order Date:",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: AppConstant.fontBold),
                                  ),
                                ),
                                Text(
                                  "${orderDetails.orderDate}",
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontRegular),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Customer Name:",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: AppConstant.fontRegular),
                                  ),
                                ),
                                Text(
                                  "${orderDetails.customerName}",
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontRegular),
                                )
                              ],
                            ),
                            if (orderDetails.orderType != "package")
                              SizedBox(height: 8),
                            if (orderDetails.orderType != "package")
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Delivery Date: ",
                                    style: TextStyle(
                                        fontFamily: AppConstant.fontRegular,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red),
                                  ),
                                  Text(
                                    "${orderDetails.order_now_delivery_date["date"]}",
                                    style: TextStyle(
                                        fontFamily: AppConstant.fontRegular,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red),
                                    maxLines: 1,
                                  )
                                ],
                              ),
                            if (orderDetails.orderType == "package")
                              SizedBox(height: 8),
                            if (orderDetails.orderType == "package")
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Delivery From: ",
                                    style: TextStyle(
                                        fontFamily: AppConstant.fontRegular,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red),
                                  ),
                                  Text(
                                    "orderDetails.orderFrom",
                                    style: TextStyle(
                                        fontFamily: AppConstant.fontRegular,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red),
                                    maxLines: 1,
                                  )
                                ],
                              ),
                            SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(.25),
                                        blurRadius: 30),
                                  ],
                                  border: Border.all(
                                    color: Color.fromARGB(255, 208, 207, 206),
                                  ),
                                  color: Colors.white),
                              child: Column(
                                children: [
                                  ListView.builder(
                                    itemCount: orderDetails.itemsDetail?.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${orderDetails!.itemsDetail?[index].quantity} x ${orderDetails.itemsDetail?[index].itemName}",
                                            style: TextStyle(
                                                fontFamily:
                                                    AppConstant.fontRegular),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  // Text("Special Instructions : ${data.orderItems}"),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(.25),
                                        blurRadius: 30),
                                  ],
                                  border: Border.all(
                                    color: Color.fromARGB(255, 208, 207, 206),
                                  ),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Special Instructions : ${orderDetails.specialInstruction ?? "N/A"}",
                                    style: TextStyle(
                                        fontFamily: AppConstant.fontRegular),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Discount : ${orderDetails.discount}",
                                      maxLines: 1,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontRegular,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Packaging Charges : ${orderDetails.packagingCharge}",
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontBold,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Subscription : ${orderDetails.package}",
                                      maxLines: 1,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontRegular,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Total : ${orderDetails.total}",
                                      maxLines: 1,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontRegular,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(.25),
                                        blurRadius: 30),
                                  ],
                                  border: Border.all(
                                    color: Color.fromARGB(255, 208, 207, 206),
                                  ),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Order Status Update",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: AppConstant.fontRegular,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  orderDetails.status == '1' &&
                                              orderDetails.orderType ==
                                                  "package" ||
                                          orderDetails.status == "0" &&
                                              orderDetails.orderType == "trial"
                                      ? Container(
                                          height: 100,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  orderRejected(
                                                      orderDetails!.orderType ==
                                                              "trial"
                                                          ? orderDetails.orderId
                                                          : orderDetails
                                                              .orderItemId,
                                                      orderDetails.orderType ==
                                                              "package"
                                                          ? "old"
                                                          : "new");
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 110,
                                                  margin: EdgeInsets.only(
                                                      left: 10, bottom: 10),
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 242, 106, 96),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "REJECT",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              AppConstant
                                                                  .fontBold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  userBean!.data!
                                                              .availableStatus ==
                                                          '0'
                                                      ? "You cant accept orders in inactive mode"
                                                      : orderAccepted(
                                                          orderDetails!
                                                                      .orderType ==
                                                                  "trial"
                                                              ? orderDetails
                                                                  .orderId
                                                              : orderDetails
                                                                  .orderItemId,
                                                          orderDetails.orderType ==
                                                                  "package"
                                                              ? "old"
                                                              : "new");
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 10, bottom: 10),
                                                  height: 40,
                                                  width: 110,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 118, 214, 121),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "ACCEPT",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontFamily:
                                                              AppConstant
                                                                  .fontBold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          width: 200,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              orderDetails.orderType == "trial"
                                                  ? Text(
                                                      orderDetails.status == "1"
                                                          ? "Being Prepared"
                                                          : orderDetails
                                                                      .status ==
                                                                  "2"
                                                              ? "Rejected"
                                                              : orderDetails
                                                                          .status ==
                                                                      "3"
                                                                  ? "Ready to Picked"
                                                                  : orderDetails
                                                                              .status ==
                                                                          "4"
                                                                      ? "Assigned to Rider"
                                                                      : orderDetails.status ==
                                                                              "5"
                                                                          ? "Start Delivery"
                                                                          : orderDetails.status == "6"
                                                                              ? "Delivered"
                                                                              : orderDetails.status == "7"
                                                                                  ? "Cancelled"
                                                                                  : "",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              AppConstant
                                                                  .fontRegular,
                                                          color: Colors.white),
                                                    )
                                                  : Text(
                                                      orderDetails.status == "6"
                                                          ? "Being Prepared"
                                                          : orderDetails
                                                                      .status ==
                                                                  "7"
                                                              ? "Rejected"
                                                              : orderDetails
                                                                          .status ==
                                                                      "0"
                                                                  ? "Ready to Picked"
                                                                  : orderDetails
                                                                              .status ==
                                                                          "1"
                                                                      ? "Assigned to Rider"
                                                                      : orderDetails.status ==
                                                                              "2"
                                                                          ? "Start Delivery"
                                                                          : orderDetails.status == "3"
                                                                              ? "Delivered"
                                                                              : orderDetails.status == "4"
                                                                                  ? "Cancelled"
                                                                                  : "",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontFamily:
                                                              AppConstant
                                                                  .fontBold),
                                                    ),
                                              // (data.orderStatus == 'Order in Preparation') ?
                                              Icon(Icons.check,
                                                  color: Colors.white)
                                              //  : Container(),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) =>
                                          CupertinoAlertDialog(
                                        content: Text(
                                            "Are you sure you want to cancel this order ?"),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            isDefaultAction: true,
                                            child: Text('YES'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              // Navigator.pop(context);
                                              showInformationDialog(
                                                  context, orderDetails!);
                                              // Navigator.pushAndRemoveUntil(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             ActiveScreen()),
                                              //     (route) => false);
                                            },
                                          ),
                                          CupertinoDialogAction(
                                            child: Text("NO"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              //Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ),
                                    );

                                    //orderCancel(data.orderId, data.orderType);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(15.0),
                                    padding: const EdgeInsets.all(7.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppConstant.appColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      ' Cancel Order  ',
                                      style: TextStyle(
                                          color: AppConstant.appColor),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(15.0),
                                    padding: const EdgeInsets.all(7.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppConstant.appColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      ' Back  ',
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontRegular,
                                          color: AppConstant.appColor),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        : Container();
  }

  Future<BeanOrderAccepted?> orderAccepted(
      String orderId, String subscriptionType) async {
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        "token": "123456789",
        "order_id": orderId,
        "subscription_type": subscriptionType
        //subscription new and trial comes under new else old
        //order_id for trial
        //orderItem id for subscription
      });

      BeanOrderAccepted? bean =
          await ApiProvider().orderAccept(orderId, subscriptionType);

      if (bean.status == true) {
        getOrderRequest(context).then((value) {
          setState(() {
            requestView = value;
          });
        });
        Navigator.of(context, rootNavigator: true).pop();
        return bean;
      } else {
        Utils.showToast(bean.message ?? "", context);
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<BeanGetOrderRequest?> getOrderRequest(BuildContext context) async {
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        "token": "123456789",
      });
      BeanGetOrderRequest? bean = await ApiProvider().getOrderRequest();

      if (bean!.status == true) {
        setState(() {});

        return bean;
      } else {
        Utils.showToast(bean.message.toString(), context);
        return bean;
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<BeanOrderRejected?> orderRejected(
      String orderId, String subscriptionType) async {
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        "token": "123456789",
        "order_id": orderId,
        "subscription_type": subscriptionType == "trial" ? "new" : "old"
      });
      BeanOrderRejected? bean = await ApiProvider()
          .orderReject(orderId, subscriptionType == "trial" ? "new" : "old");

      if (bean.status == true) {
        getOrderRequest(context).then((value) {
          setState(() {
            requestView = value;
          });
        });
        return bean;
      } else {
        Utils.showToast(bean.message ?? "", context);
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<BeanGetLiveOrders?> getLiveOrder(
      BuildContext context, String orderStatus,
      {int page = 1}) async {
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId.toString(),
        "token": "123456789",
        "page_no": page,
        "order_status": _selectedText == items[4]
            ? "ready_to_picked"
            : _selectedText == items[5]
                ? "assign_to_rider"
                : _selectedText == items[6]
                    ? "start_delivery"
                    : _selectedText.toLowerCase()
        // "filter_fromdate": '2021-10-8',
        // "filter_todate": "",
        // "filter_order_number": ""
      });

      BeanGetLiveOrders? bean = await ApiProvider().getLiveOrder(
          "1",
          _selectedText == items[4]
              ? "ready_to_picked"
              : _selectedText == items[5]
                  ? "assign_to_rider"
                  : _selectedText == items[6]
                      ? "start_delivery"
                      : _selectedText.toLowerCase());

      if (bean.status == true) {
        setState(() {
          maxPages = bean.data.pagination.totalPage;
          currentPage = int.parse(bean.data.pagination.currentPage);
          data.addAll(bean.data.liveOrders);
        });

        return bean;
      } else {
        Utils.showToast(bean.message, context);
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {}
    return null;
  }

  Future<void> showInformationDialog(
      BuildContext context, GetOrderDetailsData orderDetails) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Container(
                height: MediaQuery.of(context).size.height / 2.4,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListTile(
                        title: GestureDetector(
                          onTap: () {
                            setState(() {
                              _site = BestTutorSite.too_busy;
                            });
                          },
                          child: Text('Too Busy'),
                        ),
                        leading: Radio(
                          value: BestTutorSite.too_busy,
                          groupValue: _site,
                          onChanged: (BestTutorSite? value) {
                            setState(() {
                              _site = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: GestureDetector(
                          onTap: () {
                            setState(() {
                              _site = BestTutorSite.food_not_available;
                            });
                          },
                          child: Text('Food Not Available'),
                        ),
                        leading: Radio(
                          value: BestTutorSite.food_not_available,
                          groupValue: _site,
                          onChanged: (BestTutorSite? value) {
                            setState(() {
                              _site = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: GestureDetector(
                          onTap: () {
                            setState(() {
                              _site = BestTutorSite.shop_closed;
                            });
                          },
                          child: Text('Shop Closed'),
                        ),
                        leading: Radio(
                          value: BestTutorSite.shop_closed,
                          groupValue: _site,
                          onChanged: (BestTutorSite? value) {
                            setState(() {
                              _site = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: GestureDetector(
                          onTap: () {
                            setState(() {
                              _site = BestTutorSite.others;
                            });
                          },
                          child: Text('Others'),
                        ),
                        leading: Radio(
                          value: BestTutorSite.others,
                          groupValue: _site,
                          onChanged: (BestTutorSite? value) {
                            setState(() {
                              _site = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xffd3dde4), width: 3),
                            ),
                            labelText: "Reason",
                            labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontFamily: AppConstant.fontRegular),
                          ),
                          controller: description_controller,
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          style: TextStyle(
                              fontFamily: AppConstant.fontRegular,
                              fontSize: 14,
                              color: Colors.black),
                          //decoration: InputDecoration.collapsed(
                          //hintText: number == "" ? "Number" : number,
                          //),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(
                'Reason for Cancellation',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        orderCancel(
                                (orderDetails.orderType == "trial"
                                    ? orderDetails.orderId
                                    : orderDetails.orderItemId),
                                orderDetails.orderType)
                            .then((value) {
                          Navigator.pop(context, true);
                          Navigator.pop(context, true);
                        });
                        //   .then((value) {
                        // if (value.status) {
                        //   getActiveOrder(context);
                        // }
                        // });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppConstant.appColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ' Cancel Order  ',
                          style: TextStyle(color: AppConstant.appColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppConstant.appColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ' Back  ',
                          style: TextStyle(color: AppConstant.appColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
        });
  }

  Future<BeanOrderCancel?> orderCancel(String orderId, String orderType) async {
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        "token": "123456789",
        "order_id": orderId,
        "ordertype": orderType,
        "cancellation_type": _site.name,
        "reason_for_cancellation": description_controller.text
      });
      BeanOrderCancel? bean = await ApiProvider().cancelOrder(
          orderId, orderType, _site.name, description_controller.text);

      if (bean.status == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LiveOrdersScreen(),
          ),
        );
        return bean;
      } else {
        Utils.showToast(bean.message ?? "", context);
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<GetOrderDetailsData?> geteOrderDetails(
      BuildContext context, String orderId, String orderItemId) async {
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId.toString(),
        "token": "123456789",
        "order_id": orderId,
        "order_item_id": orderItemId,
      });
      GetOrderDetailsData? bean = await ApiProvider()
          .getOrderDetails(orderId: orderId, orderItemId: orderItemId);
      return bean;
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {}
    return null;
  }
}
