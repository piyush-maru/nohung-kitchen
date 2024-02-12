import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kitchen/model/UpdateMenuDetails.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/network/OrderRepo/order_request_model.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/src/presentation/screens/DashboardScreen.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';
import 'package:provider/provider.dart';

import '../model/KitchenData/BeanLogin.dart';
import '../model/KitchenData/GetAccountDetail.dart';

//LATEST
class KitchenDetailScreen extends StatefulWidget {
  final GetAccountDetails? accDetails;

  const KitchenDetailScreen({Key? key, @required this.accDetails})
      : super(key: key);

  @override
  _KitchenDetailScreenState createState() => _KitchenDetailScreenState();
}

class _KitchenDetailScreenState extends State<KitchenDetailScreen> {
  var timeFrom1 = TextEditingController();
  var timeTo1 = TextEditingController();
  var timeFrom2 = TextEditingController();
  var timeTo2 = TextEditingController();
  var timeFrom3 = TextEditingController();
  var timeTo3 = TextEditingController();
  var breakfastFromTime = TextEditingController();
  var breakfastToTime = TextEditingController();
  var lunchFromTime = TextEditingController();
  var lunchToTime = TextEditingController();
  var dinnerFromTime = TextEditingController();
  var dinnerToTime = TextEditingController();

  int _radioValue = -1;
  Future? future;
  List<String> food = [];
  List<String> day = []; //day
  List<String> meal = [];
  List<String> kitchen = []; //home
  List<String> foodTypes = [];
  List<String> vegNonveg = [];
  List<String> siftTine = [];

  var type1 = "";
  var type2 = "";
  var type3 = "";
  var type4 = "";
  var type5 = "";

  bool checkMeals = false;
  bool checkFoodType = false;
  bool checkVegNonveg = false;
  bool checkkitchen = false;
  bool checkFood = false;
  bool checkFoods = false;
  bool checkDays = false;
  bool addShift = false;
  bool addShift1 = false;
  bool isEditing = false;
  bool isEditMeal = false;
  bool isLoadingDisable = false;
  bool isLoadingUpdate = false;
  bool isRefresh = false;
  bool isTimerOn = false;
  bool isTimeApiLadingOf = false;

  TimeOfDay selectedTime = TimeOfDay.now();

  //TimeOfDay? selectedTime;

  var _description = TextEditingController();

  Timer? timer;

