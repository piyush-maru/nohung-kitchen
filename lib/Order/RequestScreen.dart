import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kitchen/Order/OrderScreen.dart';
import 'package:kitchen/model/BeanGetOrderRequest.dart';
import 'package:kitchen/model/BeanOrderAccepted.dart';
import 'package:kitchen/model/BeanOrderRejected.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/network/OrderRepo/order_request_model.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../model/BeanGetOrderDetails.dart';
import '../model/KitchenData/BeanLogin.dart';

class RequestScreen extends StatefulWidget {
  final bool? fromDashboard;

  //final bool currentTablSelected;

  const RequestScreen({
    Key? key,
    this.fromDashboard = false,
    /*required this.currentTablSelected*/
  }) : super(key: key);

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen>
    with WidgetsBindingObserver {
  bool loading = true;

  BeanLogin? userBean;
  var userId;
  var currentDate = "";
  BeanGetOrderRequest? requestView;

  //BestTutorSite _site = BestTutorSite.too_busy;
  List<BeanGetOrderRequest> data = [];
  bool isViewLoading = false;
  bool isShow=false;
  Timer? timer;
  bool? kitchenStatus = true;
  AnimationController? animationController;
  int difference = 0;
  bool isBackground = false;
  final player = AudioPlayer();

  Future getUser() async {
    kitchenStatus = await getKitchenStatus();
    var userBean1 = await Utils.getUser();
    setState(() {
      userBean = userBean1;
      userId = userBean1.data!.id.toString();
      kitchenStatus = kitchenStatus;
    });
  }

  //bool loading = true;
  //
  // bool isViewLoading = false;
  bool isLodingDesable = false;
  Future<BeanGetOrderRequest>? future;
  var active;

  @override
  void initState() {
    isLodingDesable = false;
    getOrderRequest(context);
    final orderRequest = Provider.of<OrderRequestModel>(context, listen: false);
    setState(() {
      orderRequest.orderRequest();
      future = orderRequest.orderRequest();
    });

    super.initState();

    WidgetsBinding.instance.addObserver(this);
    if (WidgetsBinding.instance.lifecycleState != null) {}

    // OLD
    const twentyMillis = Duration(seconds: 20);
    timer = Timer.periodic(twentyMillis, (timer) {
      if (kitchenStatus == true || kitchenStatus == null) {
        orderRequest.orderRequest();
        //getOrderRequest(context);
        // _future = getOrders(context);
      }
    });

    timer = Timer.periodic(Duration(seconds: 05), (Timer t) {
      setState(() {
        isLodingDesable = true;
        getOrderRequest(context);
        final orderRequest =
            Provider.of<OrderRequestModel>(context, listen: false);
        orderRequest.orderRequest();
        future = orderRequest.orderRequest();
        WidgetsBinding.instance.addObserver(this);
        if (WidgetsBinding.instance.lifecycleState != null) {}
      });

      //setState(() {});
    });
  }

  Future<void> _pullRefresh() async {
    final orderRequest = Provider.of<OrderRequestModel>(context, listen: false);

    setState(() {
      orderRequest.orderRequest();
    });
  }

  @override
  void dispose() {
    //animationController!.dispose();
    timer!.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      setState(() {
        isBackground = true;
      });
      // player.pause();
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        isBackground = false;
      });
    } else if (AppLifecycleState.paused == state) {
      setState(() {
        isBackground = true;
      });
      // player.pause();
    }
  }

  Future<BeanGetOrderRequest?> getOrderRequest(BuildContext context) async {
    int? lenght = await getOrdersRequestCount();

    var userBean = await Utils.getUser();
    FormData from = FormData.fromMap({
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
    });

    BeanGetOrderRequest bean = await ApiProvider().getOrderRequest();

    if (bean.data!.length > (lenght ?? 0)) {
      setState(() {
        //isLodingDesable==true?loading = false:loading = true;
      });
    }

    if (bean.status == true) {
      if (!isBackground) {
        saveOrdersRequestCount(bean.data!.length);
      }
      Future.delayed(const Duration(milliseconds: 10), () {
        loading = false;
        difference = bean.data!.length - (lenght ?? 0);
      });

      if (bean.data!.length > (lenght ?? 0)) {
        if (isBackground) {
          PerfectVolumeControl.setVolume(1);
          if (bean.data!.first.subscriptionType == "new") {
            player.play(AssetSource('notification_sound_old.mp3'));
          } else {
            player.play(AssetSource('notification_sound.mp3'));
          }
        }
      }

      if (bean.data!.length > (lenght ?? 0)) {
        if (!isBackground) {
          //==false
          // PerfectVolumeControl.setVolume(1);
          if (bean.data!.first.subscriptionType == "new") {
            // player.play(AssetSource('notification_sound_old.mp3'));
            //  AudioPlayer().play(AssetSource('notification_sound.mp3'));
          } else {
            // AudioPlayer().play(AssetSource('notification_sound.mp3'));
          }
        }
      }

      return bean;
    } else {
      setState(() {
        // isLodingDesable==true?loading = false:loading = true;
        loading = false;
      });
      saveOrdersRequestCount(bean.data!.length);
      return bean;
    }
  }

