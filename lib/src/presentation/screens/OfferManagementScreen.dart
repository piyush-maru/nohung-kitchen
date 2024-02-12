import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/model/GetArchiveOffer.dart';
import 'package:kitchen/model/GetLiveOffer.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/network/OrderRepo/order_request_model.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/src/presentation/screens/HomeBaseScreen.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';
import 'package:provider/provider.dart';

import 'AddOfferScreen.dart';
import 'DashboardScreen.dart';
import 'EditOfferScreen.dart';

//new
class OfferManagementScreen extends StatefulWidget {
  @override
  _OfferManagementScreenState createState() => _OfferManagementScreenState();
}

class _OfferManagementScreenState extends State<OfferManagementScreen> {
  var isSelected = 1;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<GetArchieveOffer?>? _future;
  Future<GetLiveOffer?>? futureLive;
  Timer? timer;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _future = getArchieveOffer(context);
      futureLive = getLiveOffers(context);
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawers(),
        key: _scaffoldKey,
        backgroundColor: AppConstant.appColor,
        body: new RefreshIndicator(
          onRefresh: _pullRefresh,
          child: Column(
            children: [
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
                    Padding(
                      padding: EdgeInsets.only(left: 16, top: 10),
                      child: Text(
                        "Offer Management",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ),
                  ],
                ),
                height: 150,
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                height: 55,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white)),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              isSelected = 1;
                            });
                          },
                          child: Container(
                            height: 60,
                            width: 180,
                            decoration: BoxDecoration(
                                color: isSelected == 1
                                    ? Colors.white
                                    : Color(0xffFFA451),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(100),
                                    bottomLeft: Radius.circular(100))),
                            child: Center(
                              child: Text(
                                "Active Promos",
                                style: TextStyle(
                                    color: isSelected == 1
                                        ? Colors.black
                                        : Colors.white,
                                    fontFamily: AppConstant.fontBold),
                              ),
                            ),
                          )),
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              isSelected = 2;
                            });
                          },
                          child: Container(
                            height: 60,
                            width: 180,
                            decoration: BoxDecoration(
                                color: isSelected == 2
                                    ? Colors.white
                                    : Color(0xffFFA451),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(100),
                                    bottomRight: Radius.circular(100))),
                            child: Center(
                              child: Text(
                                "Archives",
                                style: TextStyle(
                                    color: isSelected == 2
                                        ? Colors.black
                                        : Colors.white,
                                    fontFamily: AppConstant.fontBold),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    margin: EdgeInsets.only(top: 20),
                    child: menuSelected()),
              ),
            ],
          ),
        ));
  }

  menuSelected() {
    if (isSelected == 1) {
      return Column(
        children: [
          Expanded(
              child: Stack(
            children: [
              FutureBuilder<GetLiveOffer?>(
                  future: futureLive,
                  builder: (context, projectSnap) {
                    if (projectSnap.connectionState == ConnectionState.done) {
                      var result;
                      if (projectSnap.data != null) {
                        result = projectSnap.data!.data;
                        if (result != null) {
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return getLiveOffer(result[index]);
                            },
                            itemCount: result.length,
                          );
                        }
                      }
                    }
                    return Container(
                        child: Center(
                      child: Text(
                        "No Live Offer",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ));
                  }),
              Positioned.fill(
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding: EdgeInsets.only(right: 16, bottom: 0),
                        child: InkWell(
                          onTap: () {
                            addliveOffer();
                          },
                          child: Image.asset(
                            Res.ic_add_round,
                            width: 65,
                            height: 65,
                          ),
                        ))),
              )
            ],
          )),
          AppConstant().navBarHt()
        ],
      );
    } else {
      return Column(
        children: [
          Expanded(
              child: Stack(
            children: [
              FutureBuilder<GetArchieveOffer?>(
                  future: _future,
                  builder: (context, projectSnap) {
                    if (projectSnap.connectionState == ConnectionState.done) {
                      var result;
                      if (projectSnap.data != null) {
                        result = projectSnap.data!.data;
                        if (result != null) {
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return getArcieveOffer(result[index]);
                            },
                            itemCount: result.length,
                          );
                        }
                      }
                    }
                    return Container(
                        child: Center(
                      child: Text(
                        "No Archeive Offer",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ));
                  }),

              // Positioned.fill(
              //     child: Align(
              //         alignment: Alignment.bottomRight,
              //         child: Padding(
              //             padding: EdgeInsets.only(right: 16,bottom: 16),
              //             child: InkWell(
              //                 onTap: (){
              //                     addArchiveOffer();
              //
              //                 },
              //                 child: Image.asset(Res.ic_add_round,width: 65,height: 65,),
              //             )
              //         )
              //     ),
              // )
            ],
          )),
          AppConstant().navBarHt()
        ],
      );
    }
  }

  getArcieveOffer(result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, bottom: 10, top: 10),
          width: 65,
          decoration: BoxDecoration(
              color: AppConstant.lightGreen,
              borderRadius: BorderRadius.circular(5)),
          height: 25,
          child: Center(
            child: Text(
              "Archieved",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: AppConstant.fontBold,
                  fontSize: 11),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "${result.discounttype == '1' ? ' FLAT ${AppConstant.rupee}${result.discountValue} ' : '${result.discountValue} %'} OFF  \n" +
                      "${result.uptoAmount != "0" ? 'UPTO  ${AppConstant.rupee}${result.uptoAmount}' : ''}",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstant.fontBold,
                      fontSize: 14),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
              width: 65,
              decoration: BoxDecoration(
                  color: Color(0xffBEE8FF),
                  borderRadius: BorderRadius.circular(5)),
              height: 25,
              child: Center(
                child: Text(
                  result.offercode,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstant.fontBold,
                      fontSize: 11),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5),
          child: Text(
            result.title,
            style: TextStyle(
                color: Colors.grey,
                fontFamily: AppConstant.fontBold,
                fontSize: 12),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                result.startdate.toString() + " " + result.enddate.toString(),
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: AppConstant.fontBold,
                    fontSize: 12),
              ),
              GestureDetector(
                onTap: () {
                  addArchiveOffer(result.offerId);
                },
                child: Text('Use again',
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontFamily: AppConstant.fontBold,
                        fontSize: 14)),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Divider(
          thickness: 2,
          color: Colors.grey.shade200,
        ),
      ],
    );
  }

  Future<void> _pullRefresh() async {
    setState(() async {
      await Future.delayed(Duration.zero, () {
        _future = getArchieveOffer(context);
        futureLive = getLiveOffers(context);
      });
    });
  }

  Future<GetArchieveOffer> getArchieveOffer(BuildContext context) async {
    GetArchieveOffer bean = await ApiProvider().getArchieveOffer();

    if (bean.status == true) {
      setState(() {});

      return bean;
    } else {
      return Utils.showToast(bean.message ?? "", context);
    }
  }

  Future<GetLiveOffer?> getLiveOffers(BuildContext context) async {
    var user = await Utils.getUser();
    var id = user.data!.id;
    try {
      FormData from = FormData.fromMap({"user_id": id, "token": "123456789"});
      GetLiveOffer bean = await ApiProvider().getLiveOffers();

      if (bean.status == true) {
        setState(() {});

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

  getLiveOffer(result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              width: 65,
              decoration: BoxDecoration(
                  color: AppConstant.lightGreen,
                  borderRadius: BorderRadius.circular(5)),
              height: 25,
              child: Center(
                child: Text(
                  "LIVE",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstant.fontBold,
                      fontSize: 11),
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      editOffer(result.offerId);
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => EditOfferScreen(offerId :result.offerId)));
                    },
                    icon: Icon(Icons.edit)),
                IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Container(
                            //height: 200,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
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
                                  // SizedBox(height: 15,),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Image.asset(
                                    Res.ic_delete_offer_dialog,
                                    fit: BoxFit.fill,
                                    //width: 16,
                                    height: 150,
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    " Are you sure you want to \ndelete this offer?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: AppConstant.fontBold,
                                        fontSize: 18),
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
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.black,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: Text(
                                              'NO',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily:
                                                      AppConstant.fontRegular),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 24,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          var user = await Utils.getUser();
                                          var id = user.data!.id;
                                          ApiProvider()
                                              .deleteOffer(result.offerId)
                                              .then((value) {
                                            setState(() {
                                              futureLive =
                                                  getLiveOffers(context);
                                            });
                                          });

                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: AppConstant.appColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: Text(
                                              'YES',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily:
                                                      AppConstant.fontRegular),
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

                    /* var user = await Utils.getUser();
                    var id = user.data!.id;
                    ApiProvider().deleteOffer(result.offerId).then((value) {setState(() {
                      futureLive = getLiveOffers(context);
                      });
                    });*/
                  },
                  icon: Icon(Icons.delete),
                )
              ],
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "${result.discounttype == '1' ? ' FLAT ${AppConstant.rupee}${result.discountValue} ' : '${result.discountValue}%'} OFF \n" +
                      "${result.uptoAmount != "0" ? 'UPTO  ${AppConstant.rupee}${result.uptoAmount}' : ''}",
                  // "Get " +
                  //     "${result.discounttype =='1'?' ${AppConstant.rupee}${result.discountValue} ':'${result.discountValue}%'} OFF on your first discount",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstant.fontBold,
                      fontSize: 14),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
              width: 65,
              decoration: BoxDecoration(
                  color: Color(0xffBEE8FF),
                  borderRadius: BorderRadius.circular(5)),
              height: 25,
              child: Center(
                child: Text(
                  result.offercode,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstant.fontBold,
                      fontSize: 11),
                ),
              ),
            ),
          ],
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 5),
              child: Text(
                result.title,
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: AppConstant.fontBold,
                    fontSize: 12),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 5),
              child: Text(
                result.startdate + " " + result.enddate,
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: AppConstant.fontBold,
                    fontSize: 12),
              ),
            ),
          ]),
          Container(
            margin: EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
            width: 65,
            decoration: BoxDecoration(
                color: Color(0xffBEE8FF),
                borderRadius: BorderRadius.circular(5)),
            height: 25,
            child: Center(
              child: Text(
                "${result.countUsage} USED",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: AppConstant.fontBold,
                    fontSize: 11),
              ),
            ),
          ),
        ]),
        SizedBox(
          height: 20,
        ),
        Divider(
          thickness: 2,
          color: Colors.grey.shade200,
        ),
      ],
    );
  }

  addArchiveOffer(String offerId) async {
    var data = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditOfferScreen(offerId: offerId)));
    if (data != null) {
      _future = getArchieveOffer(context);
    }
  }

  addliveOffer() async {
    var data = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddOfferScreen(
        offerId: '',
      ),
    ));
    if (data != null) {
      futureLive = getLiveOffers(context);
    }
  }

  editOffer(offerId) async {
    var data = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditOfferScreen(
        offerId: offerId,
      ),
    ));
    if (data != null) {
      futureLive = getLiveOffers(context);
    }
  }

  deleteOfferDilog() {
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
              // SizedBox(height: 15,),
              SizedBox(
                height: 24,
              ),
              Image.asset(
                Res.ic_delete_offer_dialog,
                fit: BoxFit.fill,
                //width: 16,
                height: 170,
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                " Are you sure you want to \ndelete this offer?",
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
                    onTap: () {},
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
}