  @override
  void initState() {
    super.initState();
    isTimerOn = true;
    isTimeApiLadingOf = false;
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
    if (isTimerOn) {
      Future.delayed(Duration.zero, () {
        future = getAccountDetails().then((value) {
          setState(() {
            //checkTypeOfFood(value!);
            checkDaysCount(value);
            checkMeal(value);
            checkVegNonvg(value);
            typeOfFood(value);
            typeOfKitchen(value);
            isTimerOn = true;
          });
        });
      });
    } else {}

    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      if (!isEditing) {
        isTimeApiLadingOf = true;
        future = getAccountDetails().then((value) {
          //checkTypeOfFood(value!);
          checkDaysCount(value);
          checkMeal(value);
          checkVegNonvg(value);
          typeOfFood(value);
          typeOfKitchen(value);
          isTimerOn = false;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _handleRadioValueChange(int? value) {
    setState(() {
      _radioValue = value!;
      isEditing = true;
      switch (_radioValue) {
        case 0:
          setState(() {});
          break;
        case 1:
          setState(() {});
          break;
      }
    });
  }

  checkMeal(GetAccountDetails? accountDetails) {
    for (int i = 0; i < meals.length; i++) {
      if (accountDetails!.data!.typeOfMeals!.contains(meals[i].title)) {
        if (meals[1].isCheckedMeals &&
            meals[2].isCheckedMeals &&
            meals[3]
                .isCheckedMeals /*meals[4].isCheckedMeals && meals[5].isCheckedMeals*/) {
          meals[0].isCheckedMeals = true;
          setState(() {});
        } else {
          meals[0].isCheckedMeals = false;
          meals[i].isCheckedMeals = true;
          setState(() {});
        }
      } else {
        meals[i].isCheckedMeals = false;
        setState(() {});
      }
    }
  }

  checkVegNonvg(GetAccountDetails? accountDetails) {
    for (int i = 0; i < foodType.length; i++) {
      if (accountDetails!.data!.typeofFood!.contains(foodType[i].title)) {
        if (foodType[1].isCheckedType &&
            foodType[2]
                .isCheckedType /*meals[4].isCheckedMeals && meals[5].isCheckedMeals*/) {
          foodType[0].isCheckedType = true;
          setState(() {});
        } else {
          foodType[0].isCheckedType = false;
          foodType[i].isCheckedType = true;
          setState(() {});
        }
      } else {
        foodType[i].isCheckedType = false;
        setState(() {});
      }
    }
  }

  typeOfFood(GetAccountDetails? accountDetails) {
    for (int i = 0; i < food1.length; i++) {
      if (accountDetails!.data!.typeOfFood!.contains(food1[i].title)) {
        food1[i].isCheckedFood1 = true;
        setState(() {});
      } else {
        food1[i].isCheckedFood1 = false;
        setState(() {});
      }
    }
  }

  typeOfKitchen(GetAccountDetails? accountDetails) {
    for (int i = 0; i < kitchenType.length; i++) {
      if (accountDetails!.data!.kitchentype!.contains(kitchenType[i].title)) {
        kitchenType[i].isCheckedKitchenType = true;
        setState(() {});
      } else {
        kitchenType[i].isCheckedKitchenType = false;
        setState(() {});
      }
    }
  }

  checkDaysCount(GetAccountDetails? accountDetails) {
    for (int i = 0; i < days.length; i++) {
      if (accountDetails!.data!.openDays!.contains(days[i].title)) {
        days[i].isCheckedDays = true;
        setState(() {});
      }
      /* if(days[1].isCheckedDays == true && days[2].isCheckedDays == true && days[3].isCheckedDays == true && days[4].isCheckedDays == true &&days[5].isCheckedDays == true && days[6].isCheckedDays == true && days[7].isCheckedDays == true){
          days[0].isCheckedDays = true;
        }else{
          days[0].isCheckedDays = false;
          days[i].isCheckedDays = true;
        }

        setState(() {});
      }*/
      else {
        days[i].isCheckedDays = false;
        setState(() {});
      }
    }
  }

  // checkTypeOfFood(GetAccountDetails? accountDetails) {
  //   for (int i = 0; i < choices.length; i++) {
  //     if (accountDetails!.data.typeOfFood.contains(choices[i].title)) {
  //       choices[i].isChecked = true;
  //       setState(() {});
  //     } else {
  //       choices[i].isChecked = false;
  //       setState(() {});
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: AppConstant.appColor,
        title: Text(
          "Kitchens Details",
          style: TextStyle(
              color: Colors.black,
              fontFamily: AppConstant.fontBold,
              fontSize: 16),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
              padding: EdgeInsets.only(left: 12, top: 12, right: 12),
              child: /* FutureBuilder<GetAccountDetails?>(
                    future: kitchenModel.getAccountDetails(),
                    builder: (context, snapshot) {

                      return snapshot.connectionState == ConnectionState.done &&
                              snapshot.data != null
                          ?*/
                  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Type of kitchen",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppConstant.fontBold,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  /* Row(
                    children: [
                      new Radio(
                        value: 0,
                        groupValue: _radioValue,
                        activeColor: Color(0xff7EDABF),
                        onChanged: _handleRadioValueChange,
                      ),
                      new Text(
                        'Kitchen only for delivery',
                        style: new TextStyle(
                            fontSize: 14, fontFamily: AppConstant.fontRegular),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: _radioValue,
                        activeColor: Color(0xff7EDABF),
                        onChanged: _handleRadioValueChange,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 1),
                        child: Text(
                          'Restaurants for delivery',
                          style: new TextStyle(
                              fontSize: 14,
                              fontFamily: AppConstant.fontRegular),
                        ),
                      )
                    ],
                  ),*/
                  Container(
                    // height: 140,
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 4 / 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(kitchenType.length, (index) {
                        return getKitchenType(kitchenType[index], index);
                      }),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Text(
                  //   "What type of food you provide?",
                  //   style: TextStyle(
                  //       color: Colors.black,
                  //       fontFamily: AppConstant.fontBold,
                  //       fontSize: 16),
                  // ),
                  // Container(
                  //   child: GridView.count(
                  //     crossAxisCount: 2,
                  //     childAspectRatio: 4 / 1,
                  //     shrinkWrap: true,
                  //     physics: BouncingScrollPhysics(),
                  //     children: List.generate(choices.length, (index) {
                  //       return getTypeOfFood(choices[index], index);
                  //     }),
                  //   ),
                  // ),
                  Text(
                    "Operation Timings of kitchen",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppConstant.fontBold,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Time From",
                              style: TextStyle(
                                  color: AppConstant.appColor,
                                  fontFamily: AppConstant.fontRegular)),
                          Text(
                            "Time To",
                            style: TextStyle(
                                color: AppConstant.appColor,
                                fontFamily: AppConstant.fontRegular),
                          ),
                          ElevatedButton(
                            onPressed: addShift == true && addShift1 == true
                                ? null
                                : () {
                                    setState(() {
                                      if (addShift) {
                                        addShift1 = true;
                                      } else {
                                        addShift = true;
                                      }
                                    });
                                  },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  addShift == true && addShift1 == true
                                      ? AppConstant.appColorLite
                                      : AppConstant.appColor),
                            ),
                            child: Text(
                              "Add shift",
                              style: TextStyle(
                                  fontFamily: AppConstant.fontRegular),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectTime(context, timeFrom1);
                              });
                            },
                            child: Container(
                              width: 100,
                              child: TextField(
                                onTap: () {
                                  setState(() {
                                    _selectTime(context, timeFrom1);
                                  });
                                },
                                readOnly: true,
                                showCursor: false,
                                enabled: false,
                                keyboardType: TextInputType.none,
                                controller: timeFrom1,
                                cursorColor: Colors.transparent,
                                clipBehavior: Clip.none,
                                cursorHeight: 0,
                                decoration: InputDecoration(
                                  hintText: "00:00",
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 16, right: 16),
                            child: Image.asset(
                              Res.ic_time_circle,
                              width: 15,
                              height: 15,
                              color: Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectTime(context, timeTo1);
                              });
                            },
                            child: Container(
                              width: 150,
                              child: Padding(
                                padding: EdgeInsets.only(left: 50),
                                child: TextField(
                                  onTap: () {
                                    setState(() {
                                      _selectTime(context, timeTo1);
                                    });
                                  },
                                  readOnly: true,
                                  showCursor: false,
                                  enabled: false,
                                  controller: timeTo1,
                                  keyboardType: TextInputType.none,
                                  cursorColor: Colors.transparent,
                                  decoration:
                                      InputDecoration(hintText: "00:00"),
                                ),
                              ),
                            ),
                          ),
                          /* GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectTime(context, timeTo1);
                              });
                            },
                            child:*/
                          Container(
                            margin: EdgeInsets.only(top: 16, right: 16),
                            child: Image.asset(
                              Res.ic_time_circle,
                              width: 15,
                              height: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      /*SizedBox(
                        height: 28,
                      ),*/
                      /*Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Time From",
                            style: TextStyle(color: AppConstant.appColor),
                          ),
                          SizedBox(
                            width: 80,
                          ),
                          Text(
                            "Time To",
                            style: TextStyle(color: AppConstant.appColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            child: TextField(
                              controller: timeFrom2,
                              keyboardType: TextInputType.none,
                              decoration: InputDecoration(hintText: "00:00"),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectTime(context, timeFrom2);
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 16),
                              child: Image.asset(
                                Res.ic_time_circle,
                                width: 15,
                                height: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            width: 150,
                            child: Padding(
                              padding: EdgeInsets.only(left: 50),
                              child: TextField(
                                controller: timeTo2,
                                keyboardType: TextInputType.none,
                                decoration: InputDecoration(hintText: "00:00"),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectTime(context, timeTo2);
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 16, right: 16),
                              child: Image.asset(
                                Res.ic_time_circle,
                                width: 15,
                                height: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),*/
                    ],
                  ),
                  addShift == true ||
                          (timeFrom2.text.isNotEmpty && timeTo2.text.isNotEmpty)
                      ? Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Time From",
                                    style:
                                        TextStyle(color: AppConstant.appColor),
                                  ),
                                  Text(
                                    "Time To",
                                    style:
                                        TextStyle(color: AppConstant.appColor),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isEditing = true;
                                        addShift = false;
                                        timeFrom2.clear();
                                        timeTo2.clear();
                                        setState(() {});
                                      });
                                    },
                                    icon: Icon(Icons.cancel),
                                  )
                                ]),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectTime(context, timeFrom2);
                                    });
                                  },
                                  child: Container(
                                    width: 100,
                                    child: TextField(
                                      onTap: () {
                                        setState(() {
                                          _selectTime(context, timeFrom2);
                                        });
                                      },
                                      readOnly: true,
                                      showCursor: false,
                                      enabled: false,
                                      controller: timeFrom2,
                                      keyboardType: TextInputType.none,
                                      decoration:
                                          InputDecoration(hintText: "00:00"),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 16),
                                  child: Image.asset(
                                    Res.ic_time_circle,
                                    width: 15,
                                    height: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectTime(context, timeTo2);
                                    });
                                  },
                                  child: Container(
                                    width: 150,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 50),
                                      child: TextField(
                                        onTap: () {
                                          setState(() {
                                            _selectTime(context, timeTo2);
                                          });
                                        },
                                        readOnly: true,
                                        showCursor: false,
                                        enabled: false,
                                        controller: timeTo2,
                                        keyboardType: TextInputType.none,
                                        decoration:
                                            InputDecoration(hintText: "00:00"),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 16, right: 16),
                                  child: Image.asset(
                                    Res.ic_time_circle,
                                    width: 15,
                                    height: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 12,
                  ),
                  addShift1 == true ||
                          (timeFrom3.text.isNotEmpty && timeTo3.text.isNotEmpty)
                      ? Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Time From",
                                    style:
                                        TextStyle(color: AppConstant.appColor),
                                  ),
                                  Text(
                                    "Time To",
                                    style:
                                        TextStyle(color: AppConstant.appColor),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isEditing = true;
                                        addShift1 = false;
                                        timeFrom3.clear();
                                        timeTo3.clear();
                                        setState(() {});
                                        // addShift = false;
                                      });
                                    },
                                    icon: Icon(Icons.cancel),
                                  )
                                ]),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectTime(context, timeFrom3);
                                    });
                                  },
                                  child: Container(
                                    width: 100,
                                    child: TextField(
                                      onTap: () {
                                        setState(() {
                                          _selectTime(context, timeFrom3);
                                        });
                                      },
                                      readOnly: true,
                                      showCursor: false,
                                      enabled: false,
                                      controller: timeFrom3,
                                      keyboardType: TextInputType.none,
                                      decoration:
                                          InputDecoration(hintText: "00:00"),
                                    ),
                                  ),
                                ),
                                Image.asset(
                                  Res.ic_time_circle,
                                  width: 15,
                                  height: 15,
                                  color: Colors.grey,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectTime(context, timeTo3);
                                    });
                                  },
                                  child: Container(
                                    width: 150,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 50,
                                      ),
                                      child: TextField(
                                        onTap: () {
                                          setState(() {
                                            _selectTime(context, timeTo3);
                                          });
                                        },
                                        readOnly: true,
                                        showCursor: false,
                                        enabled: false,
                                        controller: timeTo3,
                                        keyboardType: TextInputType.none,
                                        decoration:
                                            InputDecoration(hintText: "00:00"),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 16),
                                  child: Image.asset(
                                    Res.ic_time_circle,
                                    width: 15,
                                    height: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Open Day & Respective Timings",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppConstant.fontBold,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // height: 150,
                    child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 3 / 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(days.length, (index) {
                        return getDays(
                          days[index],
                          index,
                          days[0],
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "What type of food you provide?",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppConstant.fontBold,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // height: 150,
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(food1.length, (index1) {
                        return getFoodType(
                          food1[index1],
                          index1,
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Type of Meals you Provide",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppConstant.fontBold,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 4 / 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(meals.length, (index) {
                        return getMeals(meals[index], index, meals.first);
                      }),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "What Type Of Food",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppConstant.fontBold,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // height: 140,
                    child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 4 / 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(foodType.length, (index) {
                        return getFoodType1(
                            foodType![index], index, foodType.first);
                      }),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  meals[1].isCheckedMeals == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "BreakFast",
                              style:
                                  TextStyle(fontFamily: AppConstant.fontBold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Time From",
                                  style: TextStyle(
                                      color: meals[1].isCheckedMeals == true
                                          ? AppConstant.appColor
                                          : Colors.grey,
                                      fontFamily: AppConstant.fontRegular),
                                ),
                                Text(
                                  "Time To",
                                  style: TextStyle(
                                      color: meals[1].isCheckedMeals == true
                                          ? AppConstant.appColor
                                          : Colors.grey,
                                      fontFamily: AppConstant.fontRegular),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectTime(context, breakfastFromTime);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      color: Colors.blue.withOpacity(0.5),
                                    ),
                                    child: Row(children: [
                                      meals[1].isCheckedMeals == true
                                          ? Container(
                                              width: 100,
                                              child: TextField(
                                                onTap: () {
                                                  setState(() {
                                                    _selectTime(context,
                                                        breakfastFromTime);
                                                  });
                                                },
                                                readOnly: true,
                                                showCursor: false,
                                                enabled:
                                                    meals[1].isCheckedMeals,
                                                keyboardType:
                                                    TextInputType.none,
                                                controller: breakfastFromTime,
                                                decoration: InputDecoration(
                                                  hintText: "-- : --    ",
                                                  border: InputBorder.none,
                                                  hintStyle: TextStyle(
                                                      color:
                                                          meals[1].isCheckedMeals ==
                                                                  true
                                                              ? Colors.black
                                                              : Colors.grey),
                                                ),
                                              ))
                                          : Container(
                                              child: Text(
                                                "-- : --     ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        AppConstant.fontRegular,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                      Image.asset(
                                        Res.ic_time_circle,
                                        width: 15,
                                        height: 15,
                                        color: meals[1].isCheckedMeals == true
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ]),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectTime(context, breakfastToTime);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      color: Colors.blue.withOpacity(0.5),
                                    ),
                                    child: Row(children: [
                                      meals[1].isCheckedMeals == true
                                          ? Container(
                                              width: 100,
                                              child: TextField(
                                                onTap: () {
                                                  setState(() {
                                                    _selectTime(context,
                                                        breakfastToTime);
                                                  });
                                                },
                                                readOnly: true,
                                                showCursor: false,
                                                enabled:
                                                    meals[1].isCheckedMeals,
                                                controller: breakfastToTime,
                                                keyboardType:
                                                    TextInputType.none,
                                                decoration: InputDecoration(
                                                    hintText: "-- : --    "),
                                              ),
                                            )
                                          : Container(
                                              child: Text(
                                                "-- : --     ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        AppConstant.fontRegular,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                      Container(
                                        child: Image.asset(
                                          Res.ic_time_circle,
                                          width: 15,
                                          height: 15,
                                          color: meals[1].isCheckedMeals == true
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                      ),
                                    ]),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "BreakFast",
                              style:
                                  TextStyle(fontFamily: AppConstant.fontBold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                //border: Border.all(),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Time From",
                                          style: TextStyle(
                                              color: meals[1].isCheckedMeals ==
                                                      true
                                                  ? AppConstant.appColor
                                                  : Colors.grey,
                                              fontFamily:
                                                  AppConstant.fontRegular),
                                        ),
                                        Text(
                                          "Time To",
                                          style: TextStyle(
                                              color: meals[1].isCheckedMeals ==
                                                      true
                                                  ? AppConstant.appColor
                                                  : Colors.grey,
                                              fontFamily:
                                                  AppConstant.fontRegular),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 6, right: 6),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black
                                                    .withOpacity(0.20)),
                                            color: Colors.blue.withOpacity(0.5),
                                          ),
                                          child: Row(children: [
                                            /* meals[1].isCheckedMeals == true
                                        ? */
                                            Container(
                                                width: 100,
                                                child: TextField(
                                                  textInputAction:
                                                      TextInputAction.none,
                                                  enabled:
                                                      meals[1].isCheckedMeals,
                                                  keyboardType:
                                                      TextInputType.none,
                                                  controller: breakfastFromTime,
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                  decoration: InputDecoration(
                                                    hintText: "-- : --    ",
                                                    border: InputBorder.none,
                                                    hintStyle: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                )),
                                            /*: Container(
                                      child: Text(
                                        "-- : --     ",
                                        style: TextStyle(fontFamily: AppConstant.fontRegular, color: Colors.grey),
                                      ),
                                    ),*/
                                            InkWell(
                                              onTap: !meals[1].isCheckedMeals
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        //_selectTime(context, breakfastFromTime);
                                                      });
                                                    },
                                              child: Image.asset(
                                                Res.ic_time_circle,
                                                width: 15,
                                                height: 15,
                                                color:
                                                    meals[1].isCheckedMeals ==
                                                            true
                                                        ? Colors.black
                                                        : Colors.grey,
                                              ),
                                            ),
                                          ]),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 6, right: 6),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black
                                                    .withOpacity(0.20)),
                                            color: Colors.blue.withOpacity(0.5),
                                          ),
                                          child: Row(children: [
                                            /* meals[1].isCheckedMeals == true
                                        ?*/
                                            Container(
                                              width: 100,
                                              child: TextField(
                                                textInputAction:
                                                    TextInputAction.none,
                                                enabled:
                                                    meals[1].isCheckedMeals,
                                                controller: breakfastToTime,
                                                keyboardType:
                                                    TextInputType.none,
                                                style: TextStyle(
                                                    color: Colors.grey),
                                                decoration: InputDecoration(
                                                  hintText: "-- : --    ",
                                                  border: InputBorder.none,
                                                  hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            /*: Container(
                                      child: Text(
                                        "-- : --     ",
                                        style: TextStyle(fontFamily: AppConstant.fontRegular, color: Colors.grey),
                                      ),
                                    ),*/
                                            InkWell(
                                              onTap: !meals[1].isCheckedMeals
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        //_selectTime(context, breakfastToTime);
                                                      });
                                                    },
                                              child: Container(
                                                child: Image.asset(
                                                  Res.ic_time_circle,
                                                  width: 15,
                                                  height: 15,
                                                  color:
                                                      meals[1].isCheckedMeals ==
                                                              true
                                                          ? Colors.black
                                                          : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ]),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 12,
                  ),
                  Divider(
                    color: Colors.black,
                    height: 2,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  meals[2].isCheckedMeals == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lunch",
                              style:
                                  TextStyle(fontFamily: AppConstant.fontBold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Time From",
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontRegular,
                                      color: AppConstant.appColor),
                                ),
                                Text(
                                  "Time To",
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontRegular,
                                      color: AppConstant.appColor),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectTime(context, lunchFromTime);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      color: Colors.blue.withOpacity(0.5),
                                    ),
                                    child: Row(children: [
                                      meals[2].isCheckedMeals == true
                                          ? Container(
                                              width: 100,
                                              child: TextField(
                                                onTap: () {
                                                  setState(() {
                                                    _selectTime(
                                                        context, lunchFromTime);
                                                  });
                                                },
                                                readOnly: true,
                                                showCursor: false,
                                                enabled:
                                                    meals[2].isCheckedMeals,
                                                keyboardType:
                                                    TextInputType.none,
                                                controller: lunchFromTime,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "-- : --    "),
                                              ),
                                            )
                                          : Container(
                                              child: Text(
                                                "-- : --     ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        AppConstant.fontRegular,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                      Image.asset(
                                        Res.ic_time_circle,
                                        width: 15,
                                        height: 15,
                                        color: meals[2].isCheckedMeals == true
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ]),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectTime(context, lunchToTime);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      color: Colors.blue.withOpacity(0.5),
                                    ),
                                    child: Row(children: [
                                      meals[2].isCheckedMeals == true
                                          ? Container(
                                              width: 100,
                                              child: TextField(
                                                onTap: () {
                                                  setState(() {
                                                    _selectTime(
                                                        context, lunchToTime);
                                                  });
                                                },
                                                readOnly: true,
                                                showCursor: false,
                                                enabled:
                                                    meals[2].isCheckedMeals,
                                                keyboardType:
                                                    TextInputType.none,
                                                controller: lunchToTime,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "-- : --    "),
                                              ),
                                            )
                                          : Container(
                                              child: Text(
                                                "-- : --    ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        AppConstant.fontRegular,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                      /*GestureDetector(
                                  onTap: !meals[2].isCheckedMeals
                                      ? null
                                      : () {
                                          setState(() {
                                            _selectTime(context, lunchToTime);
                                          });
                                        },
                                  child:*/
                                      Image.asset(
                                        Res.ic_time_circle,
                                        width: 15,
                                        height: 15,
                                        color: meals[2].isCheckedMeals == true
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "BreakFast",
                              style:
                                  TextStyle(fontFamily: AppConstant.fontBold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                //color: Colors.grey.withOpacity(0.20),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                //border: Border.all(),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Time From",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily:
                                                  AppConstant.fontRegular),
                                        ),
                                        Text(
                                          "Time To",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily:
                                                  AppConstant.fontRegular),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 6, right: 6),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black
                                                    .withOpacity(0.20)),
                                            color: Colors.blue.withOpacity(0.5),
                                          ),
                                          child: Row(children: [
                                            /* meals[1].isCheckedMeals == true
                                        ? */
                                            Container(
                                                width: 100,
                                                child: TextField(
                                                  textInputAction:
                                                      TextInputAction.none,
                                                  enabled:
                                                      meals[2].isCheckedMeals,
                                                  keyboardType:
                                                      TextInputType.none,
                                                  controller: lunchFromTime,
                                                  style: TextStyle(
                                                      color: Colors.black38),
                                                  decoration: InputDecoration(
                                                    hintText: "-- : --    ",
                                                    border: InputBorder.none,
                                                    hintStyle: TextStyle(
                                                        color:
                                                            meals[2].isCheckedMeals ==
                                                                    true
                                                                ? Colors.black
                                                                : Colors.grey),
                                                  ),
                                                )),
                                            /*: Container(
                                      child: Text(
                                        "-- : --     ",
                                        style: TextStyle(fontFamily: AppConstant.fontRegular, color: Colors.grey),
                                      ),
                                    ),*/
                                            InkWell(
                                              onTap: !meals[2].isCheckedMeals
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        //_selectTime(context, breakfastFromTime);
                                                      });
                                                    },
                                              child: Image.asset(
                                                Res.ic_time_circle,
                                                width: 15,
                                                height: 15,
                                                color:
                                                    meals[2].isCheckedMeals ==
                                                            true
                                                        ? Colors.black
                                                        : Colors.grey,
                                              ),
                                            ),
                                          ]),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 6, right: 6),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black
                                                    .withOpacity(0.20)),
                                            color: Colors.blue.withOpacity(0.5),
                                          ),
                                          child: Row(children: [
                                            /* meals[1].isCheckedMeals == true
                                        ?*/
                                            Container(
                                              width: 100,
                                              child: TextField(
                                                textInputAction:
                                                    TextInputAction.none,
                                                enabled:
                                                    meals[2].isCheckedMeals,
                                                controller: lunchToTime,
                                                keyboardType:
                                                    TextInputType.none,
                                                style: TextStyle(
                                                    color: Colors.black38),
                                                decoration: InputDecoration(
                                                    hintText: "-- : --    "),
                                              ),
                                            ),
                                            /*: Container(
                                      child: Text(
                                        "-- : --     ",
                                        style: TextStyle(fontFamily: AppConstant.fontRegular, color: Colors.grey),
                                      ),
                                    ),*/
                                            InkWell(
                                              onTap: !meals[2].isCheckedMeals
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        //_selectTime(context, breakfastToTime);
                                                      });
                                                    },
                                              child: Container(
                                                child: Image.asset(
                                                  Res.ic_time_circle,
                                                  width: 15,
                                                  height: 15,
                                                  color:
                                                      meals[2].isCheckedMeals ==
                                                              true
                                                          ? Colors.black
                                                          : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ]),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 12,
                  ),
                  Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  meals[3].isCheckedMeals == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dinner",
                              style:
                                  TextStyle(fontFamily: AppConstant.fontBold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Time From",
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontRegular,
                                      color: AppConstant.appColor),
                                ),
                                Text(
                                  "Time To",
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontRegular,
                                      color: AppConstant.appColor),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectTime(context, dinnerFromTime);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      color: Colors.blue.withOpacity(0.5),
                                    ),
                                    child: Row(children: [
                                      meals[3].isCheckedMeals == true
                                          ? Container(
                                              width: 100,
                                              child: TextField(
                                                onTap: () {
                                                  setState(() {
                                                    _selectTime(context,
                                                        dinnerFromTime);
                                                  });
                                                },
                                                readOnly: true,
                                                showCursor: false,
                                                enabled:
                                                    meals[3].isCheckedMeals,
                                                keyboardType:
                                                    TextInputType.none,
                                                controller: dinnerFromTime,
                                                decoration: InputDecoration(
                                                    hintText: "-- : --    ",
                                                    border: InputBorder.none),
                                              ),
                                            )
                                          : Container(
                                              child: Text(
                                                "-- : --    ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        AppConstant.fontRegular,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                      Image.asset(
                                        Res.ic_time_circle,
                                        width: 15,
                                        height: 15,
                                        color: meals[3].isCheckedMeals == true
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ]),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectTime(context, dinnerToTime);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 6, right: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      color: Colors.blue.withOpacity(0.5),
                                    ),
                                    child: Row(children: [
                                      meals[3].isCheckedMeals == true
                                          ? Container(
                                              width: 100,
                                              child: TextField(
                                                onTap: () {
                                                  setState(() {
                                                    _selectTime(
                                                        context, dinnerToTime);
                                                  });
                                                },
                                                readOnly: true,
                                                showCursor: false,
                                                enabled:
                                                    meals[3].isCheckedMeals,
                                                keyboardType:
                                                    TextInputType.none,
                                                controller: dinnerToTime,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "-- : --    "),
                                              ),
                                            )
                                          : Container(
                                              child: Text(
                                                "-- : --    ",
                                                style: TextStyle(
                                                    fontFamily:
                                                        AppConstant.fontRegular,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                      Image.asset(
                                        Res.ic_time_circle,
                                        width: 15,
                                        height: 15,
                                        color: meals[3].isCheckedMeals == true
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "BreakFast",
                              style:
                                  TextStyle(fontFamily: AppConstant.fontBold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                //border: Border.all(),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Time From",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily:
                                                  AppConstant.fontRegular),
                                        ),
                                        Text(
                                          "Time To",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily:
                                                  AppConstant.fontRegular),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 6, right: 6),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black
                                                    .withOpacity(0.20)),
                                            color: Colors.blue.withOpacity(0.5),
                                          ),
                                          child: Row(children: [
                                            /* meals[1].isCheckedMeals == true
                                        ? */
                                            Container(
                                                width: 100,
                                                child: TextField(
                                                  textInputAction:
                                                      TextInputAction.none,
                                                  enabled:
                                                      meals[3].isCheckedMeals,
                                                  keyboardType:
                                                      TextInputType.none,
                                                  controller: dinnerFromTime,
                                                  style: TextStyle(
                                                      color: Colors.black38),
                                                  decoration: InputDecoration(
                                                    hintText: "-- : --    ",
                                                    border: InputBorder.none,
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                )),
                                            /*: Container(
                                      child: Text(
                                        "-- : --     ",
                                        style: TextStyle(fontFamily: AppConstant.fontRegular, color: Colors.grey),
                                      ),
                                    ),*/
                                            InkWell(
                                              onTap: !meals[3].isCheckedMeals
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        //_selectTime(context, breakfastFromTime);
                                                      });
                                                    },
                                              child: Image.asset(
                                                Res.ic_time_circle,
                                                width: 15,
                                                height: 15,
                                                color:
                                                    meals[3].isCheckedMeals ==
                                                            true
                                                        ? Colors.black
                                                        : Colors.grey,
                                              ),
                                            ),
                                          ]),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 6, right: 6),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black
                                                    .withOpacity(0.20)),
                                            color: Colors.blue.withOpacity(0.5),
                                          ),
                                          child: Row(children: [
                                            /* meals[1].isCheckedMeals == true
                                        ?*/
                                            Container(
                                              width: 100,
                                              child: TextField(
                                                textInputAction:
                                                    TextInputAction.none,
                                                enabled:
                                                    meals[3].isCheckedMeals,
                                                controller: dinnerToTime,
                                                keyboardType:
                                                    TextInputType.none,
                                                style: TextStyle(
                                                    color: Colors.black38),
                                                decoration: InputDecoration(
                                                    hintText: "-- : --    "),
                                              ),
                                            ),
                                            /*: Container(
                                      child: Text(
                                        "-- : --     ",
                                        style: TextStyle(fontFamily: AppConstant.fontRegular, color: Colors.grey),
                                      ),
                                    ),*/
                                            InkWell(
                                              onTap: !meals[3].isCheckedMeals
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        //_selectTime(context, breakfastToTime);
                                                      });
                                                    },
                                              child: Container(
                                                child: Image.asset(
                                                  Res.ic_time_circle,
                                                  width: 15,
                                                  height: 15,
                                                  color:
                                                      meals[3].isCheckedMeals ==
                                                              true
                                                          ? Colors.black
                                                          : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ]),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 12,
                  ),
                  Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Description",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppConstant.fontBold,
                        fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _description,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter description here...'),
                        onTap: () {
                          isEditing = true;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // setState(() {
                      //   isLoadingUpdate = true;
                      // });
                      validation();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppConstant.appColor),
                      fixedSize: MaterialStateProperty.all(
                        Size(450, 50),
                      ),
                    ),
                    child: Text(
                      "Save",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: AppConstant.fontBold,
                          color: Colors.white),
                    ),
                  ),
                  AppConstant().navBarHt()
                ],
              )
              /*: Text("Loading",
                              style: TextStyle(
                                fontFamily: AppConstant.fontRegular,
                              ),)*/

              ),
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    //setState(() async {
    isEditing = false;
    future = getAccountDetails().then((value) {
      //checkTypeOfFood(value);
      checkDaysCount(value);
      checkMeal(value);
      checkVegNonvg(value);
      typeOfFood(value);
      typeOfKitchen(value);
      //});
    });
  }

  void validation() {
    String shiftOneFromTime = timeFrom1.text;
    String shiftOneToTime = timeTo1.text;

    var shiftSecondFromTime = timeFrom2.text.toString();
    var shiftSecondToTime = timeTo2.text.toString();

    var shiftThirdFromTime = timeFrom3.text.toString();
    var shiftThirdToTime = timeTo3.text.toString();

    var breakfastFTime1 = breakfastFromTime.text.toString();
    var breakfastTime1 = breakfastFromTime.text.toString();

    var lunchFime1 = lunchFromTime.text.toString();
    var lunchTime1 = lunchToTime.text.toString();

    var dinnerFime1 = dinnerFromTime.text.toString();
    var dinnerTime1 = dinnerToTime.text.toString();

    var time = timeFrom1.text.toString();
    var timeToo = timeTo1.text.toString();

    /* if (_radioValue == -1) {
      Utils.showToast("Please add type of firm", context);
      isLoadingUpdate = false;
    } else */
    if (time.isEmpty) {
      Utils.showToast("Please add form time", context);
      isLoadingUpdate = false;
    } else if (timeToo.isEmpty) {
      Utils.showToast("Please add to time", context);
      isLoadingUpdate = false;
    } else if (meals[1].isCheckedMeals == true &&
        (breakfastFTime1.isEmpty || breakfastTime1.isEmpty)) {
      isLoadingUpdate = false;
      Utils.showToast(
          "Please select breakfast from time and to time both", context);
    } else if (meals[2].isCheckedMeals == true &&
        (lunchFime1.isEmpty || lunchTime1.isEmpty)) {
      isLoadingUpdate = false;
      Utils.showToast(
          "Please select Lunch from time and to time both", context);
    } else if (meals[3].isCheckedMeals == true &&
        (dinnerFime1.isEmpty || dinnerTime1.isEmpty)) {
      isLoadingUpdate = false;
      Utils.showToast(
          "Please select dinner from time and to time both", context);
    } else if (shiftOneFromTime.isEmpty || shiftOneToTime.isEmpty) {
      isLoadingUpdate = false;
      Utils.showToast(
          "Please select shift first from time and to time both", context);
    } else if (addShift == true &&
        (shiftSecondFromTime.isEmpty || shiftSecondToTime.isEmpty)) {
      Utils.showToast(
          "Please select shift second from time and to time both", context);
      isLoadingUpdate = false;
    } else if (addShift1 == true &&
        (shiftThirdFromTime.isEmpty || shiftThirdToTime.isEmpty)) {
      Utils.showToast(
          "Please select shift third from time and to time both", context);
      isLoadingUpdate = false;
    } else {
      apiCall(time, timeToo);
    }
  }

  Future<UpdateMenuDetail?> updateMenuSetting(bool? checkFood, bool? checkMeals,
      bool? checkFoods, bool? checkDays, bool? checkFoodType) async {
    BeanLogin? userBean = await Utils.getUser();
    var timings = [
      Timings(fromTime: timeFrom1.text, toTime: timeTo1.text),
      Timings(fromTime: timeFrom2.text, toTime: timeTo2.text),
      Timings(fromTime: timeFrom3.text, toTime: timeTo3.text)
    ];

    var foods = "";
    //"${choices[0].isChecked == false ? "" : "${choices[0].title}" + ","}${choices[1].isChecked == false ? "" : "${choices[1].title}" + ","}${choices[2].isChecked == false ? "" : "${choices[2].title}" + ","}${choices[3].isChecked == false ? "" : choices[3].title}";

    var kitchens =
        "${kitchenType[0].isCheckedKitchenType == true ? "${kitchenType[0].title}" + "," : ""}"
        "${kitchenType[1].isCheckedKitchenType == true ? "${kitchenType[1].title}" + "," : ""}";

    var daaays = days[0].isCheckedDays == true
        ? "${days[0].title},${days[1].title},${days[2].title},${days[3].title},${days[4].title},${days[5].title},${days[6].title},${days[7].title}"
        : "${days[0].isCheckedDays == true ? "${days[0].title}" + "," : ""}"
            "${days[1].isCheckedDays == true ? "${days[1].title}" + "," : ""}"
            "${days[2].isCheckedDays == true ? "${days[2].title}" + "," : ""}"
            "${days[3].isCheckedDays == true ? "${days[3].title}" + "," : ""}"
            "${days[4].isCheckedDays == true ? "${days[4].title}" + "," : ""}"
            "${days[5].isCheckedDays == true ? "${days[5].title}" + "," : ""}"
            "${days[6].isCheckedDays == true ? "${days[6].title}" + "," : ""}"
            "${days[7].isCheckedDays == true ? days[7].title : ""}";

    var typesOfFood =
        "${food1[0].isCheckedFood1 == true ? "${food1[0].title}" + "," : ""}"
        "${food1[1].isCheckedFood1 == true ? "${food1[1].title}" + "," : ""}"
        "${food1[2].isCheckedFood1 == true ? "${food1[2].title}" + "," : ""}"
        "${food1[3].isCheckedFood1 == true ? "${food1[3].title}" + "," : ""}"
        "${food1[4].isCheckedFood1 == true ? "${food1[4].title}" + "," : ""}"
        "${food1[5].isCheckedFood1 == true ? "${food1[5].title}" + "," : ""}"
        "${food1[6].isCheckedFood1 == true ? "${food1[6].title}" + "," : ""}"
        "${food1[7].isCheckedFood1 == true ? "${food1[7].title}" + "," : ""}"
        "${food1[8].isCheckedFood1 == true ? "${food1[8].title}" + "," : ""}"
        "${food1[9].isCheckedFood1 == true ? "${food1[9].title}" + "," : ""}"
        "${food1[10].isCheckedFood1 == true ? "${food1[10].title}" + "," : ""}"
        "${food1[11].isCheckedFood1 == true ? "${food1[11].title}" + "," : ""}"
        "${food1[12].isCheckedFood1 == true ? "${food1[12].title}" + "," : ""}"
        "${food1[13].isCheckedFood1 == true ? "${food1[13].title}" + "," : ""}";

    var meaaals =
        "${meals[0].isCheckedMeals == true ? "${meals[0].title}" + "," : ""}"
        "${meals[1].isCheckedMeals == true ? "${meals[1].title}" + "," : ""}"
        "${meals[2].isCheckedMeals == true ? "${meals[2].title}" + "," : ""}"
        "${meals[3].isCheckedMeals == true ? "${meals[3].title}" + "," : ""}"
        //"${meals[4].isCheckedMeals == true ? "${meals[4].title}" + "," : ""}"
        //"${meals[5].isCheckedMeals == true ? meals[5].title : ""}"
        ;

    var foodTypes =
        "${foodType[0].isCheckedType == true ? "${foodType[0].title}" + "," : ""}"
        "${foodType[1].isCheckedType == true ? "${foodType[1].title}" + "," : ""}"
        "${foodType[2].isCheckedType == true ? "${foodType[2].title}" + "," : ""}";

    // var foodTypes = foodType[0].isCheckedType == true
    //     ? "${foodType[0].title},${foodType[1].title},${foodType[2].title}"
    //     : "${foodType[0].isCheckedType == true ? "${foodType[0].title}" + "," : ""}"
    //       "${foodType[1].isCheckedType == true ? "${foodType[1].title}" + "," : ""}"
    //       "${foodType[2].isCheckedType == true ? foodType[2].title : ""}";

    try {
      // FormData data = FormData.fromMap({
      //   "token": "123456789",
      //   "user_id": userBean.data!.id,
      //   "type_of_firm": _radioValue == 0 ? "0" : "1",
      //   "type_of_food": foods,
      //   // "type_of_food": food
      //   //     .toString()
      //   //     .replaceAll("[", "")
      //   //     .replaceAll("]", "")
      //   //     .replaceAll(" ", ""),
      //   "breakfast_fromtime": breakfastFromTime.text,
      //   "breakfast_totime": breakfastToTime.text,
      //   "lunch_fromtime": lunchFromTime.text,
      //   "lunch_totime": lunchToTime.text,
      //   "dinner_fromtime": dinnerFromTime.text,
      //   "dinner_totime": dinnerToTime.text,
      //   "shift_timing": json.encode(timings),
      //   "open_days": daaays,
      //   // "open_days": day
      //   //     .toString()
      //   //     .replaceAll("[", "")
      //   //     .replaceAll("]", "")
      //   //     .replaceAll(" ", ""),
      //   "type_of_meals": meaaals,
      //   // "type_of_meals": meal
      //   //     .toString()
      //   //     .replaceAll("[", "")
      //   //     .replaceAll("]", "")
      //   //     .replaceAll(" ", ""),
      //   'description': _description.text.toString(),
      // });

      UpdateMenuDetail bean = await ApiProvider().updateMenuSetting(
          // _radioValue == 0 ? "0" : "1",
          kitchens,
          typesOfFood,
          breakfastFromTime.text,
          breakfastToTime.text,
          lunchFromTime.text,
          lunchToTime.text,
          dinnerFromTime.text,
          dinnerToTime.text,
          timings,
          daaays,
          meaaals,
          foodTypes,
          _description.text);
      print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++1");
      print({
        kitchens,
        typesOfFood,
        breakfastFromTime.text,
        breakfastToTime.text,
        lunchFromTime.text,
        lunchToTime.text,
        dinnerFromTime.text,
        dinnerToTime.text,
        timings,
        daaays,
        meaaals,
        foodTypes,
        _description.text
      });
      if (bean.status == true) {
        Utils.showToast(bean.message ?? "", context);

        Navigator.pop(context, true);
        isEditing = false;
      } else {
        Utils.showToast(bean.message ?? "", context);
        isLoadingUpdate = false;
        Utils.showToast(bean.message ?? "", context);
        isEditing = false;
        //setState(() {});

        Navigator.pop(context, true);
      }
    } on HttpException {
    } catch (exception) {
      isLoadingUpdate = false;
    }
    return null;
  }

  Future<GetAccountDetails?> getAccountDetails() async {
    isLoadingDisable == false || isTimeApiLadingOf == false
        ? CircularProgressIndicator()
        : isLoadingDisable = true;
    try {
      var userBean = await Utils.getUser();
      // FormData from = FormData.fromMap(
      //     {"user_id": userBean.data!.id, "token": "123456789"});
      GetAccountDetails? bean = await ApiProvider().getAccountDetails();
      isLoadingDisable = true;

      //setState(() {});
      if (bean.status!) {
        setState(() {
          // _radioValue = int.parse(bean.data.typeOfFirm);
          _description.text = bean.data!.description!;
          kitchen = bean.data!.kitchentype!;
          day = bean.data!.openDays!;
          food = bean.data!.typeOfFood!;
          meal = bean.data!.typeOfMeals!;
          foodTypes = bean.data!.typeofFood!;
          vegNonveg = bean.data!.typeOfFood!;
          print("<======================================================>");
          print({
            bean.data!.kitchentype!,
            bean.data!.openDays!,
            bean.data!.typeOfFood!,
            bean.data!.typeOfMeals!,
            bean.data!.typeofFood!
          });
          // siftTine = bean.kitchenData.shiftTiming;
          breakfastToTime.text = bean.data!.breakfastTotime!;
          breakfastFromTime.text = bean.data!.breakfastFromtime!;
          timeTo1.text = bean.data!.shiftTiming![0].toTime!;
          timeFrom1.text = bean.data!.shiftTiming![0].fromTime!;
          timeTo2.text = bean.data!.shiftTiming![1].toTime!;
          timeFrom2.text = bean.data!.shiftTiming![1].fromTime!;
          timeTo3.text = bean.data!.shiftTiming![2].toTime!;
          timeFrom3.text = bean.data!.shiftTiming![2].fromTime!;
          lunchFromTime.text = bean.data!.lunchFromtime!;
          lunchToTime.text = bean.data!.lunchTotime!;
          dinnerFromTime.text = bean.data!.dinnerFromtime!;
          dinnerToTime.text = bean.data!.dinnerTotime!;
        });
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

  Widget getTypeOfFood(Choice choice, int index) {
    return Row(
      children: [
        Checkbox(
          activeColor: Color(0xff7EDABF),
          onChanged: (value) {
            setState(() {
              isEditing = true;
              //choice.title == "Select All" ? choice.isChecked = value : false;
              choice.isChecked = value ?? true;
            });
          },
          value:
              /* widget.accDetails!.kitchenData.typeOfFood.contains(choice.title) ==null
                  ? true
                  :*/
              choice.isChecked == null ? false : choice.isChecked,
        ),
        Text(
          choice.title ?? "",
          style: TextStyle(
              color: Colors.black,
              fontFamily: AppConstant.fontRegular,
              fontSize: 14),
        ),
      ],
    );
  }

  Widget getDays(
    Days day,
    int index,
    Days selectAll,
  ) {
    return (Row(
      children: [
        Checkbox(
          activeColor: Color(0xff7EDABF),
          onChanged: (value) {
            setState(() {
              isEditing = true;
              day.isCheckedDays = value ?? false;
              if (selectAll.isCheckedDays && index == 0) {
                days[1].isCheckedDays = true;
                days[2].isCheckedDays = true;
                days[3].isCheckedDays = true;
                days[4].isCheckedDays = true;
                days[5].isCheckedDays = true;
                days[6].isCheckedDays = true;
                days[7].isCheckedDays = true;
              } else if (selectAll.isCheckedDays == false && index == 0) {
                days[1].isCheckedDays = false;
                days[2].isCheckedDays = false;
                days[3].isCheckedDays = false;
                days[4].isCheckedDays = false;
                days[5].isCheckedDays = false;
                days[6].isCheckedDays = false;
                days[7].isCheckedDays = false;
              } else if (!day.isCheckedDays) {
                selectAll.isCheckedDays = false;
              } else if (days[1].isCheckedDays == true &&
                  days[2].isCheckedDays == true &&
                  days[3].isCheckedDays == true &&
                  days[4].isCheckedDays == true &&
                  days[5].isCheckedDays == true &&
                  days[6].isCheckedDays == true &&
                  days[7].isCheckedDays == true) {
                selectAll.isCheckedDays = true;
              }
            });
          },
          value: selectAll.isCheckedDays ? true : day.isCheckedDays,
        ),
        Text(
          day.title,
          style: TextStyle(
              color: Colors.black,
              fontFamily: AppConstant.fontRegular,
              fontSize: 14),
        ),
      ],
    ));
  }

  Widget getFoodType(
    Food1 foods,
    int index,
  ) {
    return (Row(
      children: [
        Checkbox(
          activeColor: Color(0xff7EDABF),
          onChanged: (value) {
            setState(() {
              isEditing = true;
              foods.isCheckedFood1 = value ?? false;
              /* if (selectAll.isCheckedDays && index == 0) {
                food1[1].isCheckedFood1 = true;
                food1[2].isCheckedFood1 = true;
                food1[3].isCheckedFood1 = true;
                food1[4].isCheckedFood1 = true;
                food1[5].isCheckedFood1 = true;
                food1[6].isCheckedFood1 = true;
                food1[7].isCheckedFood1 = true;
                food1[8].isCheckedFood1 = true;
                food1[9].isCheckedFood1 = true;
                food1[10].isCheckedFood1 = true;
                food1[11].isCheckedFood1 = true;
                food1[12].isCheckedFood1 = true;
                food1[13].isCheckedFood1 = true;
                food1[14].isCheckedFood1 = true;
              }
              else if (selectAll.isCheckedDays == false && index == 0) {
                food1[1].isCheckedFood1 = false;
                food1[2].isCheckedFood1 = false;
                food1[3].isCheckedFood1 = false;
                food1[4].isCheckedFood1 = false;
                food1[5].isCheckedFood1 = false;
                food1[6].isCheckedFood1 = false;
                food1[7].isCheckedFood1 = false;
                food1[8].isCheckedFood1 = false;
                food1[9].isCheckedFood1 = false;
                food1[10].isCheckedFood1 = false;
                food1[11].isCheckedFood1 = false;
                food1[12].isCheckedFood1 = false;
                food1[13].isCheckedFood1 = false;
                food1[14].isCheckedFood1 = false;
              }
              else if (!foods.isCheckedFood1) {
                selectAll.isCheckedDays = false;
              }
              else if (days[1].isCheckedDays == true && days[2].isCheckedDays == true && days[3].isCheckedDays == true && days[4].isCheckedDays == true && days[5].isCheckedDays == true && days[6].isCheckedDays == true && days[7].isCheckedDays == true) {
                selectAll.isCheckedDays = true;
              }*/
            });
          },
          value: /*selectAll.isCheckedDays ? true :*/ foods.isCheckedFood1,
        ),
        Text(
          foods.title,
          style: TextStyle(
              color: Colors.black,
              fontFamily: AppConstant.fontRegular,
              fontSize: 14),
        ),
      ],
    ));
  }

  Widget getMeals(Meals meal, int index, Meals selectAll) {
    return Row(
      children: [
        Checkbox(
          activeColor: Color(0xff7EDABF),
          onChanged: (value) async {
            setState(() {
              isEditing = true;
              meal.isCheckedMeals = value ?? false;
              if (selectAll.isCheckedMeals && index == 0) {
                meals[1].isCheckedMeals = true;
                meals[2].isCheckedMeals = true;
                meals[3].isCheckedMeals = true;
              } else if (selectAll.isCheckedMeals == false && index == 0) {
                meals[1].isCheckedMeals = false;
                meals[2].isCheckedMeals = false;
                meals[3].isCheckedMeals = false;
              } else if (!meal.isCheckedMeals) {
                selectAll.isCheckedMeals = false;
              } else if (meals[1].isCheckedMeals == true &&
                  meals[2].isCheckedMeals == true &&
                  meals[3].isCheckedMeals == true) {
                selectAll.isCheckedMeals = true;
              }
            });
          },
          value: selectAll.isCheckedMeals ? true : meal.isCheckedMeals,
        ),
        Text(
          meal.title,
          style: TextStyle(
              color: Colors.black,
              fontFamily: AppConstant.fontRegular,
              fontSize: 14),
        ),
      ],
    );
  }

  Widget getFoodType1(FoodType foodTyp, int index, FoodType both) {
    return (Row(
      children: [
        Checkbox(
          activeColor: Color(0xff7EDABF),
          onChanged: (value) {
            /*setState(() {
              isEditing = true;
              foodType.isCheckedType = value ?? false;
            });*/
            setState(() {
              isEditing = true;
              foodTyp.isCheckedType = value ?? false;
              if (both.isCheckedType && index == 0) {
                foodType[1].isCheckedType = true;
                foodType[2].isCheckedType = true;
              } else if (both.isCheckedType == false && index == 0) {
                foodType[1].isCheckedType = false;
                foodType[2].isCheckedType = false;
              } else if (!foodTyp.isCheckedType) {
                both.isCheckedType = false;
              } else if (foodType[1].isCheckedType == true &&
                  foodType[2].isCheckedType == true) {
                both.isCheckedType = true;
              }
            });
          },
          value: /*selectAll.isCheckedDays ? true :*/ foodTyp.isCheckedType,
        ),
        Text(
          foodTyp.title,
          style: TextStyle(
              color: Colors.black,
              fontFamily: AppConstant.fontRegular,
              fontSize: 14),
        ),
      ],
    ));
  }

  Widget getKitchenType(
    KitchenType kitchenType,
    int index,
  ) {
    return (Row(
      children: [
        Checkbox(
          activeColor: Color(0xff7EDABF),
          onChanged: (value) {
            setState(() {
              isEditing = true;
              kitchenType.isCheckedKitchenType = value ?? false;
            });
          },
          value: /*selectAll.isCheckedDays ? true :*/
              kitchenType.isCheckedKitchenType,
        ),
        Text(
          kitchenType.title,
          style: TextStyle(
              color: Colors.black,
              fontFamily: AppConstant.fontRegular,
              fontSize: 14),
        ),
      ],
    ));
  }

  void apiCall(String time, String timeto) {
    // choices.forEach((data) {
    //   if (data.isChecked!) {
    //     food.add(data.title!);
    //     type1 = "first";
    //     checkFood = data.isChecked!;
    //   }
    // });

    kitchenType.forEach((data) {
      if (data.isCheckedKitchenType) {
        kitchen.add(data.title);
        checkkitchen = data.isCheckedKitchenType;
        type1 = "first";
      }
    });

    days.forEach((data) {
      if (data.isCheckedDays) {
        day.add(data.title);
        checkDays = data.isCheckedDays;
        type2 = "second";
      }
    });

    food1.forEach((data) {
      if (data.isCheckedFood1) {
        food.add(data.title);
        checkFoods = data.isCheckedFood1;
        type3 = "third";
      }
    });

    meals.forEach((data) {
      if (data.isCheckedMeals) {
        meal.add(data.title);
        checkMeals = data.isCheckedMeals;
        type4 = "forth";
      }
    });

    foodType.forEach((data) {
      if (data.isCheckedType) {
        vegNonveg.add(data.title);
        checkVegNonveg = data.isCheckedType;
        type5 = "fifth";
      }
    });

    if (type1 == "first" &&
        type2 == "second" &&
        type3 == "third" &&
        type4 == "forth" &&
        type5 == "fifth") {
      updateMenuSetting(
        checkkitchen,
        checkDays,
        checkFoods,
        checkMeals,
        checkVegNonveg, /*checkFood, checkMeals, checkDays*/
      );
      checkMeals = false;
    } else {
      Utils.showToast("Account detail not saved!", context);
    }
  }

  _selectTime(BuildContext context, TextEditingController time) async {
    setState(() {
      isEditing = true;
    });
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        var type = (timeOfDay.hour >= 12) ? 'PM' : 'AM';
        var hours = (timeOfDay.hour == 0 || timeOfDay.hour == 12)
            ? "12"
            : timeOfDay.hour == 13
                ? "01"
                : timeOfDay.hour == 14
                    ? "02"
                    : timeOfDay.hour == 15
                        ? "03"
                        : timeOfDay.hour == 16
                            ? "04"
                            : timeOfDay.hour == 17
                                ? "05"
                                : timeOfDay.hour == 18
                                    ? "06"
                                    : timeOfDay.hour == 19
                                        ? "07"
                                        : timeOfDay.hour == 20
                                            ? "08"
                                            : timeOfDay.hour == 21
                                                ? "09"
                                                : timeOfDay.hour == 22
                                                    ? "10"
                                                    : timeOfDay.hour == 23
                                                        ? "11"
                                                        : timeOfDay.hour == 24
                                                            ? "12"
                                                            : timeOfDay.hour;
        var min = (timeOfDay.minute == 0 || timeOfDay.minute == 00)
            ? "00"
            : timeOfDay.minute == 1
                ? "01"
                : timeOfDay.minute == 2
                    ? "02"
                    : timeOfDay.minute == 3
                        ? "03"
                        : timeOfDay.minute == 4
                            ? "04"
                            : timeOfDay.minute == 5
                                ? "05"
                                : timeOfDay.minute == 6
                                    ? "06"
                                    : timeOfDay.minute == 7
                                        ? "07"
                                        : timeOfDay.minute == 8
                                            ? "08"
                                            : timeOfDay.minute == 9
                                                ? "09"
                                                : timeOfDay.minute == 12
                                                    ? "12"
                                                    : timeOfDay.minute;
        time.text = "$hours" + ":" + "$min" + " $type";
        //time.text = timeOfDay.hour.toString() + ":" + timeOfDay.minute.toString() + ' $type';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You cannot Select present time'),
        ),
      );
    }
  }
}

