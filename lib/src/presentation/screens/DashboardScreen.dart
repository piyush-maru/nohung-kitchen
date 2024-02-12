import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/Order/ActiveScreen.dart';
import 'package:kitchen/Order/OrdersHistory.dart';
import 'package:kitchen/Order/UpcomingScreen.dart';
import 'package:kitchen/main.dart';
import 'package:kitchen/model/BeanGetOrderDetails.dart';
import 'package:kitchen/model/BeanGetOrderRequest.dart';
import 'package:kitchen/model/BeanOrderAccepted.dart';
import 'package:kitchen/model/getKitchenStatus.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/network/dashboard_model.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/src/presentation/screens/DashboardScreen%20copy.dart';
import 'package:kitchen/src/presentation/screens/HomeBaseScreen.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/Utils.dart';
import 'package:kitchen/utils/constant/ui_constants.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Order/OrderScreen.dart';
import '../../../model/BeanOrderRejected.dart';
import '../../../model/GetActiveOrder.dart';
import '../../../model/KitchenData/BeanGetDashboard.dart';
import '../../../model/KitchenData/BeanLogin.dart';
import '../../../model/KitchenData/GetAccountDetail.dart';
import '../../../network/OrderRepo/active_orders_repo.dart';
import '../../data/services/notification_services/push_notification.dart';

class DashboardScreen extends StatefulWidget {
  final bool? currentTableSelected;

  DashboardScreen(this.currentTableSelected);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isKitchenActive = true;
  KitchenStatus? bean;
  Timer? timer;
  bool? kitchenStatus = true;
  bool isBackground = false;
  Future<GetActiveOrder>? future;

