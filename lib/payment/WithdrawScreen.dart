import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:kitchen/res.dart';
import 'package:provider/provider.dart';

import '../model/Bank Account Data/BeanPayment.dart';
import '../model/Bank Account Data/GetPayment.dart';
import '../model/Bank Account Data/WithDrawAmountModel.dart';
import '../model/KitchenData/BeanLogin.dart';
import '../network/ApiProvider.dart';
import '../network/PaymentRepo/PaymentModel.dart';
import '../utils/Constants.dart';
import '../utils/HttpException.dart';
import '../utils/Utils.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  var amountController = TextEditingController();
  late TextEditingController date;

  List<BeanPayment>? beanPayment;

  Future<GetPayment?>? future;
  String actualAmountRequested = "";
  String _selectedDate = '';
  String _selectedDate2 = 'Select a date';
  DateTime lastDate = DateTime.now();
  String message = "";
  bool isCheckValid = false;
  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    dateInput.text = "";
    super.initState();
    isCheckValid = false;
    final paymentModel =
        Provider.of<TransactionHistoryModel>(context, listen: false);

    future = paymentModel.transactionHistory("1", "");
  }

  void showCustomSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        'Custom Snackbar Message',
        style: TextStyle(color: Colors.pink), // Set pink font color
      ),
      backgroundColor: Colors.red, // Set red background color
      elevation: 6.0, // Set elevation for the snackbar
      behavior: SnackBarBehavior.floating, // Adjust behavior as needed
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Add border radius
        side: BorderSide(color: Colors.black), // Add black border
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Withdraw Amount",
          style: TextStyle(
              fontFamily: AppConstant.fontRegular, color: Colors.black),
        ),
        leading: BackButton(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: AppConstant.appColor,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(12),
        height: 400,
        child: FutureBuilder<GetPayment?>(
            future: future,
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null
                  ? /*Container(
                  height: 500,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child:*/
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 24,
                        ),

                        Row(
                          children: [
                            Text(
                              "Current Balance ".toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              AppConstant.rupee +
                                  snapshot.data!.data.currentBalance,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppConstant.lightGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Row(children: [
                          Text(
                            "From Date:",
                            style:
                                TextStyle(fontFamily: AppConstant.fontRegular),
                          ),
                          SizedBox(
                            width: 115,
                          ),
                          Text(
                            "To Date:",
                            style:
                                TextStyle(fontFamily: AppConstant.fontRegular),
                          ),
                        ]),
                        SizedBox(
                          height: 24,
                        ),
                        Row(children: [
                          Container(
                            height: 50,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 0, right: 10),
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            width: 130,
                            child: Text(
                              "${snapshot.data!.data.withdrawalFromDate.day}/${snapshot.data!.data.withdrawalFromDate.month}/${snapshot.data!.data.withdrawalFromDate.year}",
                              style: TextStyle(
                                  fontFamily: AppConstant.fontRegular,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          GestureDetector(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDatePickerMode: DatePickerMode.day,

                                firstDate: snapshot.data!.data
                                    .withdrawalFromDate, //DateTime(2000),
                                initialDate: DateTime.now().subtract(
                                  Duration(days: 1),
                                ),
                                lastDate: lastDate.subtract(
                                  Duration(days: 1),
                                ),
                              );
                              if (picked != null)
                                setState(() {
                                  _selectedDate2 =
                                      DateFormat('dd/MM/yyyy').format(picked);
                                  //date = val as DateTime;
                                  _selectedDate = picked.toString();
                                  setState(() {
                                    _selectedDate = "";
                                    _selectedDate = picked.toString();
                                    isCheckValid = false;
                                  });

                                  // actualAmountRequested = res.data.withdrawalAmount.
                                });

                              final res = await getWithdrawPayment(
                                  context,
                                  snapshot.data!.data.withdrawalFromDate,
                                  picked.toString());
                              setState(() {
                                amountController.text = res!.data.withdrawalAmount;
                                actualAmountRequested = res.data.actual_requested_amount;
                              });

                              _selectedDate = picked.toString()!;
                            },
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 0, right: 10),
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              width: 130,
                              child: Text(
                                _selectedDate2,
                                style: TextStyle(
                                    fontFamily: AppConstant.fontRegular,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ]),
                        isCheckValid && _selectedDate.isEmpty
                            ? Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 59.0, top: 4),
                                  child: Text(
                                    "Please select to date!",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.red),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 24,
                        ),

                        // InkWell(
                        //   child:  Text(
                        //       _selectedDate == null
                        //           ? "Select Date"
                        //           : '${DateFormat.yMMMd().format(_selectedDate!)}',
                        //       style: TextStyle(
                        //           fontFamily: AppConstant.fontRegular),
                        //     ),
                        //   onTap: () {
                        //     setState(() {
                        //       _selectDate1(context);
                        //     });
                        //   },
                        // ),
                        SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          maxLines: 1,
                          autofocus: false,
                          controller: amountController,
                          keyboardType: TextInputType.none,
                          decoration: InputDecoration(
                            labelText: 'Withdraw Amount',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        isCheckValid && amountController.text.isEmpty ||
                                isCheckValid && amountController.text == "0.00"
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  "Please enter withdrawal amount !",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.red),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        if (actualAmountRequested.isNotEmpty)
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Actual Requested Amount :  ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "₹ ${actualAmountRequested}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),

                        SizedBox(
                          height: 24,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                "Send Message".toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                 // print("amountController=================>${amountController.text}");
                                 // print("isCheckValid=================>${isCheckValid}");
                                 // print("amountController.text=================>${amountController.text}");
                                  isCheckValid = true;
                                });
                                if (_selectedDate.isNotEmpty && amountController.text.isEmpty || isCheckValid && amountController.text == "0.00" || actualAmountRequested == "0.00")
                                {
                                  print("_selectedDate========if=========>${_selectedDate}");
                                  print("nikhil colonial ");
                                  BeanPayment? bean = await ApiProvider()
                                      .beanPayment(
                                          amountController.text,
                                          snapshot.data!.data.withdrawalFromDate
                                              .toString(),
                                          _selectedDate,actualAmountRequested.toString());
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.2,
                                            // height: MediaQuery.of(context).size.height / 4,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 25),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset:
                                                          const Offset(12, 26),
                                                      blurRadius: 50,
                                                      spreadRadius: 0,
                                                      color: Colors.grey
                                                          .withOpacity(.1)),
                                                ]),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                bean.message=="Fill all required fields."?
                                                SvgPicture.asset(
                                                  'assets/images/document_image.svg',
                                                  width: 50,
                                                )
                                                    :bean.message=="Withdrawal request has been sent successfully."?//Withdrawal request has been sent successfully.
                                                SvgPicture.asset(
                                                  'assets/images/email_image.svg',
                                                  width: 55,
                                                  height: 55,
                                                )
                                                    :bean.message=="Your Previous request is under process !"?
                                                SvgPicture.asset(
                                                  'assets/images/message_image.svg',
                                                  width: 50,
                                                  height: 50,
                                                )
                                                    :bean.message=="On selected dates there are active orders, could you please check with NOHUNG spport team !"?
                                                SvgPicture.asset(
                                                  'assets/images/warning_image.svg',
                                                  width: 60,
                                                  height: 60,
                                                )
                                                    :SizedBox(),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(bean.message.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold)),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                /*InkWell(
                                                    child: Text(
                                                      "Go back!",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    }),*/
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }
                                else {
                                  print("_selectedDate=================>${_selectedDate}");
                                  print("_selectedDate=================>${actualAmountRequested}");
                                  BeanPayment? bean = await ApiProvider()
                                      .beanPayment(
                                          amountController.text,
                                          snapshot.data!.data.withdrawalFromDate
                                              .toString(),
                                          _selectedDate,actualAmountRequested.toString());
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.2,
                                            // height: MediaQuery.of(context).size.height / 4,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 25),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset:
                                                          const Offset(12, 26),
                                                      blurRadius: 50,
                                                      spreadRadius: 0,
                                                      color: Colors.grey
                                                          .withOpacity(.1)),
                                                ]),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                               /* const CircleAvatar(
                                                  backgroundColor:
                                                      AppConstant.appColor,
                                                  radius: 25,
                                                  child: Icon(
                                                      Icons.priority_high,
                                                      color: Color(0xffffffff)),
                                                ),*/
                                               bean.message=="Fill all required fields."?
                                               SvgPicture.asset(
                                                 'assets/images/document_image.svg',
                                                 width: 50,
                                               )
                                                   :bean.message=="Withdrawal request has been sent successfully."?
                                               SvgPicture.asset(
                                                 'assets/images/email_image.svg',
                                                 width: 55,
                                                 height: 55,
                                               )
                                                   :bean.message=="Your Previous request is under process !"?
                                               SvgPicture.asset(
                                                 'assets/images/message_image.svg',
                                                 width: 50,
                                                 height: 50,
                                               )
                                                   :bean.message=="On selected dates there are active orders, could you please check with NOHUNG Support Team !"?
                                                SvgPicture.asset(
                                                  'assets/images/warning_image.svg',
                                                  width: 60,
                                                  height: 60,
                                                )
                                                    :SizedBox(),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(bean.message.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                /*InkWell(
                                                    child: Text(
                                                      "Go back!",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    }),*/
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }
                              },
                            )
                          ],
                        ),
                      ],
                    )
                  : SizedBox();
            }),
      ),
    );
  }

  /*showAlertDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
<<<<<<< HEAD
                alignment: Alignment.center,
                padding: EdgeInsets.all(12),
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      message=="Fill all required fields"?"Amount Cant be 0":message,
                      style: TextStyle(
                          fontFamily: AppConstant.fontBold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("OK"))
                  ],
                )),
=======
              alignment: Alignment.center,
              padding: EdgeInsets.all(12),
              height: 200,
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Text(
                  message,
                  style: TextStyle(
                      fontFamily: AppConstant.fontBold, color: Colors.black),
                ),

                SizedBox(height: 12,),
                ElevatedButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text("OK"))
              ],)

            ),

          );
        });
  }*/

  Future<WithdrawAmount?> getWithdrawPayment(
      BuildContext context, fromDate, toDate) async {
    try {
      //FormData from = FormData.fromMap({"kitchen_id": userBean.data!.id, "token": "123456789", "from_date": fromDate, "to_date": _selectedDate});
      WithdrawAmount? bean = await ApiProvider()
          .getWithdrawAmount(fromDate.toString(), toDate.toString());

      if (bean.status == true) {
        amountController.text = bean.data.withdrawalAmount;
        actualAmountRequested = bean.data.actual_requested_amount;
        //Navigator.pop(context);
        // setState(() {});
        return bean;
      } else {
        Utils.showToast(bean.message, context);
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<BeanPayment?> withdrawPayment(
      String amount, BuildContext context, fromDate) async {
    BeanLogin userBean = await Utils.getUser();
    FormData from = FormData.fromMap({
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
      "withdraw_amount": amount,
      "actual_amount": actualAmountRequested,
      "from_date": fromDate,
      "to_date": _selectedDate
    });

    BeanPayment? bean =
        await ApiProvider().beanPayment(amount, fromDate, _selectedDate,actualAmountRequested.toString());
    if (bean.status == true) {
      // Navigator.pop(context);

      return bean;
    } else {
      message = bean.message.toString();
      nohungSupportDialog();
      /* ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppConstant.appColor,
          duration: Duration(seconds: 5),
          closeIconColor: Colors.white,
          onVisible: () {
            //Navigator.pop(context);
          },
          elevation: 20.0,
          showCloseIcon: true,
          content: Container(
           // height: 30,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
            child: Text(
              amountController.text == "0.00"
                  ? "Amount cant be 0"
                  : bean.message ?? "",
              style: TextStyle(fontFamily: AppConstant.fontBold, fontSize: 20),
            ),
          ),
        ),
      );*/
      return null;
    }
  }

  nohungSupportDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });
        return Dialog(
          child: Container(
            //height: 200,
            //width:double.infinity,
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
                Res.ic_nohung_support_error_image,
                fit: BoxFit.fill,
                //width: 16,
                height: 170,
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 5),
                child: Text(
                  "$message",
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: AppConstant.fontRegular,
                      color: Colors.red,
                      fontSize: 14),
                ),
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
      GetPayment? bean = await ApiProvider().getPay(page.toString());

      if (bean.status == true) {
        setState(() {});

        return bean;
      } else {
        Utils.showToast(bean.message.toString(), context);
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {
      print(exception);

      return null;
    }
    return null;
  }
}
