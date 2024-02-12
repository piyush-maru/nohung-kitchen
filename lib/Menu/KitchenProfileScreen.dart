import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kitchen/Menu/BasePackageScreen.dart';
import 'package:kitchen/Menu/KitchenDetailScreen.dart';
import 'package:kitchen/const/size_const.dart';
import 'package:kitchen/model/getKitchenStatus.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/network/OrderRepo/order_request_model.dart';
import 'package:kitchen/network/dashboard_model.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/src/presentation/screens/AccountScreen.dart';
import 'package:kitchen/src/presentation/screens/DashboardScreen.dart';
import 'package:kitchen/src/presentation/screens/HomeBaseScreen.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/KitchenData/BeanGetDashboard.dart';
import '../model/KitchenData/BeanLogin.dart';
import '../model/KitchenData/GetAccountDetail.dart';
import '../network/kitchen_screen_repo.dart';
import '../src/presentation/screens/CustomerChatScreen.dart';
import '../src/presentation/screens/MenuCategory.dart';

class MenuDetailScreen extends StatefulWidget {
  @override
  _MenuDetailScreenState createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isKitchenActive = true;
  var flag = 1;
  Future? future;
  var name = "";
  var email = "";
  var kitchenId = '';
  var address = "";
  var time = "";
  var document = "";
  var menu = "";
  var days = "";
  var profileImage = "";
  var typeOfFood;
  var description = "";
  var rating = 0.0;
  BeanLogin? userBean;
  KitchenStatus? bean;
  bool isPageLoading = true;
  List<dynamic> meals = [];
  GetAccountDetails? kitchenDetails;
  List<DateTime> dateLength = [];
  List<String> day1 = [];
  List<String> meal1 = [];
  List<String> food = [];
  Timer? timer;

  late TextEditingController controller = TextEditingController();
  final url = Uri.parse('https://nohungtesting.com/kitchen/my-account');