  @override
  void initState() {
    PushNotification().init(context);
    getAccountDetails(context);
    // getUserData().then((value) {
    //    getOrderRequest();
    // });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (WidgetsBinding.instance.lifecycleState != null) {}
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      if (widget.currentTableSelected!) {
        if (kitchenStatus == true || kitchenStatus == null) {
          openActiveRequests(context);
        } else {
          t.cancel();
        }
      }
    });

    timer = Timer.periodic(Duration(seconds: 30), (Timer t) {
      final dashboardModel =
          Provider.of<DashboardModel>(context, listen: false);
      dashboardModel.getHomeScreen();
    });

    Future.delayed(Duration.zero, () {
      final dashboardModel =
          Provider.of<DashboardModel>(context, listen: false);
      dashboardModel.getHomeScreen();
      // updateKitchenStatus(isKitchenActive);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      setState(() {
        isBackground = true;
      });
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        isBackground = false;
      });
    } else if (AppLifecycleState.paused == state) {
      setState(() {
        isBackground = true;
      });
    }
  }

  Future<void> _pullRefresh() async {
    await Future.delayed(Duration.zero, () {
      setState(() {
        final dashboardModel =
            Provider.of<DashboardModel>(context, listen: false);
        dashboardModel.getHomeScreen();
        getAccountDetails(context);
      });
    });
  }

  @override
  void dispose() {
    //timer!.cancel();
    super.dispose();
  }

  Future<BeanGetOrderRequest> getOrderRequest() async {
    BeanLogin? userBean = await Utils.getUser();
    FormData from = FormData.fromMap({
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
    });
    BeanGetOrderRequest? bean = await ApiProvider().getOrderRequest();
    if (bean!.status == true) {
      int? lenght = await getOrdersRequestCount();

      if (bean.data!.length > (lenght ?? 0)) {
        /*  PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: OrderScreen(true,0),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );*/
        // PerfectVolumeControl.setVolume(1);
        // AudioPlayer().play(AssetSource('notification_sound.mp3'));
        // Navigator.pushNamed(context, '/orders');
        // PersistentTabController(initialIndex: 2);
        if (!isBackground) {
          timer!.cancel();
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: OrderScreen(true, 0),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        } else {
          // PerfectVolumeControl.setVolume(1);
          //AudioPlayer().play(AssetSource('notification_sound.mp3'));
        }
      }
      // saveOrdersRequestCount(bean.data.length);

      return bean;
    } else {
      return bean;
    }
  }

  final player = AudioPlayer();

  Future<void> getUserData() async {
    kitchenStatus = await getKitchenStatus();
    setState(() {
      kitchenStatus = kitchenStatus;
    });
  }

  Future<KitchenStatus> updateKitchenStatus(value) async {
    BeanLogin userBean = await Utils.getUser();
    FormData form = FormData.fromMap({
      "token": "123456789",
      "status": value == true ? "1" : "0",
      "kitchen_id": userBean.data!.id,
    });
    KitchenStatus? bean = await ApiProvider()
        .updateKitchenAvailability(value == true ? "1" : "0");
    if (bean.status == true) {
      saveKitchenStatus(value);
      Utils.showToast(bean.message ?? "", context);

      return bean;
    } else {
      throw Exception("Something went wrong");
      // Utils.showToast(bean.message ?? "", context);
    }
    return bean;
  }

  @override
  Widget build(BuildContext context) {
    final dashboardModel = Provider.of<DashboardModel>(context, listen: false);
    return Scaffold(
      drawer: MyDrawers(),
      appBar: AppBar(
        backgroundColor: AppConstant.appColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            setState(() {
              _scaffoldKey.currentState!.openDrawer();
            });
          },
          child: Image.asset(
            Res.ic_menu,
            width: 30,
            height: 30,
            color: Colors.white,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 16,
            ),
            Text(
              "Dashboard",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: AppConstant.fontBold),
            ),
            Spacer(),
            Transform.scale(
              scale: 1.5,
              child: Switch(
                value: isKitchenActive,
                onChanged: (value) {
                  setState(() {
                    dashboardModel.getHomeScreen();
                    updateKitchenStatus(value);
                    isKitchenActive = value;
                  });
                },
                inactiveThumbColor: Colors.red,
                inactiveTrackColor: Colors.red.shade300,
                activeColor: Colors.green,
                activeTrackColor: Colors.green.shade300,
              ),
            ),
            SizedBox(
              height: 10,
              width: 20,
            ),
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()),
                  );
                },
                child: Image.asset(
                  Res.ic_notification,
                  width: 25,
                  height: 25,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppConstant.appColor,
      key: _scaffoldKey,
      body: new RefreshIndicator(
        onRefresh: _pullRefresh,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
            ),
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder<BeanGetDashboard>(
                future: dashboardModel.getHomeScreen(),
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CircleAvatar(
                                    radius: 45,
                                    backgroundImage: NetworkImage(
                                      snapshot.data!.data!.profileImage
                                          .toString(),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      snapshot.data!.data!.kitchenName
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: AppConstant.fontBold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.45,
                                      child: Text(
                                        snapshot.data!.data!.description
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Color(0xffA7A8BC),
                                            fontSize: 14,
                                            fontFamily:
                                                AppConstant.fontRegular),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrderScreen(true, 0),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        margin:
                                            EdgeInsets.only(left: 16, top: 16),
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Container(
                                          height: 110,
                                          width: 70,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Text(
                                                snapshot
                                                    .data!.data!.pendingOrders
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Color(0xffFCA896),
                                                    fontSize: 30,
                                                    fontFamily:
                                                        AppConstant.fontBold),
                                              ),
                                              Text(
                                                "  Order\nRequests",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontFamily: AppConstant
                                                        .fontRegular),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OrdersHistory(
                                              fromDashboard: true,
                                              order: "completed",
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        margin:
                                            EdgeInsets.only(left: 16, top: 16),
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Container(
                                          height: 110,
                                          width: 70,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Text(
                                                snapshot
                                                    .data!.data!.completedOrders
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 90, 215, 138),
                                                    fontSize: 30,
                                                    fontFamily:
                                                        AppConstant.fontBold),
                                              ),
                                              Text(
                                                "Completed\n   Orders",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontFamily: AppConstant
                                                        .fontRegular),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpcomingScreen(
                                              fromDashboard: true,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        margin:
                                            EdgeInsets.only(left: 16, top: 16),
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Container(
                                          height: 110,
                                          width: 70,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Text(
                                                snapshot
                                                    .data!.data!.upcomingOrders
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Color(0xffFEDF7C),
                                                    fontSize: 30,
                                                    fontFamily:
                                                        AppConstant.fontBold),
                                              ),
                                              Text(
                                                "Upcoming\n   Orders",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontFamily: AppConstant
                                                        .fontRegular),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OrdersHistory(
                                              fromDashboard: true,
                                              order: "cancelled",
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        margin:
                                            EdgeInsets.only(left: 16, top: 16),
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Container(
                                          height: 110,
                                          width: 70,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Text(
                                                snapshot.data!.data!.cancelledOrders.toString(),
                                                style: TextStyle(
                                                    color: Color(0xffBEE8FF),
                                                    fontSize: 30,
                                                    fontFamily:
                                                        AppConstant.fontBold),
                                              ),
                                              Text(
                                                "Cancel\nOrders",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontFamily: AppConstant
                                                        .fontRegular),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 22,bottom: 16.0),
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderScreen(true, 4),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 46,
                                    width: 176,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey, // Shadow color
                                          blurRadius: 10.0, // Spread of the shadow
                                          offset: Offset(0, 4), // Offset of the shadow
                                        ),
                                      ],
                                      color: AppConstant.appColor,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: poppinsText(
                                        maxLines: 1,
                                        txt: "View Today Orders",
                                        fontSize: 16,
                                        color: Colors.white,
                                        textAlign: TextAlign.center,
                                        weight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),





                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ActiveScreen(
                                        fromDashboard: true,
                                        refreshOrdersCallback: () {
                                          setState(() {
                                            future = context
                                                .read<ActiveOrderModel>()
                                                .getActiveOrders();
                                          });
                                        }),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 16, top: 0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Image.asset(
                                      Res.ic_pan,
                                      width: 120,
                                      height: 120,
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Active\nOrders",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: AppConstant.fontBold),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        snapshot.data!.data!.activeOrders
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: AppConstant.fontBold),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Image.asset(
                                        Res.ic_back,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10, top: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        height: 50,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Color(0xffBEE8FF),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Preparing  ${snapshot.data!.data!.preparing}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily:
                                                    AppConstant.fontRegular),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        height: 50,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Color(0xff7EDABF),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Ready ${snapshot.data!.data!.ready}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily:
                                                    AppConstant.fontRegular),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10),
                                        height: 50,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Color(0xffFEDF7C),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Out for Delivery ${snapshot.data!.data!.outForDelivery}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontFamily:
                                                    AppConstant.fontRegular),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            color: AppConstant.appColor,
                          ),
                        );
                }),
          ),
          physics: BouncingScrollPhysics(),
        ),
      ),
    );
  }

  Future<GetAccountDetails> getAccountDetails(BuildContext context) async {
    var userBean = await Utils.getUser();
    FormData from =
        FormData.fromMap({"user_id": userBean.data!.id, "token": "123456789"});
    GetAccountDetails bean = await ApiProvider().getAccountDetails();

    if (bean.status!) {
      setState(() {
        var kitchenStatus = bean.data!.availableStatus;
        if (kitchenStatus == '1') {
          isKitchenActive = true;
        } else {
          isKitchenActive = false;
        }
      });

      return bean;
    } else {
      throw Exception("Something went wrong");
    }
  }
}

