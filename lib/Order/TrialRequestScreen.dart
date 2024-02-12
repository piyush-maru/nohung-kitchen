import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/main.dart';

import 'package:kitchen/model/BeanOrderAccepted.dart';
import 'package:kitchen/model/BeanOrderRejected.dart';
import 'package:kitchen/model/GetOrderTrialRequest.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';
import 'package:intl/intl.dart';

import '../model/KitchenData/BeanLogin.dart';



class TrialRequestScreen extends StatefulWidget {
  @override
  _TrialRequestScreenState createState() => _TrialRequestScreenState();
}

class _TrialRequestScreenState extends State<TrialRequestScreen> {
  GetOrderTrialRequest? trailRequets;
  BeanLogin? userBean;

  List<GetOrderTrialRequestData> data = [];
  var currentDate = "";
  var userId = "";
  Future getUser() async {
    userBean = await Utils.getUser();
    userId = userBean!.data!.id.toString();
    setState(() {});
  }

  @override
  void initState() {
    getUser().then((value) {
      getCurrentDate();
      getTrialRequest(context).then((value) {
        setState(() {
          trailRequets = value;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: data.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            getOrderList(data[index]),
                            (index + 1 == data.length)
                                ? AppConstant().navBarHt()
                                : SizedBox()
                          ],
                        );
                      },
                      itemCount: data.length,
                    ),
            ),
          ],
        ));
  }

  Widget getOrderList(GetOrderTrialRequestData result) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: result.customerImage == ''
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
                            '${result.customerImage ?? ''}',
                          ),
                        ),
                      ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            result.customerName ?? "",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: AppConstant.fontBold),
                          ),
                          Text(
                            AppConstant.rupee + result.orderAmount!,
                            style: TextStyle(
                                color: AppConstant.lightGreen,
                                fontSize: 16,
                                fontFamily: AppConstant.fontBold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 3),
                      child: Row(
                        children: [
                          Text('${result.orderNumber} | ',
                              style: TextStyle(color: Colors.grey)),
                          Text(
                            "${dateTimeFormat(result.orderDate!, "MMM dd, yyyy")}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: AppConstant.fontRegular),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, top: 10),
                child: Text(
                  "Trail Orders",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: AppConstant.fontRegular),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              // Padding(
              //   padding: EdgeInsets.only(left: 16),
              //   child: Image.asset(
              //     Res.ic_breakfast,
              //     width: 20,
              //     height: 20,
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.only(left: 5),
              //   child: Text(
              //     result.totalBill,
              //     style: TextStyle(
              //         color: Colors.grey,
              //         fontSize: 14,
              //         fontFamily: AppConstant.fontRegular),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Image.asset(
                  Res.ic_dinner,
                  width: 20,
                  height: 25,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(result.orderItems ?? "",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: AppConstant.fontBold,
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(color: Colors.grey),
          ),
          SizedBox(
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(
                children: [
                  Image.asset(
                    Res.ic_loc,
                    width: 20,
                    height: 20,
                    color: AppConstant.lightGreen,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      result.deliveryAddress ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: AppConstant.fontRegular),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  orderRejected(result.orderId!);
                },
                child: Container(
                  height: 40,
                  width: 110,
                  margin: EdgeInsets.only(left: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "REJECT",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: AppConstant.fontBold),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  orderAccepted(result.orderId!);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10, bottom: 10),
                  height: 40,
                  width: 110,
                  decoration: BoxDecoration(
                      color: AppConstant.appColor,
                      borderRadius: BorderRadius.circular(10)),
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
              )
            ],
          ),
          Divider(color: Colors.grey.withOpacity(0.5), thickness: 5)
        ],
      ),
    );
  }

  Future<GetOrderTrialRequest?> getTrialRequest(BuildContext context) async {
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId.toString(),
        "token": "123456789",
        "filter_fromdate": '',
        "filter_todate": "",
        "filter_order_number": ""
      });

      GetOrderTrialRequest? bean = await ApiProvider().geTrialRequest();


      if (bean.status == true) {
        data = bean.data!;
        setState(() {});

        return bean;
      } else {
        Utils.showToast(bean.message ?? "",context);
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {}
    return null;
  }

  Future<BeanOrderAccepted?> orderAccepted(String orderId) async {
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        "token": "123456789",
        "order_id": orderId,
      });
      BeanOrderAccepted? bean = await ApiProvider().orderAccept(orderId,"");
      if (bean.status == true) {
        getTrialRequest(context).then((value) {
          setState(() {
            trailRequets = value;
          });
        });
        return bean;
      } else {
        Utils.showToast(bean.message ?? "",context);
      }
    } on HttpException catch (exception) {

      print(exception);
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<BeanOrderRejected?> orderRejected(String orderId) async {
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        "token": "123456789",
        "order_id": orderId,
      });
      BeanOrderRejected? bean = await ApiProvider().orderReject(orderId,"");
      if (bean.status == true) {
        getTrialRequest(context).then((value) {
          setState(() {
            trailRequets = value;
          });
        });
        return bean;
      } else {
        Utils.showToast(bean.message ?? "",context);
      }
    } on HttpException catch (exception) {

      print(exception);
    } catch (exception) {

      print(exception);
    }
    return null;
  }

  void getCurrentDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    currentDate = formatter.format(now);
    print(currentDate);
  }
}