class Choice {
  Choice({this.title, this.isChecked});

  String? title;
  bool? isChecked = false;
}

class Days {
  Days({required this.title, required this.isCheckedDays});

  String title;
  bool isCheckedDays = false;
  bool isCheckedDays1 = true;
}

class Food1 {
  Food1({required this.title, required this.isCheckedFood1});

  String title;
  bool isCheckedFood1 = false;
}

class Meals {
  Meals({required this.title, required this.isCheckedMeals});

  String title;
  bool isCheckedMeals = false;
}

class FoodType {
  FoodType({required this.title, required this.isCheckedType});

  String title;
  bool isCheckedType = false;
}

class KitchenType {
  KitchenType({required this.title, required this.isCheckedKitchenType});

  String title;
  bool isCheckedKitchenType = false;
}

class Timings {
  Timings({required this.fromTime, required this.toTime});

  String fromTime;
  String toTime;

  Map<String, dynamic> toJson() => {
        "from_time": fromTime,
        "to_time": toTime,
      };
}

// List<Choice> choices = <Choice>[
//   Choice(title: 'North Indian Meals', isChecked: false),
//   Choice(title: 'South Indian Meals', isChecked: false),
//   Choice(title: 'Diet Meals', isChecked: false),
//   Choice(title: 'Others', isChecked: false),
// ];