List<RequestData1> activeRequestsList = [];
bool? kitchenStatus = true;
bool isBackground = false;
Timer? timer;
Future<GetActiveOrder>? future;
bool openDialog = false;
List localeOrderId = [];
bool packageOrder = false;

Future<BeanGetOrderRequest> getOrderRequest1(BuildContext context) async {
  BeanLogin? userBean = await Utils.getUser();
  FormData from = FormData.fromMap({
    "kitchen_id": userBean.data!.id,
    "token": "123456789",
  });
  BeanGetOrderRequest? bean = await ApiProvider().getOrderRequest();
  if (bean!.status == true) {
    int? lenght = await getOrdersRequestCount();

    if (bean.data!.length > (lenght ?? 0)) {
      //PersistentNavBarNavigator.pushNewScreen(
      //  context,
      //  screen: OrderScreen(true,0),
      //  withNavBar: true,
      //  pageTransitionAnimation: PageTransitionAnimation.cupertino,
      //);
      // PerfectVolumeControl.setVolume(1);
      // AudioPlayer().play(AssetSource('notification_sound.mp3'));
      // Navigator.pushNamed(context, '/orders');
      // PersistentTabController(initialIndex: 2);
      if (!isBackground) {
        timer!.cancel();
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: OrderScreen(true, 0),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      } else {
        //PerfectVolumeControl.setVolume(1);
        //AudioPlayer().play(AssetSource('notification_sound.mp3'));
      }
    }
    // saveOrdersRequestCount(bean.data.length);

    return bean;
  } else {
    return bean;
  }
}

