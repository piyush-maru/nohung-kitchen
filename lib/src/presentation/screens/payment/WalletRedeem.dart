import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../model/KitchenData/BeanLogin.dart';
import '../../../../model/WalletModel.dart';
import '../../../../network/ApiProvider.dart';
import '../../../../utils/Constants.dart';
import '../../../../utils/Utils.dart';

class WalletRedemption extends StatefulWidget {
  const WalletRedemption({Key? key}) : super(key: key);

  @override
  State<WalletRedemption> createState() => _WalletRedemptionState();
}

class _WalletRedemptionState extends State<WalletRedemption> {
  List<Data> data = [];
  BeanLogin? userBean;

  Future? future;
  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      future = walletRedemption();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            // Row(
            //   children: [
            //     Text(
            //       "Search :",
            //       style: TextStyle(fontFamily: AppConstant.fontRegular),
            //     ),
            //     SizedBox(
            //       width: 12,
            //     ),
            //     // Container(
            //     //     width: MediaQuery.of(context).size.width * 0.75,
            //     //     decoration: BoxDecoration(
            //     //       border: Border.all(width: 1.0, color: Colors.black),
            //     //       shape: BoxShape.rectangle,
            //     //       borderRadius: BorderRadius.circular(6),
            //     //     ),
            //     //     height: 40,
            //     //     child: TextField(
            //     //       controller: searchController,
            //     //       cursorColor: Colors.black,
            //     //       onTap: () {
            //     //         // showSearch(context: context, delegate: SearchData());
            //     //       },
            //     //     )),
            //   ],
            // ),
            data.isEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    alignment: Alignment.center,
                    child: Text(
                      "NO Data",
                      style: TextStyle(fontFamily: AppConstant.fontRegular),
                    ))
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 120),
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) =>
                            walletListView(data[index])))
          ],
        ),
      ),
    );
  }

  walletListView(Data wallets) {
    return Container(
        padding: EdgeInsets.only(left: 12, right: 12, top: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Withdrawal Requested \nDate & Time :",//
                  style: TextStyle(
                      fontFamily: AppConstant.fontBold, color: Colors.black),
                ),
                Spacer(),
                Text(
                  "${wallets.requestedDateTime}",
                  style: TextStyle(
                      fontFamily: AppConstant.fontBold, color: Colors.black),
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Requested Amount :",
                  style: TextStyle(
                      fontFamily: AppConstant.fontBold, color: Colors.black),
                ),
                Spacer(),
                Text(
                  "${wallets.releasedAmount}",
                  style: TextStyle(
                      fontFamily: AppConstant.fontBold, color: Colors.black),
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Requested Dates :",
                  style: TextStyle(
                      fontFamily: AppConstant.fontBold, color: Colors.black),
                ),
                Spacer(),
                Text(
                  "${wallets.requestDates}",
                  style: TextStyle(
                      fontFamily: AppConstant.fontBold, color: Colors.black),
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Commission :",
                  style: TextStyle(
                      fontFamily: AppConstant.fontBold, color: Colors.black),
                ),
                Spacer(),
                Text(
                  "${wallets.commission}",
                  style: TextStyle(
                      fontFamily: AppConstant.fontBold, color: Colors.black),
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "GST On Commission :",
                  style: TextStyle(
                      fontFamily: AppConstant.fontBold, color: Colors.black),
                ),
                Spacer(),
                Text(
                  "${wallets.gstOnCommission}",
                  style: TextStyle(
                      fontFamily: AppConstant.fontBold, color: Colors.black),
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Released Amount :",
                  style: TextStyle(
                      fontFamily: AppConstant.fontBold, color: Colors.black),
                ),
                Spacer(),
                Text(
                  "${wallets.releasedAmount}",
                  style: TextStyle(
                      fontFamily: AppConstant.fontBold, color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Status :",
                  style: TextStyle(
                      fontFamily: AppConstant.fontBold, color: Colors.black),
                ),
                Spacer(),
                ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            wallets.status == "Paid"
                                ? Color(0xFF28A745)
                                : Color(0xFFFFC107))),
                    child: Text(
                      "${wallets.status}",
                      style: TextStyle(
                          fontFamily: AppConstant.fontBold,
                          color: Colors.black),
                    )),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Divider(
              height: 1,
              color: Colors.black,
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ));
  }

  Future<WalletModel?> walletRedemption() async {
    var userBean = await Utils.getUser();
    FormData from = FormData.fromMap({
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
    });
    WalletModel? bean = await ApiProvider().getWallet();

    if (bean.status == true) {
      data = bean.data!;

      setState(() {});

      return bean;
    } else {
      Utils.showToast(bean.message!, context);
    }
    return null;
  }
}