List<Days> days = <Days>[
  Days(title: 'Select All', isCheckedDays: false),
  Days(title: 'Sunday', isCheckedDays: false),
  Days(title: 'Monday', isCheckedDays: false),
  Days(title: 'Tuesday', isCheckedDays: false),
  Days(title: 'Wednesday', isCheckedDays: false),
  Days(title: 'Thursday', isCheckedDays: false),
  Days(title: 'Friday', isCheckedDays: false),
  Days(title: 'Saturday', isCheckedDays: false),
];

List<Food1> food1 = <Food1>[
  Food1(title: 'North Indian Meals', isCheckedFood1: false),
  Food1(title: 'South Indian Meals', isCheckedFood1: false),
  Food1(title: 'Weight loss', isCheckedFood1: false),
  Food1(title: 'Healthy meals', isCheckedFood1: false),
  Food1(title: 'Diabetic Meals', isCheckedFood1: false),
  Food1(title: 'Keto meals', isCheckedFood1: false),
  Food1(title: 'Muscle gain', isCheckedFood1: false),
  Food1(title: 'Protein meals', isCheckedFood1: false),
  Food1(title: 'Vegan Diet', isCheckedFood1: false),
  Food1(title: 'Weight gain meal', isCheckedFood1: false),
  Food1(title: 'Low carb', isCheckedFood1: false),
  Food1(title: 'Jain food', isCheckedFood1: false),
  Food1(title: 'Budget Friendly', isCheckedFood1: false),
  Food1(title: 'Children', isCheckedFood1: false),
];

List<Meals> meals = <Meals>[
  Meals(
    title: 'Select All',
    isCheckedMeals: false,
  ),
  Meals(title: 'Breakfast', isCheckedMeals: false),
  Meals(title: 'Lunch', isCheckedMeals: false),
  Meals(title: 'Dinner', isCheckedMeals: false),
];

List<FoodType> foodType = <FoodType>[
  FoodType(
    title: 'Both',
    isCheckedType: false,
  ),
  FoodType(title: 'Veg', isCheckedType: false),
  FoodType(title: 'Non Veg', isCheckedType: false),
];

List<KitchenType> kitchenType = <KitchenType>[
  KitchenType(
    title: 'Home',
    isCheckedKitchenType: false,
  ),
  KitchenType(title: 'Diet', isCheckedKitchenType: false),
];