Future showActiveRequestsDialog({
  required BuildContext context,
  required RequestData1 res,
  required List<RequestData1> newDataList,
}) async {
  openDialog = true;

  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetAnimationDuration: const Duration(seconds: 1),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            // Set rounded corners
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 35),
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.topRight,
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage: res.customerImage == ""
                                        ? AssetImage(Res.ic_account)
                                        : NetworkImage(res.customerImage!)
                                            as ImageProvider<Object>,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        res.customerName ?? "",
                                        style: TextStyle(
                                            fontFamily: AppConstant.fontRegular,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        res.orderNumber ?? "",
                                        style: TextStyle(
                                          fontFamily: AppConstant.fontRegular,
                                          fontSize: 15,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        res.orderDate ?? "",
                                        style: TextStyle(
                                          fontFamily: AppConstant.fontRegular,
                                          fontSize: 15,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                  children: [
                                    if (res.tag != "" && res.tag != null)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: (res.tag == "#Pre Order")
                                                ? Colors.blue
                                                : (res.tag ==
                                                        "#New Subscription")
                                                    ? Colors.green
                                                    : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(
                                          res.tag ?? "",
                                          style: TextStyle(
                                              fontFamily:
                                                  AppConstant.fontRegular,
                                              color: Colors.white,
                                              fontSize: 13),
                                        ),
                                      ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "₹ ${res.orderAmount}",
                                      style: TextStyle(
                                        fontFamily: AppConstant.fontRegular,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: AppConstant.lightGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Delivery Date: ",
                                  style: TextStyle(
                                    fontFamily: AppConstant.fontRegular,
                                    fontSize: 15,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          res.isDivert=="1"?Expanded(
                            flex: 2,
                            child: Text(
                              res.deliveryDate ?? "",
                              style: TextStyle(
                                  fontFamily: AppConstant.fontRegular,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red),
                            ),
                          ):
                          (res.subscriptionType == "old")
                              ? Expanded(
                                  flex: 2,
                                  child: Text(
                                    res.deliveryDate ?? "",
                                    style: TextStyle(
                                        fontFamily: AppConstant.fontRegular,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red),
                                  ),
                                )
                              : Expanded(
                                  flex: 2,
                                  child: Text(
                                    (res.ordertype == "package")
                                        ? "( ${res.fromDate} To \n${res.toDate} )" ??
                                            ""
                                        : res.deliveryDate ?? "",
                                    style: TextStyle(
                                        fontFamily: AppConstant.fontRegular,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Pickup Time:",
                                  style: TextStyle(
                                    fontFamily: AppConstant.fontRegular,
                                    fontSize: 15,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              res.pickupTime ?? "",
                              style: TextStyle(
                                  fontFamily: AppConstant.fontRegular,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            Res.ic_dinner,
                            width: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          (res.subscriptionType == "old")
                              ? Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Package : ${res.packageName}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily:
                                                  AppConstant.fontRegular,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          "${res.orderItems}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily:
                                                  AppConstant.fontRegular,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      (res.ordertype == "package")
                                          ? "${res.menuFor}"
                                          : "${res.orderItems}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: AppConstant.fontRegular,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            width: 10,
                          ),
                          InkResponse(
                            onTap: () {
                              viewOrder10(
                                  isUpcomingOrder:
                                      res.subscriptionType == "old",
                                  context: context,
                                  orderId: res.orderId.toString(),
                                  orderItemsId: res.orderitemsId.toString(),
                                  subscriptionType:
                                      res.subscriptionType.toString(),
                                  pickupTime: res.pickupTime.toString(),
                                  orderNumber: res.orderNumber!);
                            },
                            child: Card(
                              elevation: 13,
                              shadowColor: AppConstant.appColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                                //set border radius more than 50% of height and width to make circle
                              ),
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        width: 2.0, color: Colors.orange),
                                  ),
                                  child: Text(
                                    "View Order",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.orange,
                                        fontFamily: AppConstant.fontRegular,
                                        fontWeight: FontWeight.w600),
                                  )),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              rejectDialog(
                                  orderNumber: res.orderNumber.toString(),
                                  orderID: res.subscriptionType == "old"
                                      ? res.orderitemsId
                                      : res.orderId,
                                  subscriptionType: res.subscriptionType,
                                  context: context);
                            },
                            child: const Text(
                              'REJECT',
                              style: TextStyle(
                                  letterSpacing: 1,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  fontFamily: AppConstant.fontRegular),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () {
                              acceptDialog(
                                  orderNumber: res.orderNumber.toString(),
                                  orderID: res.subscriptionType == "old"
                                      ? res.orderitemsId
                                      : res.orderId,
                                  subscriptionType: res.subscriptionType,
                                  context: context);
                            },
                            child: const Text(
                              'ACCEPT',
                              style: TextStyle(
                                  letterSpacing: 1,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  fontFamily: AppConstant.fontRegular),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                InkResponse(
                    onTap: () async {
                      Navigator.pop(context);
                      if (newDataList.isNotEmpty) {
                        List<RequestData1> withoutLastElement =
                            List.from(newDataList);
                        withoutLastElement.removeLast();

                        showActiveRequestsDialog(
                            context: context,
                            res: newDataList.last,
                            newDataList: withoutLastElement);
                      } else {
                        final sp = await SharedPreferences.getInstance();
                        sp.setInt("length", activeRequestsList.length);
                        openDialog = false;
                        return;
                      }
                    },
                    child: Icon(
                      Icons.cancel,
                      size: 35,
                      color: Colors.red,
                    )),
              ],
            ),
          ),
        );
      });
}

openActiveRequests(BuildContext context) async {
  BeanGetOrderRequest? res = await ApiProvider().getOrderRequest();
  final sp = await SharedPreferences.getInstance();
  var length = sp.getInt("length") ?? 0;
  print("sp get length = ${length}");
  print("sp openDialog= ${openDialog}");
  if (res!.status == true) {
    activeRequestsList = res!.data!.toList();
    print("Res length = ${activeRequestsList.length}");
    if (activeRequestsList.isNotEmpty) {
      if (activeRequestsList.length > length) {
        List<RequestData1> withoutLastElement = List.from(activeRequestsList);
        withoutLastElement.removeLast();
        if (openDialog == false) {
          showActiveRequestsDialog(
              context: context,
              res: activeRequestsList.last,
              newDataList: withoutLastElement);
        }
      } else {
        sp.setInt("length", activeRequestsList.length);
        print("sp set length = ${activeRequestsList.length}");

        return;
      }
    }
  } else {
    return;
  }
}

Future<BeanGetOrderRequest> getOrderRequest2(BuildContext context) async {
//new
  BeanLogin? userBean = await Utils.getUser();
  FormData from = FormData.fromMap({
    "kitchen_id": userBean.data!.id,
    "token": "123456789",
  });
  BeanGetOrderRequest? bean = await ApiProvider().getOrderRequest();
  if (bean!.status == true) {
 //   print("***********************GET ORDER REQUEST CALL*****************************");

    int? lenght = await getOrdersRequestCount();

    if (bean.data!.length > (lenght ?? 0)) {
      // for(int i=0;i<bean.data!.length;i++)//{
    }
    return bean;
  } else {
    return bean;
  }
}

List localOrders = [];
List localRemoveOrders = [];
int currentIndex = 0;
List snapshotsData = [];
bool isShowItems = false;
String selectedValue = "ITEMS";

void closeDialog(BuildContext context) {
  Navigator.of(context).maybePop();
}

acceptDialog({
  required String orderNumber,
  required orderID,
  required subscriptionType,
  required context,
}) {
  return showDialog(
    context: context,
    barrierColor: Color(0x18000000),
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
            // SizedBox(height: 15,),
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
              " Are you sure you want \n to accept this order?",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: AppConstant.fontBold, fontSize: 18),
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
                  onTap: () async {
                    orderAccepted(orderID, subscriptionType, context)
                        .then((value) {
                      successfullyacceptDialog(orderNumber, context);
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
              height: 24,
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
    required context}) {
  return showDialog(
    context: context,
    barrierColor: Color(0x18000000),
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Container(
          //height: 200,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    Res.ic_cross_image,
                    fit: BoxFit.fill,
                    width: 12,
                    height: 12,
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
              " Are you sure you want \n to reject the order ?",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: AppConstant.fontBold, fontSize: 18),
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
                  onTap: () async {
                    orderRejected(orderID, subscriptionType, context)
                        .then((value) {
                      successfullyrejactDialog(orderNumber, context);
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

Future<BeanOrderAccepted?> orderAccepted(
    String orderId, String subscriptionType, context) async {
  BeanLogin userBean = await Utils.getUser();

  FormData from = FormData.fromMap({
    "kitchen_id": userBean.data!.id,
    "token": "123456789",
    "order_id": orderId,
    "subscription_type": subscriptionType
  });
  BeanOrderAccepted? bean =
      await ApiProvider().orderAccept(orderId, subscriptionType);

  //stopRing();
  if (bean.status == true) {
    print(
        "++++++++++++++++++++++++++++++${bean.status}+++++++++++++++++++++++++++++++++");
    Navigator.of(context, rootNavigator: true).pop();
    return bean;
  } else {
    throw Exception("Something went wrong");
  }
  return null;
}

Future<BeanOrderRejected?> orderRejected(
    String orderId, String subscriptionType, context) async {
  BeanOrderRejected? bean =
      await ApiProvider().orderReject(orderId, subscriptionType);

  //stopRing();
  if (bean.status == true) {
    print(
        "++++++++++++++++++++++++++++++${bean.status}+++++++++++++++++++++++++++++++++");
    Navigator.of(context, rootNavigator: true).pop();
    return bean;
  } else {
    throw Exception("Something went wrong");
  }
  return null;
}

successfullyrejactDialog(String orderNumber, context) {
  return showDialog(
    context: context,
    barrierColor: Color(0x18000000),
    barrierDismissible: false,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeBaseScreen()),
          (Route<dynamic> route) => false,
        );
        openDialog = false;
      });
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Container(
          //height: 200,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    Res.ic_cross_image,
                    fit: BoxFit.fill,
                    width: 12,
                    height: 12,
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

successfullyacceptDialog(String orderNumber, context) {
  return showDialog(
    context: context,
    barrierColor: Color(0x18000000),
    barrierDismissible: false,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeBaseScreen()),
          (Route<dynamic> route) => false,
        );
        openDialog = false;
      });
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Container(
          //height: 200,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    Res.ic_cross_image,
                    fit: BoxFit.fill,
                    width: 12,
                    height: 12,
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

viewOrder10(
    {required BuildContext context,
    required String orderId,
    required bool isUpcomingOrder,
    required String orderItemsId,
    required String subscriptionType,
    required String pickupTime,
    required String orderNumber}) async {
  GetOrderDetailsData? orderDetails;

  orderDetails =
      await getOrderDetails(context, orderId, orderItemsId).then((value) {
    /*setState(() {
      //isViewLoading = false;
    });*/
    return value;
  });

  return orderDetails != null
      ? showDialog<void>(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return Scaffold(
              body: Container(
                // height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(width: 2.0, color: Colors.orange),
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
                                  fontFamily: AppConstant.fontRegular,
                                  color: Colors.black),
                            ),
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
                                  fontFamily: AppConstant.fontRegular,
                                  color: Colors.black),
                            ),
                          ),
                          Text(
                            "${orderDetails.customerName}",
                            style:
                                TextStyle(fontFamily: AppConstant.fontRegular),
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
                                          fontFamily: AppConstant.fontRegular,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red),
                                    ),
                                    Text(
                                      "${orderDetails.order_delivery_date}",
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontRegular,
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
                        width: 10,
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        width: double.infinity,
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
                            orderDetails.itemsDetail!.isEmpty
                                ? Text(
                                    orderDetails.packageName.toString(),
                                    style: TextStyle(
                                        fontFamily: AppConstant.fontRegular),
                                  )
                                : ListView.builder(
                                    itemCount: orderDetails.itemsDetail?.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
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
                                      "Special Instructions : ${orderDetails.specialInstruction ?? "N/A"}"),
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
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    rejectDialog(
                                      context: context,
                                      orderNumber: orderNumber,
                                      orderID: subscriptionType == "old"
                                          ? orderItemsId
                                          : orderId,
                                      subscriptionType: subscriptionType,
                                    );
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 110,
                                    margin:
                                        EdgeInsets.only(left: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 242, 106, 96),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "REJECT",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: AppConstant.fontBold),
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
                                        context: context);
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 10, bottom: 10),
                                    height: 40,
                                    width: 110,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 118, 214, 121),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "ACCEPT",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: AppConstant.fontBold),
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
            );
          },
        )
      : Container();
}

Future<GetOrderDetailsData?> getOrderDetails(
    BuildContext context, String orderId, String orderItemId) async {
  try {
    BeanLogin user = await Utils.getUser();
    GetOrderDetailsData? bean = await ApiProvider()
        .getOrderDetails(orderId: orderId, orderItemId: orderItemId);
    print("===================>$bean");
    // setState(() {
    //   isViewLoading = false;
    // });
    return bean;
  } on HttpException catch (exception) {
    print(exception);
  } catch (exception) {}
  return null;
}
