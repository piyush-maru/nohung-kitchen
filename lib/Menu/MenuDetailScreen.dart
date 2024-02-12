import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kitchen/Menu/BasePackageScreen.dart';
import 'package:kitchen/Menu/KitchenDetailScreen.dart';
import 'package:kitchen/Order/OrderScreen.dart';
import 'package:kitchen/main.dart';
import 'package:kitchen/model/BeanGetOrderRequest.dart';
import 'package:kitchen/model/getKitchenStatus.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/src/presentation/screens/AccountScreen.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../model/KitchenData/BeanLogin.dart';
import '../model/KitchenData/GetAccountDetail.dart';
import '../src/presentation/screens/HomeBaseScreen.dart';
import '../src/presentation/screens/MenuCategory.dart';

class MenuDetailScreen extends StatefulWidget {
  final bool? currentTablSelected;
  MenuDetailScreen(this.currentTablSelected);
  @override
  _MenuDetailScreenState createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen>
    with WidgetsBindingObserver {
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
  var profileImage;
  var typeOfFood;
  var description;
  var rating = 0.0;
  BeanLogin? userBean;
  KitchenStatus? bean;
  bool isPageLoading = true;
  List<dynamic> meals = [];

  GetAccountDetails? kitchenDetails;
  Timer? timer;
  bool? kitchenStatus = true;
  var userId;
  bool isBackground = false;

  @override
  void initState() {
    getUserData();
    // getOrderRequest(context);
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    if (WidgetsBinding.instance.lifecycleState != null) {
      // _stateHistoryList.add(WidgetsBinding.instance.lifecycleState!);
    }
    // const twentyMillis = Duration(seconds: 20);
    // timer = Timer.periodic(twentyMillis, (timer) {

    //   if(widget.currentTablSelected!){
    //   if (kitchenStatus == true || kitchenStatus == null) {

    //     getOrderRequest(context);
    //     // _future = getOrders(context);
    //   }
    //   } else {
    //     timer.cancel();
    //   }
    // });
    //getAccountDetails();
    Future.delayed(Duration.zero, () {
      future = getAccountDetails().then((value) {
        // setState(() {
        kitchenDetails = value;
        isPageLoading = false;
        // });
      });
    });
  }

  @override
  void dispose() {
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

  Future<dynamic> getOrderRequest(BuildContext context) async {
    try {
      BeanGetOrderRequest? bean = await ApiProvider().getOrderRequest();
      if (bean!.status == true) {
        int? lenght = await getOrdersRequestCount();
        if (bean.data!.length > (lenght ?? 0)) {
          // PerfectVolumeControl.setVolume(1);
          // AudioPlayer().play(AssetSource('notification_sound.mp3'));
          // Navigator.(context, '/orders');
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
        // saveOrdersRequestCount(bean.data.length);
        return bean;
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<void> getUserData() async {
    kitchenStatus = await getKitchenStatus();
    var userBean = await Utils.getUser();
    setState(() {
      userId = userBean.data!.id.toString();
      kitchenStatus = kitchenStatus;
    });
  }

  Future<void> updateKitchenStatus(value) async {
    var userBean = await Utils.getUser();
    name = userBean.data!.kitchenName!;
    menu = userBean.data!.menuFile!;
    FormData form = FormData.fromMap({
      "token": "123456789",
      "status": value ? "1" : "0",
      "kitchen_id": userBean.data!.id.toString(),
    });
    bean = await ApiProvider().updateKitchenAvailability(form);
    if (bean!.status == true) {
      Utils.showToast(bean!.message ?? "", context);
      setState(() {
        isKitchenActive = value;
      });
    } else {
      Utils.showToast(bean!.message ?? "", context);
    }
  }

  Future<void> _pullRefresh() async {
    setState(() async {
      await Future.delayed(Duration.zero, () {
        getAccountDetails();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawers(),
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: new RefreshIndicator(
              onRefresh: _pullRefresh,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 230,
                    child: Stack(
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          child: Image.asset(
                            Res.ic_kitchen_cover,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 40.5,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  profileImage,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(height: 30),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _scaffoldKey.currentState!.openDrawer();
                                      });
                                    },
                                    child: Image.asset(
                                      Res.ic_menu,
                                      width: 25,
                                      height: 20,
                                    ),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        getAccountDetails();
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white)),
                                      child: Text(
                                        "Refresh",
                                        style: TextStyle(
                                            fontFamily: AppConstant.fontRegular,
                                            color: Colors.black),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16, top: 16),
                        child: Text(
                          name.toUpperCase(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: AppConstant.fontBold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16, top: 16),
                        child: Transform.scale(
                          scale: 1.5,
                          child: Switch(
                            value: isKitchenActive,
                            onChanged: (value) {
                              updateKitchenStatus(value);
                            },
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor: Colors.red.shade300,
                            activeColor: Colors.green,
                            activeTrackColor: Colors.green.shade300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, top: 16, bottom: 5),
                    child: Text(
                      "Kitchen ID : $kitchenId",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: AppConstant.fontBold),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            typeOfFood
                                .toString()
                                .replaceAll('[', '')
                                .replaceAll(']', ''),
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: AppConstant.fontRegular),
                          ),
                        ),
                      ),
                      RatingBarIndicator(
                        rating: rating,
                        itemCount: 5,
                        itemSize: 20.0,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                      SizedBox(width: 5)
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      address,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: AppConstant.fontRegular),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          "Timings -",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontFamily: AppConstant.fontRegular),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          time,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: AppConstant.fontRegular),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                        '(' +
                            days
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "") +
                            ')',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: AppConstant.fontRegular)),
                  ),
                  Container(
                    height: 130,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                    decoration: BoxDecoration(
                        color: Color(0xffF3F6FA),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 24),
                      child: Text(
                        description,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: AppConstant.fontRegular,
                            fontSize: 12),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BasePackageScreen(
                                        fromSettings: true,
                                      )),
                            );
                          },
                          child: Container(
                              height: 110,
                              width: 150,
                              margin:
                                  EdgeInsets.only(left: 7, right: 7, top: 20),
                              decoration: BoxDecoration(
                                  color: Color(0xffF3F6FA),
                                  borderRadius: BorderRadius.circular(10)),
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
                                          fontFamily: AppConstant.fontBold,
                                          fontSize: 12),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MenuCategoryScreen(true)),
                            );
                          },
                          child: Container(
                              height: 110,
                              width: 150,
                              margin:
                                  EdgeInsets.only(left: 7, right: 7, top: 20),
                              decoration: BoxDecoration(
                                  color: Color(0xffF3F6FA),
                                  borderRadius: BorderRadius.circular(10)),
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
                                          fontFamily: AppConstant.fontBold,
                                          fontSize: 12),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => KitchenDetailScreen(
                                        accDetails: kitchenDetails,
                                      )),
                            );
                          },
                          child: Container(
                              height: 110,
                              width: 150,
                              margin:
                                  EdgeInsets.only(left: 7, right: 7, top: 20),
                              decoration: BoxDecoration(
                                  color: Color(0xffF3F6FA),
                                  borderRadius: BorderRadius.circular(10)),
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
                                        left: 10, right: 10, top: 16),
                                    child: Text(
                                      "KITCHEN INFO",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: AppConstant.fontBold,
                                          fontSize: 12),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AccountScreen()),
                            );
                          },
                          child: Container(
                              height: 110,
                              width: 150,
                              margin:
                                  EdgeInsets.only(left: 7, right: 7, top: 20),
                              decoration: BoxDecoration(
                                  color: Color(0xffF3F6FA),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Icon(
                                        Icons.settings,
                                        size: 24,
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 16),
                                    child: Text(
                                      "SETTINGS",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: AppConstant.fontBold,
                                          fontSize: 12),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Container(
                      height: 150,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                      decoration: BoxDecoration(
                          color: Color(0xffF3F6FA),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: 16, right: 10, top: 10),
                            child: Text(
                              "Type of Meals",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: AppConstant.fontBold,
                                  fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return getListFood(meals[index]);
                              },
                              itemCount: meals.length,
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  AppConstant().navBarHt()
                ],
              )),
        ));
  }

  Widget getListFood(String meal) {
    var meall = meal;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
              //color: AppConstant.appColor,
              borderRadius: BorderRadius.circular(100)),
          height: 40,
          width: 40,
          child: Center(
            child: Image.asset(
              mealIcon(meall),
              width: 30,
              height: 30,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 10, top: 10),
          child: Text(
            meall,
            style: TextStyle(
                color: Colors.black,
                fontFamily: AppConstant.fontRegular,
                fontSize: 14),
          ),
        ),
      ],
    );
  }

  String mealIcon(String meal) {
    switch (meal) {
      case 'Breakfast':
        return Res.ic_breakfast;
      case 'Lunch':
        return Res.ic_breakfast;
      case 'Dinner':
        return Res.ic_dinner;
      case 'Veg':
        return Res.ic_veg;
      case 'Non-Veg':
        return Res.ic_chiken;
      default:
        return Res.ic_cross;
    }
  }

  Future<GetAccountDetails?> getAccountDetails() async {
    try {
      var user = await Utils.getUser();
      FormData from = FormData.fromMap(
          {"user_id": user.data!.id.toString(), "token": "123456789"});
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
          days = bean.data!.openDays!.toString();
          time = bean.data!.shiftTiming![0].fromTime! +
              "  to  " +
              bean.data!.shiftTiming![0].toTime!;
          meals = bean.data!.typeOfMeals!;
          description = bean.data!.description!;
          if (bean.data!.totalrating!.isNotEmpty!) {
            rating = double.parse(bean.data!.totalrating!);
          }
        });
        return bean;
      } else {
        Utils.showToast(bean.message.toString(), context);
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
                )));
    if (data != null) {
      future = getAccountDetails();
    }
  }
}