//++++++++++++++++++++++++++++++old+++++++++++++++++++++++++++++++++++++++++++++
  Future<void> getUserData() async {
    kitchenStatus = await getKitchenStatus();
    var userBean = await Utils.getUser();
    setState(() {
      userBean = userBean;
      kitchenStatus = kitchenStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderRequest = Provider.of<OrderRequestModel>(context, listen: false);
    return Scaffold(
      appBar: (widget.fromDashboard!)
          ? AppBar(
              backgroundColor: AppConstant.appColor,
              title: Text(
                "Order Requests",
                style: TextStyle(fontFamily: AppConstant.fontRegular),
              ),
            )
          : AppBar(
              toolbarHeight: 0.0,
              backgroundColor: Colors.white,
            ),
      backgroundColor: Colors.white,
      body: new RefreshIndicator(
        onRefresh: _pullRefresh,
        child: FutureBuilder<BeanGetOrderRequest>(
            future: orderRequest.orderRequest(),
            builder: (context, snapshot) {
             // for(int i=0;i<=snapshot.data!.data!.length;i++)
             //  getOrderDetails(context, snapshot.data!.data![i].orderId.toString(), snapshot.data!.data![i].orderitemsId.toString()).then((value) {
             //   setState(() {
             //     //isViewLoading = false;
             //   });
             //   return value;
             // });
              return snapshot.hasData //snapshot.connectionState == ConnectionState.done && snapshot.data != null
                  ? snapshot.data!.data!.isEmpty
                      ? Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 12, right: 12),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(Res.order_Request),
                                SizedBox(
                                  height: 24,
                                ),
                                Text(
                                  'There are no available Order Request',
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontBold,
                                      fontSize: 20),
                                ),
                              ]),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(bottom: 72),
                          itemCount: snapshot.data!.data!.length,
                          shrinkWrap: true,
                          //scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                showAlertDialog(
                                  context,
                                  snapshot.data!.data![index].orderId.toString(),
                                  snapshot.data!.data![index].orderitemsId.toString(),
                                  snapshot.data!.data![index].subscriptionType.toString(),
                                  snapshot.data!.data![index].pickupTime.toString(),
                                  snapshot.data!.data![index].orderNumber.toString(),
                                  snapshot.data!.data![index].subscriptionType == "old",
                                  snapshot.data!.data![index].specialInstruction.toString(),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(.25),
                                        blurRadius: 30),
                                  ],

                                  color: snapshot.data!.data![index].isDivert=="1"?Colors.white:
                                  snapshot.data!.data![index].subscriptionType == "new"
                                      ? snapshot.data!.data![index].ordertype == "trial"
                                          ? Colors.white
                                          : Color.fromARGB(255, 251, 243, 177)
                                      : Color.fromARGB(255, 226, 254, 254),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        snapshot.data!.data![index].customerImage == ''
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
                                                    '${snapshot.data!.data![index].customerImage}',
                                                  ),
                                                ),
                                              ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      //color:Colors.red,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                      child: Text(
                                                        "${snapshot.data!.data![index].customerName.toString()}",
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontFamily:
                                                                AppConstant
                                                                    .fontBold),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${snapshot.data!.data![index].orderNumber}  ',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontFamily: AppConstant
                                                              .fontRegular),
                                                    ),
                                                    snapshot.data!.data![index].subscriptionType == "new" &&
                                                            snapshot.data!.data![index].ordertype == "package"
                                                        ? Container(
                                                            // color: Colors.red,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.4,
                                                            child: Text(
                                                              "${snapshot.data!.data![index].orderDate}",
                                                              //"${snapshot.data!.data![index].fromDate} To ${snapshot.data!.data![index].toDate} ",
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                  color:
                                                                      Colors.grey,
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      AppConstant
                                                                          .fontRegular),
                                                            ),
                                                          )
                                                        : Text(
                                                            snapshot
                                                                .data!
                                                                .data![index]
                                                                .orderDate
                                                                .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    AppConstant
                                                                        .fontRegular),
                                                          ),
                                                  ]),
                                              //Spacer(),
                                              Column(
                                                children: [
                                                  snapshot.data!.data![index].tag != ""
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: snapshot
                                                                            .data!
                                                                            .data![
                                                                                index]
                                                                            .tag ==
                                                                        "#New Subscription"
                                                                    ? Colors.green
                                                                    : snapshot.data!.data![index].tag ==
                                                                            "#Pre Order"
                                                                        ? Colors
                                                                            .blue
                                                                        : Colors
                                                                            .red,
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            10.0,
                                                                        vertical:
                                                                            4.0),
                                                                child: Text(
                                                                  "${snapshot.data!.data![index].tag}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(height: 6),
                                                  Text(
                                                    AppConstant.rupee +
                                                        snapshot
                                                            .data!
                                                            .data![index]
                                                            .orderAmount
                                                            .toString(),
                                                    style: TextStyle(
                                                        color: AppConstant
                                                            .lightGreen,
                                                        fontSize: 16,
                                                        fontFamily:
                                                            AppConstant.fontBold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(
                                      height: 4,
                                    ),
                                    Visibility(
                                      visible: snapshot.data!.data![index].isDivert=="1"?false:true,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${snapshot.data!.data![index].menuFor == "Trial" ? "" : snapshot.data!.data![index].menuFor!.toUpperCase()}  ",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16,
                                                fontFamily: AppConstant.fontBold),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 15),
                                    snapshot.data!.data![index].ordertype == "package"
                                        ? Visibility(
                                      visible: snapshot.data!.data![index].isDivert=="1"?false:true,
                                          child: Text(
                                              "Package : ${snapshot.data!.data![index].packageName}",
                                              style: TextStyle(
                                                  fontFamily: AppConstant.fontBold,
                                                  color: Colors.grey),
                                            ),
                                        )
                                        : SizedBox(),
                                    Row(
                                      children: [
                                        Text(
                                          "Delivery Date :",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontFamily: AppConstant.fontBold,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(width: 8),
                                        snapshot.data!.data![index].isDivert=="1"?Text(snapshot.data!.data![index].deliveryDate.toString(),
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ):
                                        snapshot.data!.data![index].subscriptionType == "new" &&
                                                snapshot.data!.data![index].ordertype == "package"
                                            ? Text(
                                                "(${snapshot.data!.data![index].fromDate} To ${snapshot.data!.data![index].toDate} )".toString(),
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold),
                                              )
                                            : Text(
                                                "${snapshot.data!.data![index].deliveryDate}".toString(),
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold),
                                              )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Pick up Time : ",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          " ${snapshot.data!.data![index].pickupTime}",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 28,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 16),
                                          child: Image.asset(
                                            Res.ic_dinner,
                                            width: 20,
                                            height: 25,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Text(
                                              snapshot.data!.data![index]
                                                          .monthlyPlan
                                                          .toString() ==
                                                      ''
                                                  ? snapshot.data!.data![index]
                                                              .weeklyPlan
                                                              .toString() ==
                                                          ""
                                                      ? snapshot.data!
                                                          .data![index].orderItems
                                                          .toString()
                                                      : snapshot.data!
                                                          .data![index].menuFor!
                                                          .toString()
                                                  : snapshot
                                                      .data!.data![index].menuFor!
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      AppConstant.fontBold),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                           showAlertDialog(
                                             context,
                                             snapshot.data!.data![index].orderId.toString(),
                                             snapshot.data!.data![index].orderitemsId.toString(),
                                             snapshot.data!.data![index].subscriptionType.toString(),
                                             snapshot.data!.data![index].pickupTime.toString(),
                                             snapshot.data!.data![index].orderNumber.toString(),
                                             snapshot.data!.data![index].subscriptionType == "old",
                                               snapshot.data!.data![index].specialInstruction.toString(),
                                           );
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    AppConstant.appColor),
                                          ),
                                          child: Text(
                                            "View Order",
                                            style: TextStyle(
                                                fontFamily:
                                                    AppConstant.fontRegular),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    snapshot.data!.data![index].specialInstruction==""?SizedBox():
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
                                            "${snapshot.data!.data![index].specialInstruction}",
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Divider(color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 28,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            rejectDialog(
                                                orderNumber: snapshot.data!.data![index].orderNumber.toString(),
                                                orderID: snapshot.data!.data![index].subscriptionType == "old"
                                                    ? snapshot.data!.data![index].orderitemsId
                                                    : snapshot.data!.data![index].orderId,
                                                subscriptionType: snapshot.data!.data![index].subscriptionType,
                                                isFromDetails: false);
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
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "REJECT",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily:
                                                        AppConstant.fontBold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            acceptDialog(
                                                orderNumber: snapshot.data!.data![index].orderNumber.toString(),
                                                orderID: snapshot.data!.data![index].subscriptionType == "old"
                                                    ? snapshot.data!.data![index].orderitemsId
                                                    : snapshot.data!.data![index].orderId,
                                                subscriptionType: snapshot.data!.data![index].subscriptionType,
                                                isFromDetails: false,
                                            instructions: snapshot.data!.data![index].specialInstruction.toString(),);
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
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "ACCEPT",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily:
                                                        AppConstant.fontBold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Divider(color: Colors.grey.withOpacity(0.5), thickness: 5)
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                  : Center(
                      child: CircularProgressIndicator(
                      color: AppConstant.appColor,
                    ));

              /*Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 12, right: 12),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(Res.order_Request),
                                SizedBox(
                                  height: 24,
                                ),
                                Text(
                                  'There are no available Order Request',
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontBold,
                                      fontSize: 20),
                                ),
                              ]),
                        )*/

              /*  : Center(
                      child: CircularProgressIndicator(
                      color: AppConstant.appColor,
                    ));*/
            }),
      ),
    );
  }

  successfullyacceptDialog(
    String orderNumber,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });
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
                height: 15,
              ),
              Image.asset(
                Res.ic_successfully_accept,
                fit: BoxFit.fill,
                //width: 16,
                height: 170,
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                "Order Number : $orderNumber \nis successfully accepted",
                style: TextStyle(fontFamily: AppConstant.fontRegular),
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

  successfullyrejactDialog(
    String orderNumber,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });
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
                height: 15,
              ),
              Image.asset(
                Res.ic_successfully_accept,
                fit: BoxFit.fill,
                //width: 16,
                height: 170,
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                "Order Number : $orderNumber \nis successfully rejected",
                style: TextStyle(fontFamily: AppConstant.fontRegular),
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

  acceptDialog(
      {required String orderNumber,
      required orderID,
      required subscriptionType,
      required bool isFromDetails,
        required String instructions}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Container(
            //height: 200,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                Res.ic_accept_dialog,
                fit: BoxFit.fill,
                //width: 16,
                height: 120,//170
              ),
              SizedBox(
                height: 24,
              ),
                  instructions==""?SizedBox():
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 8),
                margin: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color:
                          Colors.black.withOpacity(.25),
                          blurRadius: 30),
                    ],
                    border: Border.all(
                      color: Color.fromARGB(
                          255, 208, 207, 206),
                    ),
                  color: Color.fromRGBO(255, 227, 202, 1.0),),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/note2.svg',),
                    Text(
                        " Instructions : ",
                        style: TextStyle( color: Color.fromRGBO(177, 0, 0, 1.0),
                        fontWeight: FontWeight.w600),

                    ),Container(
                      //color: Colors.red,
                      width: 130,
                      child: Padding(
                        padding: const EdgeInsets.only(top:  2.0),
                        child: Text(
                            "$instructions",
                            maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                                color: Color.fromRGBO(96, 116, 125, 1.0),
                            fontWeight: FontWeight.w600),

                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                " Are you sure you want to accept\nthis order?",
                textAlign: TextAlign.center,
                style:
                    TextStyle(
                        color: Color.fromRGBO(96, 116, 125, 1.0),
                        fontWeight: FontWeight.w500, fontSize: 16),
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
                      orderAccepted(orderID, subscriptionType).then((value) {
                        setState(() {
                          _pullRefresh();
                        });
                        if (isFromDetails) {
                          Navigator.pop(context);
                          successfullyacceptDialog(orderNumber);
                        } else {
                          successfullyacceptDialog(orderNumber);
                        }
                      });
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
                  /*ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 242, 106, 96),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'NO',
                      style: TextStyle(fontFamily: AppConstant.fontRegular),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 118, 214, 121),
                      ),
                    ),
                    onPressed: () {
*/ /*                      userBean!.data!.availableStatus == '0'
                          ? "You cant accept orders in inactive mode"
                          :*/ /*
                      orderAccepted(orderID, subscriptionType).then((value) {
                        setState(() {
                          _pullRefresh();
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            closeIconColor: Colors.black,
                            backgroundColor: AppConstant.appColor,
                            showCloseIcon: true,
                            content: Container(
                              height: 100,
                              padding: EdgeInsets.all(12),
                              alignment: Alignment.center,
                              child: Text(
                                "Order Number : $orderNumber \nis successfully accepted",
                                style: TextStyle(
                                    fontFamily: AppConstant.fontRegular),
                              ),
                            ),
                          ),
                        );
                      });
                      //Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text(
                      'YES',
                      style: TextStyle(fontFamily: AppConstant.fontRegular),
                    ),
                  )*/
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ]),
          ),
        );
      },
    );
  }

  rejectDialog(
      {required String orderNumber,
      required orderID,
      required subscriptionType,
      required bool isFromDetails}) {
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
                Res.ic_accept_dialog,
                fit: BoxFit.fill,
                //width: 16,
                height: 170,
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                " Are you sure you want \n to reject the order ??",
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
                      orderRejected(orderID, subscriptionType).then((value) {
                        setState(() {
                          _pullRefresh();
                        });
                        if (isFromDetails) {
                          Navigator.pop(context);
                          successfullyrejactDialog(orderNumber);
                        } else {
                          successfullyrejactDialog(orderNumber);
                        }
                      });
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

  /*rejectDialog(String orderNumber, orderID, subscriptionType) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 200,
            padding: EdgeInsets.all(12),
            child: Column(children: [

              SizedBox(
                height: 24,
              ),
              Text(
                "Are you sure you want \n to reject the order ??",
                style:
                    TextStyle(fontFamily: AppConstant.fontBold, fontSize: 20),
              ),
              SizedBox(
                height: 24,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 242, 106, 96),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'NO',
                    style: TextStyle(fontFamily: AppConstant.fontRegular),
                  ),
                ),
                SizedBox(
                  width: 48,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 118, 214, 121),
                    ),
                  ),
                  onPressed: () {
                    orderRejected(
                      orderID,
                      subscriptionType.toString(),
                    ).then((value) {
                      return ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          closeIconColor: Colors.black,
                          backgroundColor: AppConstant.appColor,
                          showCloseIcon: true,
                          content: Container(
                            height: 100,
                            padding: EdgeInsets.all(12),
                            alignment: Alignment.center,
                            child: Text(
                              "Order Number : $orderNumber \nis successfully rejected",
                              style: TextStyle(
                                  fontFamily: AppConstant.fontRegular),
                            ),
                          ),
                        ),
                      );
                    });
                  },
                  child: Text(
                    'YES',
                    style: TextStyle(fontFamily: AppConstant.fontRegular),
                  ),
                )
              ]),
            ]),
          ),
        );
      },
    );
  }*/

  // void stopRing() {
  //
  //   player.pause();
  // }

  Future<BeanOrderAccepted?> orderAccepted(
      String orderId, String subscriptionType) async {
    BeanLogin userBean = await Utils.getUser();

    FormData from = FormData.fromMap({
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
      "order_id": orderId,
      "subscription_type": subscriptionType
    });
    print(
        "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    print({
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
      "order_id": orderId,
      "subscription_type": subscriptionType
    });
    BeanOrderAccepted? bean =
        await ApiProvider().orderAccept(orderId, subscriptionType);

    //stopRing();
    if (bean.status == true) {
      // getOrderRequest(context).then((value) {
      //   requestView = value;
      setState(() {
        _pullRefresh();
      });

      Navigator.of(context, rootNavigator: true).pop();
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //     builder:
      //     (context) => RequestScreen()));
      //Navigator.of(context, rootNavigator: true).pop();
      //});

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => OrderScreen(true),
      //   ),
      // );
      // getOrderRequest(context).then((value) {
      //   setState(() {
      //     requestView = value;
      //   });
      // });
      return bean;
    } else {
      throw Exception("Something went wrong");
    }
    return null;
  }

  Future<BeanOrderRejected?> orderRejected(
      String orderId, String subscriptionType) async {
    BeanLogin userBean = await Utils.getUser();
    FormData from = FormData.fromMap({
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
      "order_id": orderId,
      "subscription_type": subscriptionType
    });
    BeanOrderRejected bean =
        await ApiProvider().orderReject(orderId, subscriptionType);

    if (bean.status == true) {
      Navigator.of(context, rootNavigator: true).pop();

      //stopRing();
      if (bean.status == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderScreen(true, 0),
          ),
        );

        return bean;
      } else {
        throw Exception("Something went wrong");
      }
    }
  }

  showAlertDialog(
    BuildContext context,
    String orderId,
    String orderItemsId,
    String subscriptionType,
    String pickupTime,
    String orderNumber,
    bool isUpcomingOrder,
      String instructions,
  ) async {
    print("------------------------------orderId>${orderId}");
    print("------------------------------orderItemsId>${orderItemsId}");
    print("------------------------------subscriptionType>${subscriptionType}");
    print("------------------------------pickupTime>${pickupTime}");
    print("------------------------------orderNumber>${orderNumber}");

    GetOrderDetailsData? orderDetails;


    orderDetails = await getOrderDetails(context, orderId, orderItemsId).then((value) {
      setState(() {
        print("------------------------------orderDate>${orderDetails?.deliveryDate}");

        //isViewLoading = false;
      });
      return value;
    });

    return orderDetails != null
        ? showDialog<void>(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return  StatefulBuilder(builder: (context, setStat) {
               return Scaffold(
                 body: Container(
                   height: MediaQuery.of(context).size.height,
                   // * 0.75,
                   width: MediaQuery.of(context).size.width,
                   color: Colors.white,
                   padding: EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                   child: SingleChildScrollView(
                     child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           Align(
                             alignment: Alignment.topLeft,
                             child: OutlinedButton(
                               style: OutlinedButton.styleFrom(
                                 side: BorderSide(
                                     width: 2.0, color: Colors.orange),
                               ),
                               onPressed: () {
                                 Navigator.pop(context);
                               },
                               child: Text(
                                 "Go Back",
                                 style: TextStyle(
                                     fontSize: 15,
                                     color: Colors.orange,
                                     fontFamily: AppConstant.fontRegular,
                                     fontWeight: FontWeight.w600),
                               ),
                             ),
                           ),
                           SizedBox(
                             height: 10,
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
                               Expanded(
                                 child: Text(
                                   "Order Date:",
                                   style: TextStyle(
                                       fontFamily: AppConstant.fontRegular,
                                       color: Colors.black),
                                 ),
                               ),
                               Text(
                                 "${orderDetails.orderDate}",
                                 style: TextStyle(
                                     fontFamily: AppConstant.fontRegular),
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
                               Expanded(
                                 child: Text(
                                   "Customer Name:",
                                   style: TextStyle(
                                       fontFamily: AppConstant.fontRegular,
                                       color: Colors.black),
                                 ),
                               ),
                               Text(
                                 "${orderDetails.customerName}",
                                 style: TextStyle(
                                     fontFamily: AppConstant.fontRegular),
                                 maxLines: 1,
                               )
                             ],
                           ),
                           (isUpcomingOrder)
                               ? Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               SizedBox(height: 8),
                               Row(
                                 //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: <Widget>[
                                   Text(
                                     "Delivery Date: ",
                                     style: TextStyle(
                                         fontFamily:
                                         AppConstant.fontRegular,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.red),
                                   ),
                                   Text(
                                     "${orderDetails.deliveryDate}",//order_delivery_date
                                     style: TextStyle(
                                         fontFamily:
                                         AppConstant.fontRegular,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.red),
                                     maxLines: 1,
                                   )
                                 ],
                               )
                             ],
                           )
                               : Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               if (orderDetails.orderType != "package")
                                 SizedBox(height: 8),
                               if (orderDetails.orderType != "package")
                                 Row(
                                   //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: <Widget>[
                                     Text(
                                       "Delivery Date: ",
                                       style: TextStyle(
                                           fontFamily:
                                           AppConstant.fontRegular,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.red),
                                     ),
                                     Text(
                                       "${orderDetails.order_now_delivery_date["date"]}",
                                       style: TextStyle(
                                           fontFamily:
                                           AppConstant.fontRegular,
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
                                       "Delivery Date: ",
                                       style: TextStyle(
                                           fontFamily:
                                           AppConstant.fontRegular,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.red),
                                     ),
                                     Text(
                                       orderDetails!.deliveryDate.toString(),
                                       style: TextStyle(
                                           fontFamily:
                                           AppConstant.fontRegular,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.red),
                                       maxLines: 1,
                                     )
                                   ],
                                 ),
                             ],
                           ),
                           SizedBox(height: 8),
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
                                   color: Color.fromARGB(255, 208, 207, 206),
                                 ),
                                 color: Colors.white),
                             child: Column(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 orderDetails.itemsDetail!.isEmpty
                                     ? Text(
                                   orderDetails.packageName.toString(),
                                   style: TextStyle(
                                       fontFamily:
                                       AppConstant.fontRegular),
                                 )
                                     : Container(
                                   width: double.infinity,
                                   //color: Colors.blue,
                                   child: Column(
                                     children: [
                                       orderDetails.itemsDetail!.isEmpty
                                           ? Text(
                                         orderDetails.packageName
                                             .toString(),
                                         style: TextStyle(
                                             fontFamily: AppConstant
                                                 .fontRegular),
                                       )
                                           : ListView.builder(
                                         itemCount: orderDetails
                                             .itemsDetail!.length,
                                         shrinkWrap: true,
                                         scrollDirection:
                                         Axis.vertical,
                                         physics:
                                         NeverScrollableScrollPhysics(),
                                         //BouncingScrollPhysics(),
                                         itemBuilder:
                                             (context, index) {
                                           return Text(
                                             "${orderDetails!.itemsDetail?[index].quantity} x ${orderDetails.itemsDetail?[index].itemName}",
                                             style: TextStyle(
                                                 fontFamily:
                                                 AppConstant
                                                     .fontRegular),
                                           );
                                         },
                                       ),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                           ),
                           SizedBox(
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
                             child: SingleChildScrollView(
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   /* Text(
                                    "Special Instructions : ${orderDetails.specialInstruction ?? "N/A"}",
                                    style: TextStyle(
                                        fontFamily: AppConstant.fontRegular),
                                  ),*/
                                   /* SizedBox(
                                    width: 10,
                                    height: 10,
                                  ),*/
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
                                               color:
                                               Colors.black.withOpacity(.25),
                                               blurRadius: 30),
                                         ],
                                         border: Border.all(
                                           color: Color.fromARGB(
                                               255, 208, 207, 206),
                                         ),
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
                                   SizedBox(
                                     width: 10,
                                     height: 10,
                                   ),
                                   const SizedBox(
                                     height: 20,
                                   ),
                                   Align(
                                     alignment: Alignment.bottomRight,
                                     child: Column(
                                       crossAxisAlignment:
                                       CrossAxisAlignment.end,
                                       children: [
                                         Text(
                                           "Discount : ${orderDetails.discount}",
                                           maxLines: 1,
                                           textAlign: TextAlign.end,
                                           style: TextStyle(
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
                                               fontWeight: FontWeight.bold,
                                               fontSize: 12),
                                         ),
                                         SizedBox(
                                           height: 10,
                                         ),
                                         Text(
                                           "Packing Charges : ${orderDetails.packagingCharge}",
                                           style: TextStyle(
                                               fontSize: 12,
                                               fontFamily: AppConstant.fontBold),
                                         ),
                                         SizedBox(
                                           height: 10,
                                         ),
                                         Text(
                                           "Total : ${orderDetails.total}",
                                           maxLines: 1,
                                           textAlign: TextAlign.end,
                                           style: TextStyle(
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
                                                     mainAxisAlignment: MainAxisAlignment.end,
                                                     children: [
                                                       Visibility(
                                                         visible: isShow==true?true:false,
                                                         child: Container(
                                                           width: 180,
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
                                                         " ${orderDetails.category} : ${orderDetails.amount}",/*Addition*/
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
                                   ),
                                 ],
                               ),
                             ),
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
                                   color: Color.fromARGB(255, 208, 207, 206),
                                 ),
                                 color: Colors.white),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   "Order Status Update",
                                   style: TextStyle(
                                       color: Colors.black,
                                       fontSize: 14,
                                       fontFamily: AppConstant.fontBold),
                                 ),
                                 SizedBox(
                                   height: 15,
                                 ),
                                 Row(
                                   mainAxisAlignment:
                                   MainAxisAlignment.spaceBetween,
                                   children: [
                                     GestureDetector(
                                       onTap: () {
                                         rejectDialog(
                                             orderNumber: orderNumber,
                                             orderID: subscriptionType == "old"
                                                 ? orderItemsId
                                                 : orderId,
                                             subscriptionType: subscriptionType,
                                             isFromDetails: true);
                                       },
                                       child: Container(
                                         height: 40,
                                         width: 110,
                                         margin: EdgeInsets.only(
                                             left: 10, bottom: 10),
                                         decoration: BoxDecoration(
                                           color:
                                           Color.fromARGB(255, 242, 106, 96),
                                           borderRadius:
                                           BorderRadius.circular(10),
                                         ),
                                         child: Center(
                                           child: Text(
                                             "REJECT",
                                             style: TextStyle(
                                                 color: Colors.white,
                                                 fontSize: 14,
                                                 fontFamily:
                                                 AppConstant.fontBold),
                                           ),
                                         ),
                                       ),
                                     ),
                                     InkWell(
                                       onTap: () {
                                         acceptDialog(
                                             orderNumber: orderNumber,
                                             orderID: subscriptionType == "old"
                                                 ? orderItemsId
                                                 : orderId,
                                             subscriptionType: subscriptionType,
                                             isFromDetails: true,
                                             instructions: instructions);
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
                                           BorderRadius.circular(10),
                                         ),
                                         child: Center(
                                           child: Text(
                                             "ACCEPT",
                                             style: TextStyle(
                                                 color: Colors.white,
                                                 fontSize: 14,
                                                 fontFamily:
                                                 AppConstant.fontBold),
                                           ),
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                               ],
                             ),
                           ),
                         ]),
                   ),
                 ),
               );
             },);
            },
          )
        : Container();
  }

  Future<GetOrderDetailsData?> getOrderDetails(
      BuildContext context, String orderId, String orderItemId) async {
    try {
      BeanLogin user = await Utils.getUser();
      FormData from = FormData.fromMap({
        "kitchen_id": user.data!.id,
        "token": "123456789",
        "order_id": orderId,
        "order_item_id": orderItemId,
      });

      GetOrderDetailsData? bean = await ApiProvider()
          .getOrderDetails(orderId: orderId, orderItemId: orderItemId);

      // setState(() {
      //   isViewLoading = false;
      // });
      return bean;
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
}
