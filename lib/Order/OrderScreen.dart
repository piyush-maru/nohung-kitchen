import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitchen/Order/ActiveScreen.dart';
import 'package:kitchen/Order/OrdersHistory.dart';
import 'package:kitchen/Order/RequestScreen.dart';
import 'package:kitchen/Order/UpcomingScreen.dart';
import 'package:kitchen/Order/live_order_screen.dart';
import 'package:kitchen/main.dart';
import 'package:kitchen/model/GetOrderHistory.dart';
import 'package:kitchen/model/live_order_model.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/src/presentation/screens/HomeBaseScreen.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/Utils.dart';
import 'package:kitchen/utils/constant/ui_constants.dart';
import 'package:provider/provider.dart';
import '../model/BeanGetOrderRequest.dart';
import '../model/GetActiveOrder.dart';
import '../model/GetUpComingOrder.dart';
import '../model/KitchenData/BeanLogin.dart';
import '../network/OrderRepo/active_orders_repo.dart';
import '../network/OrderRepo/order_request_model.dart';
import 'FilterScreen.dart';

class OrderScreen extends StatefulWidget {
  final bool? currentTablSelected;
  final int? index;

  OrderScreen(this.currentTablSelected, this.index);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var isSelected = 0;
  var userId;
  BeanLogin? userBean;
  TabController? _tabController;
  var activeCount;
  var orderRequestCount;
  var upcomingCount;
  //var orderHistoryCount;
  var liveOrderCount;
  Future<GetActiveOrder>? future;
  bool isLodingDesable = false;
  Timer? timer;
  bool? kitchenStatus = true;

  int difference = 0;
  bool isBackground = false;
  List mydata = [];
  List orderHistoryCount = [];
  final Color tabColor = Color.fromRGBO(246, 246, 246, 1);

  @override
  void initState() {
    if(widget.index==4){
      setState(() {
        _tabController?.index=widget.index!;
      });
    }
    print("==============>${widget.index}");
    getUser().then((value) {});
    final activeModel = Provider.of<ActiveOrderModel>(context, listen: false);
    activeModel.getActiveOrders();
    getActiveOrder(context);
    getOrderRequest(context);
    getUpComingOrder(context);
    getOrderHistory(context);
    getLiveOrders(context);


    _tabController = TabController(length: 5, vsync: this);
    if(widget.index==4){
      _tabController?.animateTo(widget.index!.toInt());
    }
    _tabController!.addListener(_handleTabSelection);
    super.initState();
    const twentyMillis = Duration(seconds: 20);
    timer = Timer.periodic(twentyMillis, (timer) {
      if (widget.currentTablSelected!) {
        if (kitchenStatus == true || kitchenStatus == null) {
          final orderRequest = Provider.of<OrderRequestModel>(context, listen: false);
          getOrderRequest(context);
          // _future = getOrders(context);
        } else {
          timer.cancel();
        }
      }
    });
  }

  Future getUser() async {
    userBean = await Utils.getUser();
    userId = userBean!.data!.id.toString();
    setState(() {});
  }

