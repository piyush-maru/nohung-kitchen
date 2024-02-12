import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kitchen/Menu/BasePackageScreen.dart';
import 'package:kitchen/network/OrderRepo/order_request_model.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/src/presentation/screens/DashboardScreen.dart';
import 'package:kitchen/src/presentation/screens/HomeBaseScreen.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:provider/provider.dart';

class PackageScreen extends StatefulWidget {
  @override
  _PackageScreenState createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var isSelected = 1;
  var isSelectMenu = 1;
  var isSelectFood = 2;
  var isMealType = 1;
  var isSelectedNorth = 1;
  bool isMenu = true;
  bool saveMenuSelected = false;
  bool addMenu = false;
  TabController? _controller;
  var addDefaultIcon = true;
  var addPack = false;
  var setMenuPackage = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
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
    _controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawers(),
      backgroundColor: AppConstant.appColor,
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
              margin: EdgeInsets.only(top: 120),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(38),
                      topLeft: Radius.circular(38))),
              height: double.infinity,
              child: method()),
          Column(children: [
            Container(
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  InkWell(
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
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16, top: 60),
                        child: Text(
                          "Package",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: AppConstant.fontBold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              height: 150,
            ),
          ]),
        ],
      ),
    );
  }

  method() {
    return BasePackageScreen();
  }

  getList(Choice choic) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                choic.title ?? "",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: AppConstant.fontBold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 36),
              child: Image.asset(
                Res.ic_poha,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Text(
                "Mutter pAneer+3 Roti\n+Dal Fry+Rice+Salad",
                style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 14,
                    fontFamily: AppConstant.fontRegular),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(right: 10),
              width: 50,
              decoration: BoxDecoration(
                  color: AppConstant.appColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Image.asset(
                  Res.ic_plus,
                  width: 15,
                  height: 15,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // getItem() {
  //   return Column(
  //     children: [
  //       Row(
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.only(left: 16),
  //             child: Image.asset(
  //               Res.ic_veg,
  //               width: 15,
  //               height: 16,
  //             ),
  //           ),
  //           SizedBox(
  //             height: 16,
  //           ),
  //           Expanded(
  //               child: Text("Veg",
  //                   style: TextStyle(
  //                       color: Colors.grey,
  //                       fontFamily: AppConstant.fontRegular))),
  //           Padding(
  //             padding: EdgeInsets.only(right: 16),
  //             child: Text(
  //               "inStock",
  //               style: TextStyle(
  //                   color: Colors.grey, fontFamily: AppConstant.fontRegular),
  //             ),
  //           )
  //         ],
  //       ),
  //       SizedBox(
  //         height: 16,
  //       ),
  //       ListView.builder(
  //         shrinkWrap: true,
  //         scrollDirection: Axis.vertical,
  //         physics: BouncingScrollPhysics(),
  //         itemBuilder: (context, index) {
  //           return getListFood();
  //         },
  //         itemCount: 15,
  //       )
  //     ],
  //   );
  // }
  //
  // Widget getListFood() {
  //   return InkWell(
  //     onTap: () {},
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             SizedBox(
  //               width: 16,
  //             ),
  //             Row(
  //               children: [
  //                 SizedBox(
  //                   width: 16,
  //                 ),
  //                 Image.asset(
  //                   Res.ic_idle,
  //                   width: 55,
  //                   height: 55,
  //                   fit: BoxFit.cover,
  //                 ),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Padding(
  //                         child: Text(
  //                           "Poha",
  //                           style: TextStyle(
  //                               fontFamily: AppConstant.fontBold,
  //                               color: Colors.black),
  //                         ),
  //                         padding: EdgeInsets.only(left: 16),
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.only(left: 16),
  //                         child: Text(AppConstant.rupee + "124",
  //                             style: TextStyle(
  //                                 fontFamily: AppConstant.fontBold,
  //                                 color: Color(0xff7EDABF))),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                   height: 30,
  //                   width: 30,
  //                   margin: EdgeInsets.only(right: 20, top: 10),
  //                   child: CupertinoSwitch(
  //                     activeColor: Color(0xff7EDABF),
  //                     value: _isSouthIndianMeal,
  //                     onChanged: (newValue) {
  //                       setState(() {
  //                         _isSouthIndianMeal = newValue;
  //                         if (_isSouthIndianMeal == true) {
  //                         } else {}
  //                       });
  //                     },
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ],
  //         ),
  //         Divider(
  //           color: Colors.grey.shade400,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // getLunchDinnerList() {
  //   return Column(
  //     children: [
  //       Row(
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.only(left: 16),
  //             child: Image.asset(
  //               Res.ic_veg,
  //               width: 15,
  //               height: 16,
  //             ),
  //           ),
  //           SizedBox(
  //             height: 16,
  //           ),
  //           Text("Vegetable",
  //               style: TextStyle(
  //                   color: AppConstant.appColor,
  //                   fontFamily: AppConstant.fontRegular)),
  //         ],
  //       ),
  //       SizedBox(
  //         height: 16,
  //       ),
  //       ListView.builder(
  //         shrinkWrap: true,
  //         scrollDirection: Axis.vertical,
  //         physics: BouncingScrollPhysics(),
  //         itemBuilder: (context, index) {
  //           return getListFood();
  //         },
  //         itemCount: 15,
  //       )
  //     ],
  //   );
  // }
}

class Choice {
  Choice({this.title, this.image});

  String? title;
  String? image;
}

List<Choice> choices = <Choice>[
  Choice(title: 'Monday'),
  Choice(title: 'Tuesday'),
  Choice(title: 'Wednesday'),
  Choice(title: 'Thursday'),
  Choice(title: 'Friday'),
  Choice(title: 'Saturday'),
  Choice(title: 'Sunday'),
];
