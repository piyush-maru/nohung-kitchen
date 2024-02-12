import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/network/OrderRepo/order_request_model.dart';
import 'package:kitchen/network/PaymentRepo/PaymentModel.dart';
import 'package:kitchen/payment/WithdrawScreen.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/src/presentation/screens/DashboardScreen.dart';
import 'package:kitchen/src/presentation/screens/HomeBaseScreen.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';
import 'package:provider/provider.dart';

import '../model/Bank Account Data/BeanAddAccount.dart';
import '../model/Bank Account Data/GetPayment.dart';
import '../model/Bank Account Data/bankAccountsModel.dart';
import '../model/KitchenData/BeanLogin.dart';
import 'TransactionHistory.dart';
import 'WalletRedeem.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

enum BestTutorSite { too_busy, food_not_available, shop_closed, others }

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var accountName = TextEditingController();
  var bank = TextEditingController();
  var ifscCode = TextEditingController();
  var accountNumber = TextEditingController();
  var amountController = TextEditingController();
  var date = TextEditingController();
  TabController? _tabController;
  BeanLogin? userBean;
  var userId = "";
  var currentBalance = '';
  var account = '';
  List<Transaction> data = [];
  Transaction? transaction;
  String? dateTime;
  DateTime fromDate = DateTime.now();
  BankAccountsModel? banks;
  Timer? timer;

  DateTime toDate = DateTime.now();
  bool isToDateSelected = false;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  @override
  void initState() {
    final paymentModel =
        Provider.of<TransactionHistoryModel>(context, listen: false);
    paymentModel.transactionHistory("1", "");
    getBankAccounts(context);
    getPayment(context, 1);
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    final paymentModel =
        Provider.of<TransactionHistoryModel>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawers(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppConstant.appColor,
        leading: GestureDetector(
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
        title: Text(
          "Payment",
          style: TextStyle(fontFamily: AppConstant.fontRegular),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<GetPayment?>(
          future: paymentModel.transactionHistory("1", ""),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Current Balance :",
                            style: TextStyle(
                                color: AppConstant.appColor,
                                fontSize: 18,
                                fontFamily: AppConstant.fontRegular),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            AppConstant.rupee +
                                snapshot.data!.data.currentBalance,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: AppConstant.fontBold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 12,
                          ),
                          InkWell(
                            onTap: () {
                              addAccountDetail();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 13, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Text(
                                accountNumber.text.isEmpty
                                    ? "Add Account Details"
                                    : "View Account Details",
                                style: TextStyle(
                                    color: AppConstant.appColor,
                                    fontSize: 13,
                                    fontFamily: AppConstant.fontBold),
                              ),
                            ),
                          ),
                          /*ElevatedButton(
                            onPressed: () {
                              addAccountDetail();
                            },
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                Size(150, 50),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                            ),
                            child: Text(
                              accountNumber.text.isEmpty
                        ? "Add Account Details"
                        :
                              "Edit Account Details",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: AppConstant.fontBold),
                            ),
                          ),*/
                          SizedBox(
                            width: 12,
                          ),
                          accountNumber.text.isEmpty
                              ? SizedBox()
                              : InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WithdrawScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 13, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: AppConstant.appColor,
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: Text(
                                      "Withdraw Payment",
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontRegular,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                          /*ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WithdrawScreen(),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppConstant.appColor),
                              fixedSize: MaterialStateProperty.all(
                                Size(150, 50),
                              ),
                            ),
                            child: Text(
                              "Withdraw Money",
                              style: TextStyle(
                                  fontFamily: AppConstant.fontRegular),
                            ),
                          ),*/
                          SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      TabBar(
                        //indicator: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(
                        //     10.0,
                        //   ),
                        //   color: AppConstant.appColor,
                        // ),
                        isScrollable: true,
                        labelStyle: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        indicatorSize: TabBarIndicatorSize.label,
                        controller: _tabController,
                        labelColor: AppConstant.appColor,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: AppConstant.appColor,
                        tabs: [
                          Tab(
                            text: 'Transaction History',
                          ),
                          Tab(
                            text: 'Wallet redemption History',
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            TransactionHistory(
                              prospects: data,
                            ),
                            WalletRedemption()
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      "Loading",
                      style: TextStyle(fontFamily: AppConstant.fontRegular),
                    ),
                  );
          }),
    );
  }

  void addAccountDetail() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 6,
            backgroundColor: Colors.transparent,
            child: _dialogWithTextField(context),
          );
        });
  }

  Widget _dialogWithTextField(BuildContext context) => Container(
        // height: 400,//450
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
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
              SizedBox(height: 16),
              Text(
                "view Account Detail".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
                child: TextFormField(
                  maxLines: 1,
                  autofocus: false,
                  readOnly: true,
                  controller: accountName,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Account Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, right: 15, left: 15),
                child: TextFormField(
                  maxLines: 1,
                  autofocus: false,
                  readOnly: true,
                  controller: bank,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Bank',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, right: 15, left: 15),
                child: TextFormField(
                  maxLines: 1,
                  controller: ifscCode,
                  autofocus: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'IFSC CODE',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, right: 15, left: 15),
                child: TextFormField(
                  readOnly: true,
                  maxLines: 1,
                  autofocus: false,
                  controller: accountNumber,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Account Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              /* Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.appColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(108.0),
                      ),
                    ),
                    child: Text(
                      "Save Details".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      validation(context);
                      // return Navigator.of(context).pop(true);
                    },
                  )
                ],
              ),*/
            ],
          ),
        ),
      );

  Future<BankAccountsModel?> getBankAccounts(BuildContext context) async {
    try {
      var userBean = await Utils.getUser();
      FormData from = FormData.fromMap(
          {"kitchen_id": userBean.data!.id, "token": "123456789"});
      BankAccountsModel bean = await ApiProvider().getBankAccounts();

      if (bean.status!) {
        if (bean.data != null) {
          setState(() {
            banks = bean;
            accountNumber.text = banks!.data![0].accountNumber!;
            accountName.text = banks!.data![0].accountName!;
            bank.text = banks!.data![0].bankName!;
            ifscCode.text = banks!.data![0].ifscCode!;
          });
        }

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

  Future EditBank(BuildContext context) async {
    var bean = await ApiProvider().editBankAccount(
        accountName.text, bank.text, ifscCode.text, accountNumber.text);

    if (bean['status']) {
      if (bean["data"] != null) {
        setState(() {
          Navigator.pop(context);
          getBankAccounts(context);
        });
      }

      return bean;
    } else {
      Utils.showToast(bean["message"], context);
    }
  }

  Future<GetPayment?> getPayment(
    BuildContext context,
    int page,
  ) async {
    // progressDialog!.show();
    try {
      var userBean = await Utils.getUser();
      FormData from = FormData.fromMap({
        "kitchen_id": userBean.data!.id,
        "token": "123456789",
        "page_no": page
      });
      GetPayment? bean = await ApiProvider().getPay("1");

      if (bean.status == true) {
        data = bean.data.transaction;
        currentBalance = bean.data.currentBalance;
        fromDate = bean.data.withdrawalFromDate;
        setState(() {});

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

  void validation(BuildContext context) {
    if (accountName.text.isEmpty) {
      Utils.showToast("Please Enter Account Name", context);
    } else if (bank.text.isEmpty) {
      Utils.showToast("Please Enter Bank Name", context);
    } else if (ifscCode.text.isEmpty) {
      Utils.showToast("Please Enter IFSC Code", context);
    } else if (accountNumber.text.isEmpty) {
      Utils.showToast("Please Enter Account Number", context);
    } else {
      addAccount(context);
    }
  }

  Future<BeanAddAccount?> addAccount(BuildContext context) async {
    try {
      var userBean = await Utils.getUser();
      FormData from = FormData.fromMap({
        "kitchen_id": userBean.data!.id,
        "token": "123456789",
        "account_name": accountName.text.toString(),
        "bank_name": bank.text.toString(),
        "ifsc_code": ifscCode.text.toString(),
        "account_number": accountNumber.text.toString(),
      });
      BeanAddAccount? bean = await ApiProvider().beanAddAccount(
          accountName.text, bank.text, ifscCode.text, accountNumber.text);

      if (bean.status == true) {
        Utils.showToast(bean.message ?? "", context);

        Navigator.pop(context);

        setState(() {});

        return bean;
      } else {
        Utils.showToast(bean.message ?? '', context);
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  // void withdrawAmountDialog() {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(50),
  //           ),
  //           elevation: 6,
  //           backgroundColor: Colors.transparent,
  //           child: dialog(context),
  //         );
  //       });
  // }

  // Widget dialog(BuildContext context) {
  //   final paymentModel =
  //       Provider.of<TransactionHistoryModel>(context, listen: false);
  //
  //   return ;
  // }

  /*void _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
            fieldHintText: "Select Date",
            fieldLabelText: "Select Date",
            helpText: "Select Date",
            context: context,
            initialDate: fromDate,
            initialDatePickerMode: DatePickerMode.day,
            firstDate: fromDate,
            keyboardType: TextInputType.none,
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {}
      setState(() {
        //_selectedDate = value;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(),
          ),
        );
        Navigator.pop(context);
      });
    });
    // if (picked != null && picked != fromDate) {
    //   setState(() {
    //
    //     toDate = picked;
    //     getWithdrawPayment(context);
    //     Navigator.pop(context);
    //     // _dateController.text = DateFormat.yMd().format(selectedDate);
    //   });
    // }
  }*/
}