  @override
  void initState() {
    super.initState();
    getAccountDetailss(context);
    Future.delayed(Duration.zero, () async {
      setState(() {
        getDashboard();
        final kitchenRepo =
            Provider.of<KitchenDetailsModel>(context, listen: false);
        kitchenRepo.getAccountDetails();
        getAccountDetailss(context);
      });
    });

    setState(() {
      openDialog = false;
    });

    const twentyMillis = Duration(seconds: 2); //20
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

  Future<void> updateKitchenStatus(value) async {
    var userBean = await Utils.getUser();
    // FormData form = FormData.fromMap({
    //   "token": "123456789",
    //   "status": value == true ? "1" : "0",
    //   "kitchen_id": userBean.data!.id.toString(),
    // });
    KitchenStatus? bean = await ApiProvider()
        .updateKitchenAvailability(value == true ? "1" : "0");
    // bean = await ApiProvider().updateKitchenAvailability(form);
    if (bean.status == true) {
      Utils.showToast(bean.message ?? "", context);
      setState(() {
        isKitchenActive1 = value;
      });
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<void> _pullRefresh() async {
    final kitchenRepo =
        Provider.of<KitchenDetailsModel>(context, listen: false);

    await Future.delayed(Duration.zero, () {
      setState(() {
        kitchenRepo.getAccountDetails();
        getAccountDetailss(context);
      });
    });
  }

  Future<GetAccountDetails> getAccountDetailss(BuildContext context) async {
    var userBean = await Utils.getUser();
    //FormData from =
    //FormData.fromMap({"user_id": userBean.data!.id, "token": "123456789"});
    GetAccountDetails bean = await ApiProvider().getAccountDetails();

    if (bean.status!) {
      setState(() {
        var kitchenStatus = bean.data!.availableStatus!;
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

  @override
  Widget build(BuildContext context) {
    MySize().init(
      context,
    );

    final dashboardModel = Provider.of<DashboardModel>(context, listen: false);
    final kitchenRepo =
        Provider.of<KitchenDetailsModel>(context, listen: false);
    return Scaffold(
      drawer: MyDrawers(),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.only(right: 12),
          alignment: Alignment.centerRight,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(
              onPressed: () async {
                List<DateTime> dates = (await kitchenRepo.getOfflineDates())
                    .data
                    .map((e) => e.date)
                    .toList();
                calendarPicker(dates);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white70),
              ),
              child: Text(
                "Select Offline Dates",
                style: TextStyle(
                    fontFamily: AppConstant.fontRegular, color: Colors.black),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Transform.scale(
              scale: 1.5,
              child: Switch(
                value: isKitchenActive,
                onChanged: (value) {
                  setState(() {
                    dashboardModel.getHomeScreen();
                    //getDashboard();
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
          ]),
        ),
        elevation: 0,
        backgroundColor: AppConstant.appColor,
        leading: InkWell(
          onTap: () {
            setState(() {
              _scaffoldKey.currentState!.openDrawer();
            });
          },
          child: Image.asset(Res.ic_menu, width: 25, height: 20),
        ),
      ),
      body: new RefreshIndicator(
        onRefresh: _pullRefresh,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: FutureBuilder<GetAccountDetails?>(
              future: kitchenRepo.getAccountDetails(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  day1 = snapshot.data!.data!.openDays!;
                  if (snapshot.data!.data!.openDays!.length == 8) {
                    day1.removeAt(0);
                  }
                }

                if (snapshot.data != null) {
                  meal1 = snapshot.data!.data!.typeOfMeals!;
                  if (snapshot.data!.data!.typeOfMeals!.length == 3) {
                    meal1.removeAt(0);
                    print("0000000000000000=>${meal1}");
                  }
                }
                if (snapshot.data != null) {
                  food = snapshot.data!.data!.typeofFood!;
                  if (snapshot.data!.data!.typeofFood!.length == 2) {
                    food.removeAt(0);
                  }
                }

                return snapshot
                        .hasData /*snapshot.connectionState == ConnectionState.done &&
                        snapshot.data != null*/
                    ? /*LayoutBuilder(
                    builder: (_, c) {
                      final width = c.maxWidth;
                      var fontSize = 10.0;
                      if (width <= 380) {
                        fontSize = 8.0;
                      } if (width < 380 && width <= 480) {
                        fontSize = 10.0;
                      } else if (width > 480 && width <= 960) {
                        fontSize = 12.0;
                      }else if (width > 350 && width <= 640) {
                        fontSize = 11.0;
                      }else if (width > 380 && width <= 844) {
                        fontSize = 11.5;
                      } else {
                        fontSize = 12.0;
                      }//360x640
                      return*/
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 40.5,
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(snapshot
                                      .data!.data!.profileImage
                                      .toString()),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 12, right: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  snapshot.data!.data!.kitchenName
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: AppConstant.fontBold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12, right: 12),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Kitchen ID : ${snapshot.data!.data!.kitchenid!}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: AppConstant.fontBold),
                                  ),
                                  RatingBarIndicator(
                                    rating: double.parse(snapshot
                                        .data!.data!.totalrating!
                                        .toString()),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Row(children: [
                              SvgPicture.asset(
                                Res.spoon,
                                color: Colors.black,
                                height: 20,
                              ),
                              Container(
                                height: 14,
                                child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(left: 12),
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        snapshot.data!.data!.typeOfFood!.length,
                                    itemBuilder: (context, index) {
                                      return Text(
                                        " ${snapshot.data!.data!.typeOfFood![index].toString().replaceAll('[', '').replaceAll(']', '') + ","}",
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: MySize.size12,
                                            fontFamily: AppConstant.fontRegular,
                                            overflow: TextOverflow.visible),
                                      );
                                    }),
                              ),

                              /*Container(
                                height: 20,
                                padding: EdgeInsets.only(left: 12),
                                child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.data!.typeOfFood!.length,
                                    itemBuilder: (context, idx1) {
                                      return Text(
                                        " ${snapshot.data!.data!.typeOfFood![idx1].toString().replaceAll('[', '').replaceAll(']', '') + ","}",
                                        style: TextStyle(color: Colors.grey, fontSize: MySize.size12 */ /*fontSize+2*/ /* */ /*12*/ /*, fontFamily: AppConstant.fontRegular),
                                      );
                                    }),
                              ),*/
                            ]),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Icon(Icons.location_on),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    snapshot.data!.data!.address.toString(),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize:
                                            MySize.size15 /*fontSize+2*/ /*12*/,
                                        fontFamily: AppConstant.fontRegular),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12, top: 12),
                            child: Container(
                              height: 20,
                              child: FittedBox(
                                child: Row(children: [
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "Timings -",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: MySize.size12 /*fontSize*/,
                                          fontFamily: AppConstant.fontRegular),
                                    ),
                                  ),
                                  for (int i = 0;
                                      i <
                                          snapshot
                                              .data!.data!.shiftTiming!.length;
                                      i++)
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        "${snapshot.data!.data!.shiftTiming![i].fromTime == "-" ? "" : snapshot.data!.data!.shiftTiming![i].fromTime} - ${snapshot.data!.data!.shiftTiming![i].toTime == "-" ? "" : snapshot.data!.data!.shiftTiming![i].toTime} ",
                                        softWrap: true,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              MySize.size12 /*fontSize*/, //12
                                          fontFamily: AppConstant.fontRegular,
                                        ),

                                        /* ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: snapshot.data!.data!.shiftTiming!.length,
                                            itemBuilder: (context, idx2) {
                                              return Container(
                                                alignment: Alignment.center,
                                                color: Colors.red,
                                                height: 20,
                                                child: Text(
                                                  "${snapshot.data!.data!.shiftTiming![idx2].fromTime == "-" ? "" : snapshot.data!.data!.shiftTiming![idx2].fromTime} - ${snapshot.data!.data!.shiftTiming![idx2].toTime == "-" ? "" : snapshot.data!.data!.shiftTiming![idx2].toTime} ",
                                                  softWrap: true,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: MySize.size12*/ /*fontSize*/ /*, //12
                                                    fontFamily: AppConstant.fontRegular,
                                                  ),
                                                ),
                                              );
                                            }),*/
                                      ),
                                    ),
                                ]),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 12,
                            ),
                            child: Container(
                              height: 16,
                              child: FittedBox(
                                child: Row(
                                  children: [
                                    for (int i = 0;
                                        i <
                                            snapshot
                                                .data!.data!.openDays!.length;
                                        i++)
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          i == 8
                                              ? day1.isEmpty
                                                  ? ""
                                                  : day1.isNotEmpty
                                                      ? "${day1[i].replaceAll("[", "").replaceAll("]", "") + " , "}"
                                                      : ""
                                              : snapshot
                                                      .data!.data!.openDays![i]
                                                      .replaceAll("[", "")
                                                      .replaceAll("]", "") +
                                                  " , ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: MySize.size12,
                                              /*fontSize*/ /*11*/
                                              fontFamily:
                                                  AppConstant.fontRegular),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          /*Container(
                            height: 20,
                            width: double.infinity,
                            color: Colors.red,
                            padding: EdgeInsets.only(left: 12, right: 4),
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.data!.openDays!.length,
                                itemBuilder: (context, idx3) {
                                  day1 = snapshot!.data!.data!.openDays!;
                                  if (day1.length == 8) {
                                    day1.removeAt(0);
                                    setState(() {});

                                  }
                                  return FittedBox(
                                    //fit: BoxFit.fitWidth,
                                    child: Text(
                                      idx3 == 8
                                          ? day1 == null
                                              ? ""
                                              : day1.isNotEmpty
                                                  ? "${day1![idx3].replaceAll("[", "").replaceAll("]", "") + " , "}"
                                                  : ""
                                          : snapshot.data!.data!.openDays![idx3].replaceAll("[", "").replaceAll("]", "") + " , ",
                                      style: TextStyle(color: Colors.black, fontSize: MySize.size12, */ /*fontSize*/ /* */ /*11*/ /* fontFamily: AppConstant.fontRegular),
                                    ),
                                  );
                                }),
                          ),*/
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xffF3F6FA),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 24),
                              child: Text(
                                snapshot.data!.data!.description.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: AppConstant.fontRegular,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push<void>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BasePackageScreen(
                                          fromSettings: true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 90,
                                    width: 90,
                                    margin: EdgeInsets.only(
                                        left: 10, right: 4, top: 20),
                                    decoration: BoxDecoration(
                                      color: Color(0xffF3F6FA),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Image.asset(
                                            Res.ic_packages_default,
                                            width: 60,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, top: 16),
                                          child: Text(
                                            "PACKAGES",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    AppConstant.fontBold,
                                                fontSize: 10),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push<void>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            MenuCategoryScreen(false),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 90,
                                    width: 90,
                                    margin: EdgeInsets.only(
                                        left: 4, right: 4, top: 20),
                                    decoration: BoxDecoration(
                                      color: Color(0xffF3F6FA),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Image.asset(
                                            Res.ic_menu_detail,
                                            width: 60,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, top: 16),
                                          child: Text(
                                            "MENU",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    AppConstant.fontBold,
                                                fontSize: 10),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    //alertDialog();
                                    Navigator.push<void>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => KitchenDetailScreen(
                                          accDetails: kitchenDetails,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 90,
                                    width: 90,
                                    margin: EdgeInsets.only(
                                        left: 4, right: 4, top: 20),
                                    decoration: BoxDecoration(
                                      color: Color(0xffF3F6FA),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Image.asset(
                                            Res.ic_other_info,
                                            width: 60,
                                            height: 40,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, top: 6),
                                          child: Text(
                                            "KITCHEN INFO",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    AppConstant.fontBold,
                                                fontSize: 10),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push<void>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AccountScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 90,
                                    width: 90,
                                    margin: EdgeInsets.only(
                                        left: 4, right: 7, top: 20),
                                    decoration: BoxDecoration(
                                      color: Color(0xffF3F6FA),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Icon(
                                            Icons.settings,
                                            size: 24,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, top: 16),
                                          child: Text(
                                            "SETTINGS",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    AppConstant.fontBold,
                                                fontSize: 10),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Container(
                            height: 120,
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 16),
                            decoration: BoxDecoration(
                              color: Color(0xffF3F6FA),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Type of Meals",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: AppConstant.fontBold,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.symmetric(vertical: 6),
                                        scrollDirection: Axis.horizontal,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.data!.typeOfMeals!.length,
                                        itemBuilder: (context, index) {
                                          if(meal1[0]=="Select All"){
                                            meal1[index]="";
                                          }

                                         if(snapshot.data!.data!.typeOfMeals!.length==3){
                                            meal1.removeAt(0);
                                            setState(() {});
                                          }
                                         int i=index;
                                          //snapshot.data!.data!.typeOfMeals!.length==5?snapshot.data!.data!.typeOfMeals!.removeAt(0):snapshot.data!.data!.typeOfMeals!.length-1;
                                          return Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                padding:  EdgeInsets.only(right:index == meal1.length - 1?0:20.0),
                                                child: Column(
                                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: meal1[index]==""?SizedBox():Image.asset(
                                                        index == 6
                                                            ? meal1.isEmpty
                                                                ? ""
                                                                : meal1.isNotEmpty
                                                                    ? meal1[index]
                                                                    : ""
                                                            : mealIcon(meal1[index]/*snapshot
                                                                .data!
                                                                .data!
                                                                .typeOfMeals![index]*/),
                                                        width: 30,
                                                        height: 30,
                                                      ),
                                                    ),
                                                    Text(
                                                      index == 6
                                                          ? meal1.isEmpty
                                                              ? ""
                                                              : meal1.isNotEmpty
                                                                  ? meal1[index]
                                                                  : ""
                                                          : meal1[index]/*snapshot.data!.data!
                                                              .typeOfMeals![index]*/,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              AppConstant.fontRegular,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.symmetric(vertical: 6),
                                        scrollDirection: Axis.horizontal,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.data!.typeofFood!.length,
                                        itemBuilder: (context, index) {
                                          if(food[0]=="Both"){
                                            food[index]="";
                                          }
                                          if(snapshot.data!.data!.typeofFood!.length==2){
                                            food.removeAt(0);
                                            setState(() {});
                                          }
                                          //snapshot.data!.data!.typeofFood!.length==3?snapshot.data!.data!.typeofFood!.removeAt(0):snapshot.data!.data!.typeofFood!.length;
                                          return Row(
                                           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                padding:  EdgeInsets.only(left:index == meal1.length !- 1?20:0, right: 20.0),
                                                child: Column(
                                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Center(
                                                      child: food[index]==""?SizedBox():Image.asset(
                                                        index == 5
                                                            ? meal1.isEmpty
                                                                ? ""
                                                                : meal1.isNotEmpty
                                                                    ? meal1[index]
                                                                    : ""
                                                            : foodIcon(food[index]/*snapshot
                                                                .data!
                                                                .data!
                                                                .typeofFood![index]*/),
                                                        width: 30,
                                                        height: 30,
                                                      ),
                                                    ),
                                                    Text(
                                                      index == 6
                                                          ? meal1.isEmpty
                                                              ? ""
                                                              : meal1.isNotEmpty
                                                                  ? meal1[index]
                                                                  : ""
                                                          : snapshot.data!.data!
                                                              .typeofFood![index],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              AppConstant.fontRegular,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AppConstant().navBarHt()
                        ],
                      ) /*;})*/
                    : Center(
                        child: CircularProgressIndicator(
                          color: AppConstant.appColor,
                        ),
                      );
              }),
        ),
      ),
    );
  }

// void _handleSelectionChanged(CalendarSelectionDetails details) {
//   setState(() {
//     _selectedDates = details.selectedDates;
//   });
// }

  List<DateTime> _selectedDates = [];

  calendarPicker(List<DateTime> initialSelectedDates) {
    final kitchenRepo =
        Provider.of<KitchenDetailsModel>(context, listen: false);
    _selectedDates = initialSelectedDates;

    final List<DateTime> selectedDays = [];
    Map<int, List<DateTime>> selectedDaysByMonth = {};
    for (DateTime day in selectedDays) {
      int month = DateTime(day.year, day.month).millisecondsSinceEpoch;
      if (selectedDaysByMonth.containsKey(month)) {
        setState(() {
          selectedDaysByMonth[month]!.add(day);
        });
      } else {
        setState(() {
          selectedDaysByMonth[month] = [day];
        });
      }
    }
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text(
                        "Select Offline Dates",
                        style: TextStyle(fontFamily: AppConstant.fontRegular),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.cancel),
                      ),
                    ],
                  ),
                  SfDateRangePicker(
                      enablePastDates: true,
                      showNavigationArrow: true,
                      todayHighlightColor:
                          AppConstant.appColor.withOpacity(0.5),
                      headerStyle: DateRangePickerHeaderStyle(
                        backgroundColor: AppConstant.appColor,
                        textStyle:
                            TextStyle(fontFamily: AppConstant.fontRegular),
                      ),
                      selectionColor: AppConstant.appColor,
                      view: DateRangePickerView.month,
                      initialSelectedDates: initialSelectedDates,
                      minDate: DateTime.now(),
                      rangeTextStyle:
                          TextStyle(fontFamily: AppConstant.fontRegular),
                      selectionTextStyle:
                          TextStyle(fontFamily: AppConstant.fontRegular),
                      monthViewSettings:
                          DateRangePickerMonthViewSettings(firstDayOfWeek: 7),
                      selectionMode: DateRangePickerSelectionMode.multiple,
                      headerHeight: 30,
                      showActionButtons: false,
                      //true
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs dateArgs) {
                        setState(() {});
                        _selectedDates = dateArgs.value;
                        //daysSelected = _selectedDates.length;
                        setState(() {});

                        // });
                        SchedulerBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          setState(() {});
                        });
                      },
                      onCancel: () {
                        Navigator.pop(context);
                        //_datePickerController.selectedRanges = null;
                      }),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.only(left: 12, right: 12, bottom: 24),
                    child: Row(
                        key: UniqueKey(),
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Total No.of \nDays Closed:  ${_selectedDates.length}",
                            style: TextStyle(
                                fontFamily: AppConstant.fontBold, fontSize: 20),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              List<int> dayList = _selectedDates
                                  .map((dateTime) => dateTime.day)
                                  .toList();
                              dayList.sort();

                              // List<int> monthList = _selectedDates.map((dateTime) => dateTime.month).toList();
                              // List<int> uniw = monthList.toSet().toList();

                              List<int> yearList = _selectedDates
                                  .map((dateTime) => dateTime.year)
                                  .toList();
                              List<int> uniy = yearList.toSet().toList();
                              // List<String> monthNames = uniw
                              //     .map(
                              //       (month) => DateFormat('MMMM').format(
                              //         DateTime(2023, month),
                              //       ),
                              //     )
                              //     .toList();

                              Map<int, List<DateTime>> selectedDaysByMonth = {};

                              _selectedDates.forEach((dateTime) {
                                if (!selectedDaysByMonth
                                    .containsKey(dateTime.month)) {
                                  selectedDaysByMonth[dateTime.month] =
                                      <DateTime>[];
                                }
                                selectedDaysByMonth[dateTime.month]!
                                    .add(dateTime);
                              });

                              selectedDaysByMonth.keys
                                  .toList()
                                  .forEach((month) {
                                selectedDaysByMonth[month];
                              });

                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // Future.delayed(Duration(seconds: 1), () {
                                    //   Navigator.of(context).pop(true);
                                    // });
                                    return GestureDetector(
                                      child: Dialog(
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(12),
                                          height: 250,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: Text(
                                                      "Are you sure you want off \n    the kitchen on ",
                                                      style: TextStyle(
                                                          color: AppConstant
                                                              .appColor,
                                                          fontSize: 16,
                                                          fontFamily:
                                                              AppConstant
                                                                  .fontBold),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  IconButton(
                                                    icon: Icon(
                                                        Icons.cancel_outlined),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  SizedBox(width: 6)
                                                ],
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        // Build a list of ListTile widgets for each month

                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: ListView
                                                                  .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      physics:
                                                                          NeverScrollableScrollPhysics(),
                                                                      scrollDirection:
                                                                          Axis
                                                                              .vertical,
                                                                      itemCount: selectedDaysByMonth
                                                                          .keys
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        List<int> dayList = selectedDaysByMonth
                                                                            .values
                                                                            .toList()[
                                                                                index]
                                                                            .map((dateTime) =>
                                                                                dateTime.day)
                                                                            .toList();
                                                                        dayList
                                                                            .sort();
                                                                        return Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Container(
                                                                                //color: Colors.red,
                                                                                //width: 70,
                                                                                margin: EdgeInsets.only(right: 24),
                                                                                padding: EdgeInsets.only(bottom: 12),
                                                                                child: Text(
                                                                                  "${selectedDaysByMonth.keys.toList()[index] == 1 ? "January " : selectedDaysByMonth.keys.toList()[index] == 2 ? "February " : selectedDaysByMonth.keys.toList()[index] == 3 ? "March " : selectedDaysByMonth.keys.toList()[index] == 4 ? "April " : selectedDaysByMonth.keys.toList()[index] == 5 ? "May " : selectedDaysByMonth.keys.toList()[index] == 6 ? "June " : selectedDaysByMonth.keys.toList()[index] == 7 ? "July " : selectedDaysByMonth.keys.toList()[index] == 8 ? "August " : selectedDaysByMonth.keys.toList()[index] == 9 ? "September " : selectedDaysByMonth.keys.toList()[index] == 10 ? "October " : selectedDaysByMonth.keys.toList()[index] == 11 ? "November " : "December "}" +
                                                                                      "$uniy - ".replaceAll("[", "").replaceAll("]", ""),
                                                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500 /*20/fontFamily: AppConstant.fontBold*/),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            //SizedBox(width: 8),
                                                                            Expanded(
                                                                              child: Container(
                                                                                alignment: Alignment.topLeft,
                                                                                //color: Colors.red,
                                                                                margin: EdgeInsets.only(left: 24),
                                                                                padding: EdgeInsets.only(bottom: 12),
                                                                                child: Text(
                                                                                  "${dayList}".replaceAll("[", "").replaceAll("]", ""),
                                                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      }),
                                                            ),
                                                            /* Expanded(
                                                    child: ListView.builder(
                                                        physics: NeverScrollableScrollPhysics(),
                                                        scrollDirection: Axis.vertical,
                                                        shrinkWrap: true,
                                                        itemCount: selectedDaysByMonth.keys.length,
                                                        itemBuilder: (context, index) {
                                                          List<int> dayList = selectedDaysByMonth.values.toList()[index].map((dateTime) => dateTime.day).toList();
                                                          dayList.sort();
                                                          return Container(
                                                            //alignment: Alignment.bottomLeft,
                                                            color: Colors.red,
                                                            margin: EdgeInsets.only(left: 24),
                                                            padding: EdgeInsets.only(bottom: 12),
                                                            child: Text(
                                                              "${dayList}".replaceAll("[", "").replaceAll("]", ""),
                                                              style: TextStyle( fontWeight: FontWeight.w500, fontSize: 16),
                                                            ),
                                                          );
                                                        }),
                                                  ),*/
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 24,
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors.red),
                                                    ),
                                                    child: Text(
                                                      "NO",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              AppConstant
                                                                  .fontRegular),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);

                                                      await kitchenRepo
                                                          .addOfflineDates(
                                                              _selectedDates)
                                                          .then((value) {});
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                                  Colors.green),
                                                    ),
                                                    child: Text(
                                                      "YES",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              AppConstant
                                                                  .fontRegular),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppConstant.appColor),
                            ),
                            child: Text(
                              "SAVE",
                              style: TextStyle(
                                  fontFamily: AppConstant.fontRegular),
                            ),
                          )
                        ]),
                  )
                ]),
              );
            },
          );
        });
  }

  void onSelectionChanged(DateRangePickerSelectionChangedArgs dateArgs) {
    _selectedDates = dateArgs.value;

    // });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  alertDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 300,
            padding: EdgeInsets.all(12),
            child: Column(children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "Please Click the link",
                style:
                    TextStyle(fontFamily: AppConstant.fontBold, fontSize: 20),
              ),
              SizedBox(
                height: 12,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Colors.orange,
                  ),
                ),
                onPressed: () async {
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text(
                  'LINK',
                  style: TextStyle(fontFamily: AppConstant.fontRegular),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "Or Contact",
                style:
                    TextStyle(fontFamily: AppConstant.fontBold, fontSize: 20),
              ),
              SizedBox(
                height: 12,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Colors.orange,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/adminChat');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerChatScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'CHAT',
                    style: TextStyle(fontFamily: AppConstant.fontRegular),
                  ),
                ),
                SizedBox(
                  width: 45,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                  ),
                  onPressed: () {
                    _makePhoneCall("+917672057570");

                    //Navigator.of(context).pop();
                    // Navigator.pop(context, true);
                    // Navigator.pop(context, true);
                  },
                  child: Text(
                    'CALL',
                    style: TextStyle(fontFamily: AppConstant.fontRegular),
                  ),
                )
              ])
            ]),
          ),
        );
      },
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  String mealIcon(String meal) {
    switch (meal) {
      case 'Breakfast':
        return Res.ic_breakfast;
      case 'Lunch':
        return Res.ic_breakfast;
      case 'Dinner':
        return Res.ic_dinner;
      default:
        return "";
    }
  }

  String foodIcon(String food) {
    switch (food) {
      case 'Veg':
        return Res.ic_veg;
      case 'Non Veg':
        return Res.ic_chiken;
      default:
        return ""; //Res.ic_cross;//Res.ic_chiken
    }
  }

  Future<BeanGetDashboard?> getDashboard() async {
    try {
      var userBean = await Utils.getUser();
      //FormData from = FormData.fromMap({"kitchen_id": userBean.data!.id, "token": "123456789"});
      BeanGetDashboard? bean = await ApiProvider().beanGetDashboard();

      if (bean.status == true) {
        if (bean.data != null) {
          isKitchenActive1 = bean.data!.availableStatus == '1' ? true : false;
        }

        setState(() {});

        return bean;
      } else {
        throw Exception("Something went wrong");
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<GetAccountDetails?> getAccountDetails() async {
    try {
      var user = await Utils.getUser();
      //FormData from = FormData.fromMap({"user_id": user.data!.id.toString(), "token": "123456789"});
      GetAccountDetails bean = await ApiProvider().getAccountDetails();

      if (bean.status == true) {
        setState(() {
          name = bean.data!.kitchenName!;
          address = bean.data!.address!;
          email = bean.data!.email!;
          kitchenId = bean.data!.kitchenid!;
          menu = bean.data!.menufile!;
          document = bean.data!.documentfile!;
          profileImage = bean.data!.profileImage!;
          typeOfFood = bean.data!.typeOfFood!;
          days = bean.data!.openDays.toString();
          time = bean.data!.shiftTiming![0].fromTime! +
              "  to  " +
              bean.data!.shiftTiming![0].toTime!;
          meals = bean.data!.typeOfMeals!;
          description = bean.data!.description!;
          if (bean.data!.totalrating!.isNotEmpty) {
            rating = double.parse(bean.data!.totalrating!);
          }
        });
        return bean;
      } else {
        throw Exception("Something went wrong");
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  editScreen(GetAccountDetails value) async {
    var data = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KitchenDetailScreen(
          accDetails: value,
        ),
      ),
    );
    if (data != null) {
      //future = getAccountDetails();
    }
  }
}

bool isKitchenActive1 = true;
