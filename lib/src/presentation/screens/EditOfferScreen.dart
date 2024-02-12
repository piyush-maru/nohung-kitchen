import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kitchen/model/EditOffer.dart';
import 'package:kitchen/model/GetOfferDetail.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';

import '../../../model/KitchenData/BeanLogin.dart';

class EditOfferScreen extends StatefulWidget {
  var offerId;

  EditOfferScreen({this.offerId});

  @override
  _EditOfferScreenState createState() => _EditOfferScreenState();
}

class _EditOfferScreenState extends State<EditOfferScreen> {
  bool isChecked = false;
  bool isPageLoading = true;
  var isSelectB = -1;
  var isSelectL = -1;
  var isSelectD = -1;
  var isSelectON = -1;
  var isRequire = -1;
  var startDate = '';
  var endDate = '';
  var oferTitle = TextEditingController();
  var discountcode = TextEditingController();
  var discountType = TextEditingController();
  var discountValue = TextEditingController();
  var discountUptoValue = TextEditingController();
  var minimumValue = TextEditingController();
  var maximumValue = TextEditingController();
  bool ifMinimumAmount = false;
  var startTime = TextEditingController();
  var endTime = TextEditingController();
  var limit = TextEditingController();
  var description = TextEditingController();
  String? dropdownValue;
  var offercode;
  TimeOfDay selectedTime = TimeOfDay.now();
  List<String> location = ['Percentage', 'Rupees'];
  BeanLogin? userBean;
  var name = "";
  var menu = "";
  var userId = "";

  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() async {
    userBean = await Utils.getUser();
    name = userBean!.data!.kitchenName!;
    menu = userBean!.data!.menuFile!;
    userId = userBean!.data!.id.toString();

    getOfferDetail(context, widget.offerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black,
          ),
          title: Text(
            "Edit Offer",
            style: TextStyle(
                fontFamily: AppConstant.fontRegular, color: Colors.black),
          ),
        ),
        body: isPageLoading
            ? Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()]))
            : SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.only(left: 12, right: 12, bottom: 72),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Offer Title *",
                          style: TextStyle(
                              color: AppConstant.appColor,
                              fontSize: 16,
                              fontFamily: AppConstant.fontRegular),
                        ),
                        TextField(
                          controller: oferTitle,
                          decoration: InputDecoration(hintText: 'Add Title'),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Discount Code *",
                          style: TextStyle(
                              color: AppConstant.appColor,
                              fontSize: 16,
                              fontFamily: AppConstant.fontRegular),
                        ),
                        TextField(
                          controller: discountcode,
                          decoration:
                              InputDecoration(hintText: "Discount Code"),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Discount Type",
                                style: TextStyle(
                                    color: AppConstant.appColor,
                                    fontFamily: AppConstant.fontRegular),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Discount Value *",
                                style: TextStyle(
                                    color: AppConstant.appColor,
                                    fontFamily: AppConstant.fontRegular),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButton<String>(
                                hint: Text('Select'),
                                value: location[0],
                                iconSize: 24,
                                elevation: 10,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                    discountUptoValue.text =
                                        ((newValue == 'Percentage') ? '0' : "");
                                  });
                                },
                                items: location.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),

                            // Expanded(
                            //     child: Container(
                            //         margin: EdgeInsets.only(left: 16, right: 16, top: 1),
                            //         child: TextField(
                            //             controller: discountType,
                            //             keyboardType: TextInputType.number,
                            //             decoration: InputDecoration(hintText: "Percentage"),
                            //         ),
                            //     ),
                            // ),
                            // Container(
                            //     margin: EdgeInsets.only(top: 16, right: 16),
                            //     child: Image.asset(
                            //       Res.ic_down_arrow,
                            //       width: 15,
                            //       height: 15,
                            //     )),
                            SizedBox(width: 50),
                            Expanded(
                              child: Container(
                                height: 32,
                                //margin: EdgeInsets.only(left: 16, right: 16, top: 1),
                                child: TextField(
                                  controller: discountValue,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(hintText: "10"),
                                ),
                              ),
                            ),
                            (dropdownValue == 'Percentage')
                                ? Container(
                                    margin: EdgeInsets.only(top: 16, right: 16),
                                    child: Image.asset(
                                      Res.ic_percent,
                                      width: 15,
                                      height: 15,
                                    ))
                                : Container(
                                    margin: EdgeInsets.only(top: 16, right: 16),
                                    child: Text('₹')),
                          ],
                        ),
                        (dropdownValue == 'Percentage')
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 5,
                                  ),
                                  Text(
                                    "Upto Discount *",
                                    style: TextStyle(
                                        color: AppConstant.appColor,
                                        fontFamily: AppConstant.fontRegular),
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 32,
                                          //margin: EdgeInsets.only(left: 16, right: 16, top: 1),
                                          child: TextField(
                                            controller: discountUptoValue,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                hintText:
                                                    "Enter Amount"), //${discountUptoValue.text}
                                          ),
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 16, right: 16),
                                          child: Text('₹'))
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                        Text(
                          "Applies To *",
                          style: TextStyle(
                              color: AppConstant.appColor,
                              fontFamily: AppConstant.fontRegular,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isSelectB = isSelectB == 1 ? -1 : 1;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 110,
                                  margin: EdgeInsets.only(left: 16),
                                  decoration: BoxDecoration(
                                      color: isSelectB == 1
                                          ? Color(0xffFFA451)
                                          : Color(0xffF3F6FA),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      "Breakfast",
                                      style: TextStyle(
                                          color: isSelectB == 1
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 14,
                                          fontFamily: AppConstant.fontRegular),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isSelectL = isSelectL == 1 ? -1 : 1;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  margin: EdgeInsets.only(left: 16),
                                  decoration: BoxDecoration(
                                      color: isSelectL == 1
                                          ? Color(0xffFFA451)
                                          : Color(0xffF3F6FA),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      "Lunch",
                                      style: TextStyle(
                                          color: isSelectL == 1
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 14,
                                          fontFamily: AppConstant.fontRegular),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isSelectD = isSelectD == 1 ? -1 : 1;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 110,
                                  margin: EdgeInsets.only(left: 16),
                                  decoration: BoxDecoration(
                                      color: isSelectD == 1
                                          ? Color(0xffFFA451)
                                          : Color(0xffF3F6FA),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      "Dinner",
                                      style: TextStyle(
                                          color: isSelectD == 1
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 14,
                                          fontFamily: AppConstant.fontRegular),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isSelectON = isSelectON == 1 ? -1 : 1;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 110,
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      color: isSelectON == 1
                                          ? Color(0xffFFA451)
                                          : Color(0xffF3F6FA),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      "Order Now",
                                      style: TextStyle(
                                          color: isSelectON == 1
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 14,
                                          fontFamily: AppConstant.fontRegular),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Minimum Requirement",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: AppConstant.fontRegular,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isRequire = 0;
                                    ifMinimumAmount = false;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 110,
                                  margin: EdgeInsets.only(left: 16),
                                  decoration: BoxDecoration(
                                      color: isRequire == 0
                                          ? Color(0xffFFA451)
                                          : Color(0xffF3F6FA),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      "None",
                                      style: TextStyle(
                                          color: isRequire == 0
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 14,
                                          fontFamily: AppConstant.fontRegular),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isRequire = 1;
                                    ifMinimumAmount = true;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 110,
                                  margin: EdgeInsets.only(left: 16),
                                  decoration: BoxDecoration(
                                      color: isRequire == 1
                                          ? Color(0xffFFA451)
                                          : Color(0xffF3F6FA),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      "Min.Amount",
                                      style: TextStyle(
                                          color: isRequire == 1
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 14,
                                          fontFamily: AppConstant.fontRegular),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isRequire = 2;
                                    ifMinimumAmount = false;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 110,
                                  margin: EdgeInsets.only(left: 16, right: 16),
                                  decoration: BoxDecoration(
                                      color: isRequire == 2
                                          ? Color(0xffFFA451)
                                          : Color(0xffF3F6FA),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      "Min.Item",
                                      style: TextStyle(
                                          color: isRequire == 2
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 14,
                                          fontFamily: AppConstant.fontRegular),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ifMinimumAmount
                            ? Column(
                                children: [
                                  SizedBox(height: 15, width: 15),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Min Amount *",
                                          style: TextStyle(
                                              color: AppConstant.appColor,
                                              fontFamily:
                                                  AppConstant.fontRegular),
                                        ),
                                      ),
                                      // Expanded(
                                      //   child: Padding(
                                      //     padding: EdgeInsets.only(left: 16, right: 16),
                                      //     child: Text(
                                      //       "Max Amount *",
                                      //       style: TextStyle(
                                      //           color: AppConstant.appColor,
                                      //           fontFamily: AppConstant.fontRegular),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 32,
                                          //margin: EdgeInsets.only(left: 16, right: 16, top: 1),
                                          child: TextField(
                                            controller: minimumValue,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 16, right: 16),
                                          child: Text('₹')),
                                      SizedBox(width: 50),
                                      // Expanded(
                                      //   child: Container(
                                      //     height: 32,
                                      //     //margin: EdgeInsets.only(left: 16, right: 16, top: 1),
                                      //     child: TextField(
                                      //       controller: maximumValue,
                                      //       keyboardType: TextInputType.number,
                                      //       decoration: InputDecoration(),
                                      //     ),
                                      //   ),
                                      // ), Container(
                                      //         margin: EdgeInsets.only(top: 16, right: 16),
                                      //         child: Text('₹')),
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 12,
                        ),
                        Row(children: [
                          InkWell(
                            onTap: () async {
                              var result = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(DateTime.now().year + 5));

                              setState(() {
                                startDate = result!.year.toString() +
                                    "/" +
                                    result.month.toString() +
                                    "/" +
                                    result.day.toString();
                              });
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 134,
                                  child: Container(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(startDate == ""
                                          ? "start Date"
                                          : startDate),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                      )
                                    ],
                                  )),
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 16, right: 16),
                                    child: Image.asset(
                                      Res.ic_date,
                                      width: 15,
                                      height: 15,
                                      color: Colors.grey,
                                    )),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              var result = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(DateTime.now().year + 5));

                              setState(() {
                                endDate = result!.year.toString() +
                                    "/" +
                                    result.month.toString() +
                                    "/" +
                                    result.day.toString();
                              });
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 135,
                                  child: Container(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          endDate == "" ? "end Date" : endDate),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                      )
                                    ],
                                  )),
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 16, right: 16),
                                    child: Image.asset(
                                      Res.ic_date,
                                      width: 15,
                                      height: 15,
                                      color: Colors.grey,
                                    )),
                              ],
                            ),
                          ),
                        ]),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Start Time *",
                                style: TextStyle(
                                    color: AppConstant.appColor,
                                    fontFamily: AppConstant.fontRegular),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "End Time *",
                                style: TextStyle(
                                    color: AppConstant.appColor,
                                    fontFamily: AppConstant.fontRegular),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: TextField(
                                  onTap: () {
                                    setState(() {
                                      _selectTime(context, startTime);
                                    });
                                  },
                                  // readOnly: true,
                                  controller: startTime,
                                  //decoration: InputDecoration(hintText: "Start Time"),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectTime(context, startTime);
                                });
                              },
                              child: Container(
                                  margin: EdgeInsets.only(top: 16, right: 16),
                                  child: Image.asset(
                                    Res.ic_time_circle,
                                    width: 15,
                                    height: 15,
                                    color: Colors.grey,
                                  )),
                            ),
                            Expanded(
                              child: Container(
                                child: TextField(
                                  onTap: () {
                                    _selectTime(context, endTime);
                                  },
                                  controller: endTime,
                                  //decoration: InputDecoration(hintText: "End Time"),
                                ),
                              ),
                            ),
                            // Expanded(
                            //   child: Row(
                            //     children: [
                            //       Text("${selectedTime.hour}:${selectedTime.minute}"),
                            //       (selectedTime.period.index.toString() == '0')
                            //           ? Text(' AM')
                            //           : Text(' PM')
                            //     ],
                            //   ),
                            // ),
                            InkWell(
                              onTap: () {
                                _selectTime(context, endTime);
                              },
                              child: Container(
                                  margin: EdgeInsets.only(top: 16, right: 16),
                                  child: Image.asset(
                                    Res.ic_time_circle,
                                    width: 15,
                                    height: 15,
                                    color: Colors.grey,
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Description",
                          style: TextStyle(
                              color: AppConstant.appColor,
                              fontSize: 16,
                              fontFamily: AppConstant.fontRegular),
                        ),
                        TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: description,
                          decoration: InputDecoration(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Usage Limit *",
                          style: TextStyle(
                              color: AppConstant.appColor,
                              fontSize: 16,
                              fontFamily: AppConstant.fontRegular),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              activeColor: Color(0xff7EDABF),
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value!;
                                  print(isChecked);
                                });
                              },
                              value: isChecked == null ? false : isChecked,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 3, right: 4),
                              child: Text(
                                "Limit the number of times this\ndiscount code can be used",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: AppConstant.fontRegular,
                                    fontSize: 16),
                              ),
                            ),
                            (isChecked)
                                ? Container(
                                    width: 60,
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      controller: limit,
                                      decoration:
                                          InputDecoration(hintText: "Limit"),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            validaton();
                          },
                          child: Container(
                            height: 55,
                            margin: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16, top: 36),
                            decoration: BoxDecoration(
                                color: AppConstant.appColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                "UPDATE OFFER",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: AppConstant.fontBold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
                physics: BouncingScrollPhysics(),
              ));
  }

  void validaton() {
    var title = oferTitle.text.toString();
    var code = discountcode.text.toString();
    var type = (dropdownValue.toString() == 'Percentage') ? '0' : '1';
    var minimumAmount = ifMinimumAmount ? minimumValue.text.toString() : '';
    // var maximumAmount = ifMinimumAmount ? maximumValue.toString() : '';
    var value = discountValue.text.toString();
    var uptoValue = discountUptoValue.text.toString();
    var sTime = startTime.text.toString();
    var eTime = endTime.text.toString();
    var lim = limit.text.toString();
    var descriptionText = description.text.toString();
    if (title.isEmpty) {
      Utils.showToast("Enter Offer Title", context);
    } else if (code.isEmpty) {
      Utils.showToast("Enter discount code", context);
    } else if (type.isEmpty) {
      Utils.showToast("Select discount type", context);
    } else if (value.isEmpty) {
      Utils.showToast("Enter discount value", context);
    } else if (dropdownValue == 'Percentage' && uptoValue == '0') {
      Utils.showToast("Enter discount upto value", context);
    } else if (isSelectB == -1 &&
        isSelectL == -1 &&
        isSelectD == -1 &&
        isSelectON == -1) {
      Utils.showToast("Please select applies", context);
    } else if (isRequire == -1) {
      Utils.showToast("Please select minimum requirement", context);
    } else if (minimumAmount.isEmpty && ifMinimumAmount == true) {
      Utils.showToast("Please enter Min Amount", context);
    }
    // else if(maximumAmount.isEmpty && ifMinimumAmount == true)
    // {
    //   Utils.showToast("Please enter Max Amount") ;
    // }
    else if (startDate.isEmpty) {
      Utils.showToast("Please enter start date", context);
    } else if (endDate.isEmpty) {
      Utils.showToast("Please enter end date", context);
    } else if (sTime.isEmpty) {
      Utils.showToast("Please enter startTime", context);
    } else if (eTime.isEmpty) {
      Utils.showToast("Please enter end time", context);
    } else if (isChecked == false) {
      Utils.showToast("Check Usage Limit", context);
    } else if (isChecked && lim.isEmpty) {
      Utils.showToast("Please enter minimum limit", context);
    } else {
      editOffer(widget.offerId, title, code, type, value, lim, sTime, eTime,
          minimumAmount, descriptionText, uptoValue);
    }
  }

  Future<GetOfferDetail?> getOfferDetail(
      BuildContext context, String offerId) async {
    try {
      FormData from = FormData.fromMap(
          {"user_id": userId, 'offer_id': offerId, "token": "123456789"});
      GetOfferDetail? bean = await ApiProvider().getOfferDetail(offerId);

      if (bean.status == true) {
        setState(() {
          isPageLoading = false;
          oferTitle.text = bean.data!.title!;
          discountcode.text = bean.data!.offercode!;
          //discountType.text = bean.data.discounttype;
          discountValue.text = bean.data!.discountValue!;
          discountUptoValue.text = bean.data!.uptoAmount!;
          startTime.text = bean.data!.starttime!;
          endTime.text = bean.data!.endtime!;
          startDate = DateFormat('yyyy-MM-dd').format(bean.data!.startdate!);
          endDate = DateFormat('yyyy-MM-dd').format(bean.data!.enddate!);
          limit.text = bean.data!.usagelimit!;
          // maximumValue.text = bean.data.maxAmount;
          minimumValue.text = bean.data!.minAmount!;
          description.text = bean.data!.description!;
          isRequire = int.parse(bean.data!.minrequirement!);
          if (isRequire == 1) {
            ifMinimumAmount = true;
          }
          final appliestoSplit = bean.data!.appliesto!.split(',');
          for (int i = 0; i < appliestoSplit.length; i++) {
            if (appliestoSplit[i] == '1') {
              isSelectB = 1;
            } else if (appliestoSplit[i] == '2') {
              isSelectL = 1;
            } else if (appliestoSplit[i] == '3') {
              isSelectD = 1;
            } else if (appliestoSplit[i] == '4') {
              isSelectON = 1;
            }
          }

          dropdownValue = (int.parse(bean.data!.discounttype!) == 0)
              ? 'Percentage'
              : 'Value';
          isChecked = (int.parse(bean.data!.usagelimit!) == 0) ? false : true;
        });

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

  Future<EditOffer?> editOffer(
      String offerId,
      String title,
      String discountcode,
      String type,
      String value,
      String lim,
      String sTime,
      String eTime,
      String minimumAmount,
      String desciption,
      String uptoAmount) async {
    try {
      FormData data;
      data = FormData.fromMap({
        "offer_id": offerId,
        "offer_title": title,
        "offer_code": discountcode,
        "discount_type": type,
        "discount_value": value,
        "apply_to": ((isSelectB == 1 ? "1," : "") +
            (isSelectL == 1 ? "2," : '') +
            (isSelectD == 1 ? "3," : "") +
            (isSelectON == 1 ? "4," : "")),
        // ? "1"
        // : isSelect == 2
        //     ? "2"
        //     : isSelect == 3
        //         ? "3"
        //         : "0",
        "minimum_requirement": isRequire == 1
            ? "1"
            : isRequire == 2
                ? "2"
                : '0',
        "usage_limit": lim,
        "start_date": startDate,
        "end_date": endDate,
        "start_time": startTime.text,
        "end_time": endTime.text,
        "token": "123456789",
        "minimum_amount": minimumAmount,
        // "maximum_amount":maximumAmount,
        "upto_amount": uptoAmount,
        "description": desciption,
      });

      print({
        "offer_id": offerId,
        "offer_title": title,
        "offer_code": discountcode,
        "discount_type": type,
        "discount_value": value,
        "apply_to": ((isSelectB == 1 ? "1," : "") +
            (isSelectL == 1 ? "2," : '') +
            (isSelectD == 1 ? "3," : "") +
            (isSelectON == 1 ? "4," : "")),
        // ? "1"
        // : isSelect == 2
        //     ? "2"
        //     : isSelect == 3
        //         ? "3"
        //         : "0",
        "minimum_requirement": isRequire == 1
            ? "1"
            : isRequire == 2
                ? "2"
                : '0',
        "usage_limit": lim,
        "start_date": startDate,
        "end_date": endDate,
        "start_time": startTime.text,
        "end_time": endTime.text,
        "token": "123456789",
        "minimum_amount": minimumAmount,
        // "maximum_amount":maximumAmount,
        "upto_amount": uptoAmount,
        "description": desciption,
      });
      EditOffer bean = await ApiProvider().editOffer(
          offerId,
          title,
          discountcode,
          type,
          value,
          ((isSelectB == 1 ? "1," : "") +
              (isSelectL == 1 ? "2," : '') +
              (isSelectD == 1 ? "3," : "") +
              (isSelectON == 1 ? "4," : "")),
          isRequire == 1
              ? "1"
              : isRequire == 2
                  ? "2"
                  : '0',
          lim,
          startDate,
          endDate,
          sTime,
          eTime,
          minimumAmount,
          uptoAmount,
          desciption);

      if (bean.status == true) {
        Navigator.pop(context, true);
        Utils.showToast("Offer Updated Successfully", context);
      } else {
        Utils.showToast(bean.message ?? "", context);
      }
    } on HttpException {
    } catch (exception) {}
    return null;
  }

  _selectTime(BuildContext context, TextEditingController time) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        var type = (timeOfDay.hour >= 12) ? 'PM' : 'AM';
        time.text = timeOfDay.hourOfPeriod.toString() +
            ":" +
            timeOfDay.minute.toString() +
            ' $type';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You cannot Select present time'),
      ));
    }
  }
}