  // To reset all the applied filter.
  void _handleTabSelection() {
    setState(() {

    });
  }
  final Color customColor = Color.fromRGBO(0, 0, 0, 0.16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawers(),
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width*0.50,
          backgroundColor: AppConstant.appColor,
          leading: Row(
            children: [
              SizedBox(width: 14,),
              InkWell(
                  onTap: () {
                    setState(() {
                      _scaffoldKey.currentState!.openDrawer();
                    });
                  },
                  child: Image.asset(
                    Res.ic_menu,
                    width: 22,
                    height: 20,
                    color: Colors.white,
                  )), SizedBox(width: 14,),
              poppinsText(
                  maxLines: 3,
                  txt: "Orders",/*_tabController!.index == 0
                      ? "Request Orders (${orderRequestCount == null ? 0 : orderRequestCount})"
                      : _tabController!.index == 1
                      ? "Active Orders (${activeCount == null ? 0 : activeCount})"
                      : _tabController!.index == 2
                      ? "Upcoming Orders (${mydata.length == null ? 0 : mydata.length})"
                      : "Order History",*/
                  fontSize: 18,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w500),
            ],
          ),
          elevation: 0,
          /*title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FilterScreen()),
                  ).then((value) {
                    setState(() {});
                  });
                },
                child: Image.asset(
                  Res.ic_filter,
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),*/
        ),
        backgroundColor: AppConstant.appColor,
        key: _scaffoldKey,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 70,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black87),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
                child: TabBar(
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                    //color: AppConstant.appColor,
                  ),
                  isScrollable: true,
                  labelStyle:
                  GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                  indicatorSize: TabBarIndicatorSize.label,
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: (_tabController!.index == 0)
                              ? AppConstant.appColor
                              : Colors.grey.withOpacity(0.20),
                          boxShadow: [
                            BoxShadow(
                              color:(_tabController!.index == 0)? Colors.grey:Colors.white,
                              blurRadius: 3.0,
                              offset: Offset(0, 4), // Offset of the shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Center(
                          child: Tab(
                            text: 'Request (${orderRequestCount == null ? 0 : orderRequestCount})',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: (_tabController!.index == 1)
                              ? AppConstant.appColor
                              : Colors.grey.withOpacity(0.20),
                          boxShadow: [
                            BoxShadow(
                              color:(_tabController!.index == 1)? Colors.grey:Colors.white,
                              blurRadius: 3.0,
                              offset: Offset(0, 4), // Offset of the shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Center(
                          child: Tab(
                            text: 'Active (${activeCount == null ? 0 : activeCount})',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: (_tabController!.index == 2)//2
                              ? AppConstant.appColor
                              : Colors.grey.withOpacity(0.20),
                          boxShadow: [
                            BoxShadow(
                              color:(_tabController!.index == 2)? Colors.grey:Colors.white,
                              blurRadius: 3.0,
                              offset: Offset(0, 4), // Offset of the shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Tab(
                          text: 'Upcoming (${mydata.length == null ? 0 : mydata.length})',
                        ),
                      ),
                    ),
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: (_tabController!.index == 3)//3
                              ? AppConstant.appColor
                              : Colors.grey.withOpacity(0.20),
                          boxShadow: [
                            BoxShadow(
                              color:(_tabController!.index == 3)? Colors.grey:Colors.white,
                              blurRadius: 3.0,
                              offset: Offset(0, 4), // Offset of the shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Tab(
                          text: 'Order History',//(${orderHistoryCount.length == null ? 0 : orderHistoryCount.length})
                        ),
                      ),
                    ),
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: (_tabController!.index == 4)
                              ? AppConstant.appColor
                              : Colors.grey.withOpacity(0.20),
                          boxShadow: [
                            BoxShadow(
                              color:(_tabController!.index == 4)? Colors.grey:Colors.white,
                              blurRadius: 3.0,
                              offset: Offset(0, 4), // Offset of the shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Tab(
                          text: 'Today Orders (${liveOrderCount == null ? 0 : liveOrderCount})',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  RequestScreen(/*currentTablSelected:widget.currentTablSelected!*/),
                  ActiveScreen(refreshOrdersCallback: () {setState(() {future = context.read<ActiveOrderModel>().getActiveOrders();});}),
                  UpcomingScreen(),
                  OrdersHistory(),
                  LiveOrders(),
                  // TrialRequestScreen(),
                  //LiveOrdersScreen(),
                  // second tab bar view widget
                ],
              ),
            ),
          ],
        ));
  }

  Future<GetActiveOrder?> getActiveOrder(BuildContext context) async {
    try {
      var userBean = await Utils.getUser();
      FormData from = FormData.fromMap({
        "kitchen_id": userBean.data!.id.toString(),
        "token": "123456789",
        "filter_fromdate": '2021-10-8',
        "filter_todate": "",
        "filter_order_number": ""
      });

      GetActiveOrder? bean = await ApiProvider().getActiveOrder();

      if (bean.status == true) {
        setState(() {
          activeCount = bean.data.length;
        });

        return bean;
      } else {
        print("  286 ${bean.message}");
        // Utils.showToast(bean.message, context);
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {}
    return null;
  }

  /*Future<BeanGetOrderRequest> getOrderRequest(BuildContext context) async {
    var userBean = await Utils.getUser();
    FormData from = FormData.fromMap({
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
    });
    BeanGetOrderRequest bean = await ApiProvider().getOrderRequest();

    if (bean.status==true) {
      setState(() {
       orderRequestCount= bean.data!.length;

      });
    }
    return bean;
  }*/
  /* Future<BeanGetOrderRequest?> getOrderRequest(BuildContext context) async {
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
      if (bean.data!.length > (lenght ?? 0)) {
        if (!isBackground) {//==false
          PerfectVolumeControl.setVolume(1);
          if (bean.data!.first.subscriptionType == "new") {
            // player.play(AssetSource('notification_sound_old.mp3'));
            player.play(AssetSource('notification_sound.mp3'));
          } else {
            player.play(AssetSource('notification_sound.mp3'));
          }
        }
      }
      return bean;
    } else {
      saveOrdersRequestCount(bean.data!.length);
      return bean;
    }
  }*/

  final player = AudioPlayer();
  Future<BeanGetOrderRequest> getOrderRequest(BuildContext context) async {
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
      /*if (bean.data!.length > (lenght ?? 0)) {
        if (!isBackground) {//==false
          PerfectVolumeControl.setVolume(1);
          if (bean.data!.first.subscriptionType == "new") {
            // player.play(AssetSource('notification_sound_old.mp3'));
            player.play(AssetSource('notification_sound.mp3'));
          } else {
            player.play(AssetSource('notification_sound.mp3'));
          }
        }
      }*/
      setState(() {
        orderRequestCount = bean.data!.length;
      });
    }
    return bean;
  }

  Future<GetUpComingOrder?> getUpComingOrder(BuildContext context) async {
    try {
      var userBean = await Utils.getUser();
      FormData from = FormData.fromMap({
        "kitchen_id": userBean.data!.id.toString(),
        "token": "123456789",
        "filter_fromdate": '',
        "filter_todate": "",
        "filter_order_number": ""
      });

      GetUpComingOrder? bean = await ApiProvider().getUpComingOrder();

      if (bean.status == true) {
        setState(() {
          upcomingCount = bean.updata!.length;

          for (int i = 0; i < bean.updata!.length; i++) {
            for (int j = 0; j < bean.updata![i].data!.length; j++) {
              mydata.add(j);
            }
          }
          print("+++++++++++++++++++++upcoming data${mydata.length}");
          print("+++++++++++++++++++++upcoming data${bean.updata!.length}");
        });

        return bean;
      } else {
        print("  416 ${bean.message}");

        // Utils.showToast(bean.message ?? "", context);
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {}
    return null;
  }

  Future<GetOrderHistory?> getOrderHistory(BuildContext context) async {
    try {
      var userBean = await Utils.getUser();
      FormData from = FormData.fromMap({
        "token": "123456789",
        "kitchen_id": userBean.data!.id.toString(),
        "order_status":"all",

      });

      GetOrderHistory? bean = await ApiProvider().getOrderHistory();

      if (bean.status == true) {
       /* setState(() {
          orderHistoryCount = bean.data.orderHistory.length;
          print("-------------------------------------------->${orderHistoryCount}");
        });*/
        setState(() {
          //orderHistoryCount = bean.data![0].orderHistory.length;

          for (int i = 0; i < bean.data![0].orderHistory.length; i++) {
            for (int j = 0; j < bean.data![0].orderHistory.length; j++) {
              orderHistoryCount.add(j);
            }
          }
          print("+++++++++++++++++++++history data${orderHistoryCount.length}");
         // print("+++++++++++++++++++++upcoming data${bean.updata!.length}");
        });

        return bean;
      } else {
        print("  444 ${bean.message}");

        // Utils.showToast(bean.message, context);
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {}
    return null;
  }

  Future<LiveOrderModel1?> getLiveOrders(BuildContext context) async {
    try {
      var userBean = await Utils.getUser();
      FormData from = FormData.fromMap({
        "token": "123456789",
        "kitchen_id": userBean.data!.id,
        "page_no": 1,
        "order_status": "all",
        "order_type": 'all',
      });

      LiveOrderModel1? bean = await ApiProvider().liveOrdesr(/*'all'*/);

      if (bean!.status == true) {
        setState(() {
          liveOrderCount = bean.data!.totalOrders!.toString()==""?"0":bean.data!.totalOrders!.toString();//bean.data!.orders!.length==null?0:bean.data!.orders!.length;
          print("***********************GET LIVE ORDER *****************************${liveOrderCount}");
        });

        return bean;
      } else {
        print("  444 ${bean!.message}");

        // Utils.showToast(bean.message, context);
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {}
    return null;
  }
}
