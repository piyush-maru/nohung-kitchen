import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kitchen/model/BeanGetOrderDetails.dart';
import 'package:kitchen/model/BeanOrderCancel.dart';
import 'package:kitchen/model/GetUpComingOrder.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/network/OrderRepo/order_request_model.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/src/presentation/screens/DashboardScreen.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:provider/provider.dart';

import '../model/KitchenData/BeanLogin.dart';
import '../utils/Utils.dart';

class UpcomingScreen extends StatefulWidget {
  final bool? fromDashboard;

  const UpcomingScreen({Key? key, this.fromDashboard = false})
      : super(key: key);

  @override
  _UpcomingScreenState createState() => _UpcomingScreenState();
}

enum BestTutorSite { too_busy, food_not_available, shop_closed, others }

class _UpcomingScreenState extends State<UpcomingScreen> {
  BeanLogin? userBean;
  Future? future;
  bool loading = true;
  List<GetUpComingOrderData> data = [];
  List<UpcomingData> upcomingdata = [];
  var currentDate = "";
  var userId = "";
  Timer? timer;
  bool isShow = false;

  var descriptionController = TextEditingController();

  // declare object
  BestTutorSite _site = BestTutorSite.too_busy;

  void getUser() async {
    userBean = await Utils.getUser();
    userId = userBean!.data!.id.toString();

    setState(() {});
  }

  @override
  void initState() {
    getUser();
    getCurrentDate();
    super.initState();
    Future.delayed(Duration.zero, () {
      future = getUpComingOrder(context).then((value) {
        setState(() {
          loading = false;
        });
      });
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

  Future<void> _pullRefresh() async {
    Future.delayed(Duration.zero, () {
      future = getUpComingOrder(context).then((value) {
        setState(() {
          loading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (widget.fromDashboard!)
            ? AppBar(
                backgroundColor: AppConstant.appColor,
                title: Text(
                  "Upcoming Orders",
                  style: TextStyle(fontFamily: AppConstant.fontRegular),
                ),
              )
            : null,
        backgroundColor: Colors.white,
        body: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: (loading)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : (upcomingdata.isEmpty)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          SvgPicture.asset("assets/images/no_orders.svg"),
                          SizedBox(
                            height: 12,
                          ),
                          Center(
                            child: Text(
                              'No Upcoming Orders',
                              style: TextStyle(
                                  fontFamily: AppConstant.fontBold,
                                  fontSize: 18),
                            ),
                          )
                        ],
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(bottom: 72),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemCount: upcomingdata.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 10),
                                  child: Text(
                                    "${upcomingdata[index].deliveryDate} (${upcomingdata[index].data!.length})" ??
                                        "",
                                    style: TextStyle(
                                        color: Color(0xffFFA451),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                itemCount: upcomingdata[index].data!.length,
                                itemBuilder: (context, index1) {
                                  return Column(
                                    children: [
                                      getOrderList(upcomingdata[index].data![index1]),
                                      (index1 + 1 == upcomingdata[index].data!.length)
                                          ? SizedBox(
                                              height: 10,
                                            )
                                          : SizedBox()
                                    ],
                                  );
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 4,
                                  decoration: BoxDecoration(
                                      color:
                                          Colors.blue, //AppConstant.appColor,
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                              ),
                              SizedBox(height: 2),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 4,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                              ),
                            ],
                          );
                        },
                      )));
  }

  Widget getOrderList(GetUpComingOrderData data) {
    return InkWell(
      onTap: () {
        showAlertDialog(context, data, data.time.toString());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: data.menuFor == "Breakfast"
                  ? Color(0xFFFFFBD6)
                  : data.menuFor == "Lunch"
                      ? Color(0xFFE4FCFF)
                      : Color(0xFFDBFFE3),
            ),
          ],
          // border:
          //     Border.all(color: Color.fromARGB(255, 208, 207, 206)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      data.customerImage == ''
                          ? Image.asset(
                              Res.ic_people,
                              width: 50,
                              height: 50,
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              child: CircleAvatar(
                                radius: 45,
                                backgroundImage: NetworkImage(
                                  '${data.customerImage ?? ''}',
                                ),
                              ),
                            ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 12, right: 0),
                          height: 55,
                          //color: Colors.green,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${data.customerName} ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: AppConstant.fontBold),
                                      ),
                                      Text(
                                        "${data.orderNumber} ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: AppConstant.fontRegular),
                                      ),
                                      Text(
                                        "${data.orderDate.toString()}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                 /* SizedBox(
                                    width: 24,
                                  ),*/
                                  Text(
                                    "${data.menuFor}",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontFamily: AppConstant.fontBold),
                                  ),
                                 /* Align(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${data.menuFor}",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                                fontFamily: AppConstant.fontBold),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          *//*Text(
                                              "Time ${data.time}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      AppConstant.fontRegular),
                                            ),*//*
                                        ],
                                      )),*/
                                ],
                              ),

                              // Text(
                              //   "Customized ",
                              //   style: TextStyle(
                              //       color: AppConstant.appColor,
                              //       fontSize: 14,
                              //       fontFamily: AppConstant.fontBold),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(
                        Res.ic_breakfast,
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            "${data.orderItems} ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: AppConstant.fontBold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pick up Time : ${data.time}",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          showAlertDialog(context, data, data.time.toString());
                        },
                        child: Card(
                          elevation: 10,
                          shadowColor: AppConstant.appColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                            //set border radius more than 50% of height and width to make circle
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            height: 35,
                            width: 110,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppConstant.appColor),
                            ),
                            child: Text(
                              "View Order",
                              style: TextStyle(
                                  color: AppConstant.appColor,
                                  fontFamily: AppConstant.fontRegular,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      /* GestureDetector(
                        onTap: () {
                          showAlertDialog(context, data);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppConstant.appColor),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            ' View Order  ',
                            style: TextStyle(color: AppConstant.appColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),*/
                    ],
                  ),
                  data.specialInstruction==""?SizedBox():
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Instruction : ",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        //color: Colors.black,
                        width: 230,
                        child: Text(
                          "${data!.specialInstruction}",
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //Divider(color: Colors.grey.withOpacity(0.5), thickness: 5)
          ],
        ),
      ),
    );
  }

  Future<GetUpComingOrder?> getUpComingOrder(BuildContext context) async {
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId.toString(),
        "token": "123456789",
        "filter_fromdate": '',
        "filter_todate": "",
        "filter_order_number": ""
      });

      GetUpComingOrder? bean = await ApiProvider().getUpComingOrder();

      if (bean.status == true) {
        upcomingdata = bean.updata!;
        data = bean.updata![0].data!;
        setState(() {});

        return bean;
      } else {
        throw Exception("Something went wrong");
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {}
    return null;
  }

  void getCurrentDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    currentDate = formatter.format(now);
  }

  showAlertDialog(BuildContext context, GetUpComingOrderData data,
      String pickupTime) async {
    print("=======================+>${data.orderId!}");
    print("=======================+>${data.orderItemId!}");
    GetOrderDetailsData? orderDetails;
    orderDetails = await geteOrderDetails(context, data.orderId!, data.orderItemId!);
    orderDetails != null
        ? showDialog<void>(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setStat) {
                return Scaffold(
                    body: Container(
                      padding: EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.cancel),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Order Number:",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontFamily: AppConstant.fontRegular,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${orderDetails!.orderNumber}",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontFamily: AppConstant.fontRegular,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Order Date:",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: AppConstant.fontRegular),
                                ),
                                Text(
                                  "${orderDetails.orderDate}",
                                  style:
                                  TextStyle(fontFamily: AppConstant.fontRegular),
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
                                    "Customer Name:",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: AppConstant.fontRegular),
                                  ),
                                ),
                                Text(
                                  "${data.customerName}",
                                  style:
                                  TextStyle(fontFamily: AppConstant.fontRegular),
                                  maxLines: 1,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
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
                                  data.delivery_date?.toString() ?? "",
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontRegular,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red),
                                  maxLines: 1,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Pickup Time: ",
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontRegular,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red),
                                ),
                                Text(
                                  "$pickupTime",
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontRegular,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red),
                                  maxLines: 1,
                                )
                              ],
                            ),
                            SizedBox(
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
                                      color: Color.fromARGB(255, 208, 207, 206)),
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
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${orderDetails!.itemsDetail?[index].quantity} x ${orderDetails.itemsDetail?[index].itemName}",
                                            style: TextStyle(
                                                fontFamily: AppConstant.fontRegular),
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
                                      color: Color.fromARGB(255, 208, 207, 206)),
                                  color: Colors.white),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Special Instructions : ",),
                                  Container(
                                    //color: Colors.blue,
                                    width: 130,
                                    child: Text(
                                      "${orderDetails.specialInstruction ?? "N/A"}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.red),),
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
                                      "Subscription : ${orderDetails.package}",
                                      maxLines: 1,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontBold,
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
                                    Visibility(
                                      visible: isShow?false:true,
                                      child: SizedBox(
                                        height: 10,
                                      ),
                                    ),
                                    Visibility(
                                      visible:orderDetails.amount=="0.00" ?false:true,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                isShow = !isShow;
                                                setStat(() {});
                                              },
                                              child:Row(
                                                children: [
                                                  Visibility(
                                                    visible: isShow==true?true:false,
                                                    child: Container(
                                                      //width: MediaQuery.of(context).size.width,
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 8, vertical: 8),
                                                      margin: const EdgeInsets.symmetric(
                                                          horizontal: 8, vertical: 8),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey,
                                                              blurRadius: 6,
                                                              offset: Offset(
                                                                  4, 4),
                                                            ),
                                                          ],
                                                          border: Border.all(
                                                              color: Colors.red),
                                                          color: Colors.white),
                                                      child: Text(
                                                        "Reason: ${orderDetails. reason}",
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle( color: Colors.red,
                                                            fontFamily: AppConstant.fontRegular,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                  SvgPicture.asset("assets/images/quatin_mark.svg"),
                                                  Text(
                                                    "  ${orderDetails.category} : ${orderDetails.amount}",//Addition
                                                    maxLines: 1,
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        fontFamily: AppConstant.fontRegular,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),),
                                            Visibility(
                                              visible: isShow?false:true,
                                              child: SizedBox(
                                                height: 10,
                                              ),
                                            ),
                                            Text(
                                              "Net Amount : ${orderDetails.netAmount}",
                                              maxLines: 1,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontFamily: AppConstant.fontRegular,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /*GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) =>
                                            CupertinoAlertDialog(
                                          content: Text(
                                              "Are you sure you want to cancel this order ?",style: TextStyle(fontFamily: AppConstant.fontRegular),),

                                          actions: <Widget>[

                                            CupertinoDialogAction(
                                              //isDefaultAction: true,
                                              child: Text('YES',style: TextStyle(fontFamily: AppConstant.fontRegular),),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                // Navigator.pop(context);
                                                showInformationDialog(context,
                                                    data, orderDetails!);
                                                // Navigator.pushAndRemoveUntil(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             ActiveScreen()),
                                                //     (route) => false);
                                              },
                                            ),
                                            CupertinoDialogAction(
                                              child: Text("NO",style:TextStyle(fontFamily: AppConstant.fontRegular),),
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
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        ' Cancel Order  ',
                                        style: TextStyle(
                                          fontFamily: AppConstant.fontRegular,
                                            color: AppConstant.appColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                  ),*/
                                InkWell(
                                  onTap: () {
                                    /*showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) =>
                                            CupertinoAlertDialog(
                                              content: Text(
                                                "Are you sure you want to cancel this order ?",style: TextStyle(fontFamily: AppConstant.fontRegular),),

                                              actions: <Widget>[

                                                CupertinoDialogAction(
                                                  //isDefaultAction: true,
                                                  child: Text('YES',style: TextStyle(fontFamily: AppConstant.fontRegular),),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    // Navigator.pop(context);
                                                    cancelDialog(context,data, orderDetails!);
                                                    */ /*showInformationDialog(context,
                                                        data, orderDetails!);*/ /*
                                                    // Navigator.pushAndRemoveUntil(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             ActiveScreen()),
                                                    //     (route) => false);
                                                  },
                                                ),
                                                CupertinoDialogAction(
                                                  child: Text("NO",style:TextStyle(fontFamily: AppConstant.fontRegular),),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    //Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            ),
                                      );*/
                                    Navigator.of(context).pop();
                                    // Navigator.pop(context);
                                    cancelDialog(context, data, orderDetails!);
                                  },
                                  child: Card(
                                    elevation: 10,
                                    shadowColor: AppConstant.appColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      //set border radius more than 50% of height and width to make circle
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border:
                                        Border.all(color: AppConstant.appColor),
                                      ),
                                      child: Text(
                                        "Cancel Order",
                                        style: TextStyle(
                                            color: AppConstant.appColor,
                                            fontFamily: AppConstant.fontRegular,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Card(
                                    elevation: 10,
                                    shadowColor: AppConstant.appColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      //set border radius more than 50% of height and width to make circle
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: 110,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border:
                                        Border.all(color: AppConstant.appColor),
                                      ),
                                      child: Text(
                                        " Back ",
                                        style: TextStyle(
                                            color: AppConstant.appColor,
                                            fontFamily: AppConstant.fontRegular,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                /*GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(15.0),
                                      padding: const EdgeInsets.all(7.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppConstant.appColor),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Text(
                                        ' Back  ',
                                        style: TextStyle(
                                          fontFamily: AppConstant.fontRegular,
                                            color: AppConstant.appColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),*/
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ));
              },);
            },
          )
        : Container();
  }

  cancelDialog(BuildContext context, data, orderDetails) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Container(
            //height: 200,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //color:Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Image.asset(
                        Res.ic_cross_image,
                        fit: BoxFit.fill,
                        width: 12,
                        height: 12,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Image.asset(
                Res.ic_cancel_image,
                fit: BoxFit.fill,
                //width: 16,
                height: 170,
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                " Are you sure you want to \ncancel this order?",
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontFamily: AppConstant.fontBold, fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          'NO',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: AppConstant.fontRegular),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      showInformationDialog(context, data, orderDetails!);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppConstant.appColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          'YES',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: AppConstant.fontRegular),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
            ]),
          ),
        );
      },
    );
  }

  Future<void> showInformationDialog(BuildContext context,
      GetUpComingOrderData data, GetOrderDetailsData orderDetails) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Container(
                height: MediaQuery.of(context).size.height / 2.0,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.asset(
                        Res.ic_cancellatin_image,
                        fit: BoxFit.fill,
                        //width: 16,
                        height: 125,
                      ),
                    ),
                    // SizedBox(height: 24,),
                    Expanded(
                      child: ListTile(
                        title: GestureDetector(
                          onTap: () {
                            setState(() {
                              _site = BestTutorSite.too_busy;
                            });
                          },
                          child: Text(
                            'Too Busy',
                            style:
                                TextStyle(fontFamily: AppConstant.fontRegular),
                          ),
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
                          child: Text(
                            'Food Not Available',
                            style:
                                TextStyle(fontFamily: AppConstant.fontRegular),
                          ),
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
                          child: Text(
                            'Shop Closed',
                            style:
                                TextStyle(fontFamily: AppConstant.fontRegular),
                          ),
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
                          child: Text(
                            'Others',
                            style:
                                TextStyle(fontFamily: AppConstant.fontRegular),
                          ),
                        ),
                        leading: Radio(
                          value: BestTutorSite.others,
                          groupValue: _site,
                          onChanged: (BestTutorSite? value) {
                            setState(() {
                              _site = value!;
                              print("value$value");
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: TextField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(5.0),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.grey /*(0xffd3dde4)*/,
                                    width: 3)),
                            labelText: "Reason",
                            labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontFamily: "CentraleSansRegular")),
                        controller: descriptionController,
                        keyboardType: TextInputType.text,
                        maxLines: 4,
                        style: TextStyle(
                            fontFamily: AppConstant.fontRegular,
                            fontSize: 14,
                            color: Colors.black),
                        //decoration: InputDecoration.collapsed(
                        //hintText: number == "" ? "Number" : number,
                        //),
                      ),
                    ),
                  ],
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reason for Cancellation',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //color:Colors.red,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset(
                          Res.ic_cross_image,
                          fit: BoxFit.fill,
                          width: 12,
                          height: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          print(_site.name);
                          Navigator.pop(context, true);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 35,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black,
                          ),
                          child: Text(
                            " Back ",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: AppConstant.fontRegular,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _site.name == "others" &&
                                  descriptionController.text.isEmpty
                              ? cancelReason()
                              : orderCancel(
                                      (data.orderType == "trial"
                                          ? orderDetails.orderId
                                          : orderDetails.orderItemId),
                                      data.orderType!)
                                  .then((value) {
                                  Navigator.pop(context, true);
                                  //Navigator.pop(context, true);
                                });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 35,
                          width: 110,
                          /*decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppConstant.appColor),
                          ),*/
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppConstant.appColor,
                          ),
                          child: Text(
                            " Cancel Order ",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: AppConstant.fontRegular,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      /*GestureDetector(
                        onTap: () {
                          Navigator.pop(context, true);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppConstant.appColor),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            ' Back  ',
                            style: TextStyle(color: AppConstant.appColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ],
            );
          });
        });
  }

  Future cancelReason() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return GestureDetector(
            child: Dialog(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(12),
                height: 50,
                child: Text(
                  "Please Enter Reason For Cancel",
                  style:
                      TextStyle(fontSize: 20, fontFamily: AppConstant.fontBold),
                ),
              ),
            ),
          );
        });
  }

  Future<BeanOrderCancel> orderCancel(String orderId, String orderType) async {
    FormData from = FormData.fromMap({
      "kitchen_id": userId,
      "token": "123456789",
      "order_id": orderId,
      "ordertype": orderType,
      "cancellation_type": _site.name,
      "reason_for_cancellation": descriptionController.text
    });
    BeanOrderCancel? bean = await ApiProvider().cancelOrder(
        orderId, orderType, _site.name, descriptionController.text);

    if (bean.status == true) {
      getUpComingOrder(context).then((value) {
        setState(() {
          upcomingdata = value!.updata!;
          data = value.updata![0].data!;
        });
      });
      return bean;
    } else {
      throw Exception("Something went wrong");
    }
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
