// ignore_for_file: non_constant_identifier_names, must_be_immutable, unused_field

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitchen/Menu/BasePackageScreen.dart';
import 'package:kitchen/model/BeanAddLunch.dart';
import 'package:kitchen/model/BeanDinnerAdd.dart';
import 'package:kitchen/model/BeanSaveMenu.dart';
import 'package:kitchen/model/BeanUpdateMenuStock.dart';
import 'package:kitchen/model/breakfastModel.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/res.dart';
  import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';

import '../model/KitchenData/BeanLogin.dart';
import '../src/presentation/screens/HomeBaseScreen.dart';


class MenuBaseScreen extends StatefulWidget {
  var flag;

  MenuBaseScreen(this.flag);

  @override
  _MenuBaseScreenState createState() => _MenuBaseScreenState(flag);
}

class _MenuBaseScreenState extends State<MenuBaseScreen>
    with SingleTickerProviderStateMixin {
  BreakfastModelData? breakfast;
  BreakfastModelData? lunch;
  BreakfastModelData? dinner;
  List categories = [
    'South Indian Meals',
    'North Indian Meals',
    'Other Indian Meals'
  ];
  List cuisinetype = ['Lunch', 'Dinner', 'Both'];
  var isSelected = 1;

  TabController? _controller;
  bool isReplaceOne = true;
  bool isReplaceTwo = false;
  bool isReplaceThree = false;
  bool isDinnerSouth = false;
  bool isDinnerNorth = false;
  bool isDinnerOther = false;

  bool isLunchSouth = false;
  bool isLunchNorth = false;
  bool isLunchOther = false;

  File? _image;
  File? _imageDinner;
  File? _imageLunch;
  String isSelectVeg = 'Veg';
  String SelectLunchCategory = 'Veg';
  String SelectSouthCuisineType = 'Lunch';
  String SelectNorthCuisineType = 'Lunch';
  String SelectOtherCuisineType = 'Lunch';
  String SelectDinnerCategory = 'Veg';
  int LunchIndex = 0;
  int DinnerIndex = 0;

  var isDinnerCategory = 1;
  var isSelectMenu = 1;
  var isSelectFood = 2;
  var isMealType = 1;
  var isSelectedNorth = 1;
  bool? isMenu = true;
  bool? saveMenuSelected = false;
  bool? addMenu = false;
  var _isOnSubscription = false;
  var _isSounIndianMeal = false;
  var _isNorthIndianist = false;
  var _isotherIndianist = false;
  var _other = false;
  var _other2 = false;
  var addDefaultIcon = true;
  var addPack = false;
  var setMenuPackage = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var flag;
  Future? _future;

  var userId = "";
  var kitchenID = "";
  BeanLogin? userBean;

  _MenuBaseScreenState(this.flag);

  Future getUser() async {
    userBean = await Utils.getUser();
    kitchenID = userBean!.data!.kitchenId.toString();
    userId = userBean!.data!.id.toString();
  }

  var BreakfastSouthNameTEC = <TextEditingController>[];
  var BreakfastSouthPriceTEC = <TextEditingController>[];
  var BreakfastSouthItemImages = <File>[];
  var BreakfastNorthNameTEC = <TextEditingController>[];
  var BreakfastNorthPriceTEC = <TextEditingController>[];
  var BreakfastNorthItemImages = <File>[];
  var BreakfastOtherNameTEC = <TextEditingController>[];
  var BreakfastOtherPriceTEC = <TextEditingController>[];
  var BreakfastOtherItemImages = <File>[];
  var LunchSouthNameTEC = <TextEditingController>[];
  var LunchSouthPriceTEC = <TextEditingController>[];
  var LunchSouthItemImages = <File>[];
  var LunchNorthNameTEC = <TextEditingController>[];
  var LunchNorthPriceTEC = <TextEditingController>[];
  var LunchNorthItemImages = <File>[];
  var LunchOtherNameTEC = <TextEditingController>[];
  var LunchOtherPriceTEC = <TextEditingController>[];
  var LunchOtherItemImages = <File>[];
  var DinnerSouthNameTEC = <TextEditingController>[];
  var DinnerSouthPriceTEC = <TextEditingController>[];
  var DinnerSouthItemImages = <File>[];
  var DinnerNorthNameTEC = <TextEditingController>[];
  var DinnerNorthPriceTEC = <TextEditingController>[];
  var DinnerNorthItemImages = <File>[];
  var DinnerOtherNameTEC = <TextEditingController>[];
  var DinnerOtherPriceTEC = <TextEditingController>[];
  var DinnerOtherItemImages = <File>[];

  var rowsBreakfastSouth = <Widget>[];
  var rowsBreakfastNorth = <Widget>[];
  var rowsBreakfastOther = <Widget>[];
  var rowsDinnerSouth = <Widget>[];
  var rowsDinnerNorth = <Widget>[];
  var rowsDinnerOther = <Widget>[];
  var rowsLunchSouth = <Widget>[];
  var rowsLunchNorth = <Widget>[];
  var rowsLunchOther = <Widget>[];

  // var rows = <Widget>[];

  Widget createRow(
      {List<TextEditingController>? name,
      List<TextEditingController>? price,
      List<File>? itemImages}) {
    var nameController = TextEditingController();
    var priceController = TextEditingController();
    // nameTEC.add(nameController);
    name!.add(nameController);
    price!.add(priceController);
    // itemImages!.add(null);
    // priceTEC.add(priceController);
    // itemImages.add(null);
    return Container(
      width: 250,
      child: Row(
        children: [
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10, top: 30),
              child: TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: "name"),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: 50,
              margin: EdgeInsets.only(left: 10, right: 16, top: 30),
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(hintText: AppConstant.rupee + " Price"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getAllMenu() async {
    getMenuLunch();
    // getMenuDinner();
    getBreakFastMenu();
  }

  @override
  void initState() {
    getUser().then((value) {
      getAllMenu();

      rowsBreakfastSouth.add(createRow(
          name: BreakfastSouthNameTEC,
          price: BreakfastSouthPriceTEC,
          itemImages: BreakfastSouthItemImages));
      rowsBreakfastNorth.add(createRow(
          name: BreakfastNorthNameTEC,
          price: BreakfastNorthPriceTEC,
          itemImages: BreakfastNorthItemImages));
      rowsBreakfastOther.add(createRow(
          name: BreakfastOtherNameTEC,
          price: BreakfastOtherPriceTEC,
          itemImages: BreakfastOtherItemImages));

      rowsLunchSouth.add(createRow(
          name: LunchSouthNameTEC,
          price: LunchSouthPriceTEC,
          itemImages: LunchSouthItemImages));
      rowsLunchNorth.add(createRow(
          name: LunchNorthNameTEC,
          price: LunchNorthPriceTEC,
          itemImages: LunchNorthItemImages));
      rowsLunchOther.add(createRow(
          name: LunchOtherNameTEC,
          price: LunchOtherPriceTEC,
          itemImages: LunchOtherItemImages));

      rowsDinnerSouth.add(createRow(
          name: DinnerSouthNameTEC,
          price: DinnerSouthPriceTEC,
          itemImages: DinnerSouthItemImages));
      rowsDinnerNorth.add(createRow(
          name: DinnerNorthNameTEC,
          price: DinnerNorthPriceTEC,
          itemImages: DinnerNorthItemImages));
      rowsDinnerOther.add(createRow(
          name: DinnerOtherNameTEC,
          price: DinnerOtherPriceTEC,
          itemImages: DinnerOtherItemImages));
    });
    _controller = new TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        drawer: MyDrawers(),
        key: _scaffoldKey,
        backgroundColor: AppConstant.appColor,
        body: Column(
          children: [
            visileMenuheader(),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  margin: EdgeInsets.only(top: 20),
                  child: MenuSelected()),
            ),
          ],
        ));
  }

  MenuSelected() {
    if (isSelected == 1) {
      return getPage();
    } else {
      return BasePackageScreen();
    }
  }

  getPage() {
    if (isReplaceOne == true) {
      // return replaceAddMenu();
      // return replaceDefaultScreen();
      return replaceSaveMenu();
    } else if (isReplaceTwo == true) {
      return replaceAddMenu();
    } else if (isReplaceThree == true) {
      return replaceSaveMenu();
    }
  }

  Widget BreakfastTile() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          child: Padding(
        padding: EdgeInsets.only(left: 16, top: 16),
        child: Text(
          'Breakfast',
          style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: AppConstant.fontBold),
        ),
      )),
      SizedBox(height: 10),
      ExpansionTile(
        onExpansionChanged: (bool val) {
          setState(() {
            _isSounIndianMeal = val;
            // _isotherIndianist = false;
            // _isNorthIndianist = false;
          });
        },
        title: Text(
          'South Indian Meal',
          style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: AppConstant.fontRegular),
        ),
        trailing: Container(
          height: 30,
          width: 30,
          margin: EdgeInsets.only(right: 20, top: 10),
          child: CupertinoSwitch(
            activeColor: Color(0xff7EDABF),
            value: _isSounIndianMeal,
            onChanged: (bool value) {},
          ),
        ),
        children: <Widget>[
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isSelectVeg = breakfast!.southIndian![0].category!;
                  });
                },
                child: Container(
                  height: 40,
                  width: 110,
                  margin: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                      color: isSelectVeg == breakfast!.southIndian![0].category
                          ? Color(0xffFFA451)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      breakfast!.southIndian![0].category!,
                      style: TextStyle(
                          color:
                              isSelectVeg == breakfast!.southIndian![0].category
                                  ? Colors.white
                                  : Colors.black,
                          fontSize: 14,
                          fontFamily: AppConstant.fontBold),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isSelectVeg = breakfast!.southIndian![1].category!;
                  });
                },
                child: Container(
                  height: 40,
                  width: 110,
                  margin: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                      color: isSelectVeg == breakfast!.southIndian![1].category
                          ? Color(0xffFFA451)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      breakfast!.southIndian![1].category!,
                      style: TextStyle(
                          color:
                              isSelectVeg == breakfast!.southIndian![1].category
                                  ? Colors.white
                                  : Colors.black,
                          fontSize: 14,
                          fontFamily: AppConstant.fontBold),
                    ),
                  ),
                ),
              )
            ],
          ),
          // row----------------->
          (isSelectVeg == breakfast!.southIndian![0].category)
              ? CategoryMenuItems(list: breakfast!.southIndian![0].list)
              : CategoryMenuItems(list: breakfast!.southIndian![1].list),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: rowsBreakfastSouth.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  InkWell(
                    onTap: () {
                      _showPicker(context, index, BreakfastSouthItemImages);
                    },
                    child: Padding(
                        padding: EdgeInsets.only(top: 30, left: 6),
                        child: BreakfastSouthItemImages.isEmpty
                            ? Image.asset(
                                Res.ic_poha,
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                              )

                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      BreakfastSouthItemImages.elementAt(index),
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                  ),
                  rowsBreakfastSouth[index],
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          rowsBreakfastSouth.removeAt(index);
                          BreakfastSouthNameTEC.removeAt(index);
                          BreakfastSouthPriceTEC.removeAt(index);
                          BreakfastSouthItemImages.removeAt(index);
                        });
                      },
                    ),
                  )
                ],
              );
            },
          ),

          SizedBox(height: 26),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                rowsBreakfastSouth.add(createRow(
                    name: BreakfastSouthNameTEC,
                    price: BreakfastSouthPriceTEC,
                    itemImages: BreakfastSouthItemImages));
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppConstant.appColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Text('Add another menu'),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: InkWell(
              onTap: () {
                _onDone(
                    cuisinetype: '0',
                    rowsData: rowsBreakfastSouth,
                    nameValidation: BreakfastSouthNameTEC,
                    priceValidation: BreakfastSouthPriceTEC,
                    imageValidation: BreakfastSouthItemImages);
              },
              child: Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                  color: AppConstant.appColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Add Breakfast",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
      ExpansionTile(
        onExpansionChanged: (bool val) {
          setState(() {
            _isNorthIndianist = val;
          });
        },
        title: Text(
          'North Indian Meal',
          style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: AppConstant.fontRegular),
        ),
        trailing: Container(
          height: 30,
          width: 30,
          margin: EdgeInsets.only(right: 20, top: 10),
          child: CupertinoSwitch(
            activeColor: Color(0xff7EDABF),
            value: _isNorthIndianist,
            onChanged: (bool value) {},
          ),
        ),
        children: <Widget>[
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isSelectVeg = breakfast!.northIndian![0].category!;
                  });
                },
                child: Container(
                  height: 40,
                  width: 110,
                  margin: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                      color: isSelectVeg == breakfast!.northIndian![0].category
                          ? Color(0xffFFA451)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      breakfast!.northIndian![0].category!,
                      style: TextStyle(
                          color:
                              isSelectVeg == breakfast!.northIndian![0].category
                                  ? Colors.white
                                  : Colors.black,
                          fontSize: 14,
                          fontFamily: AppConstant.fontBold),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isSelectVeg = breakfast!.northIndian![1].category!;
                  });
                },
                child: Container(
                  height: 40,
                  width: 110,
                  margin: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                      color: isSelectVeg == breakfast!.northIndian![1].category
                          ? Color(0xffFFA451)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      breakfast!.northIndian![1].category!,
                      style: TextStyle(
                          color:
                              isSelectVeg == breakfast!.northIndian![1].category
                                  ? Colors.white
                                  : Colors.black,
                          fontSize: 14,
                          fontFamily: AppConstant.fontBold),
                    ),
                  ),
                ),
              )
            ],
          ),
          //row----------------->
          (isSelectVeg == breakfast!.northIndian![0].category)
              ? CategoryMenuItems(list: breakfast!.northIndian![0].list)
              : CategoryMenuItems(list: breakfast!.northIndian![1].list),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: rowsBreakfastNorth.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  InkWell(
                    onTap: () {
                      _showPicker(context, index, BreakfastNorthItemImages);
                    },
                    child: Padding(
                        padding: EdgeInsets.only(top: 30, left: 6),
                        child: BreakfastNorthItemImages.isEmpty
                            ? Image.asset(
                                Res.ic_poha,
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                              )

                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      BreakfastNorthItemImages.elementAt(index),
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                  ),
                  rowsBreakfastNorth[index],
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          rowsBreakfastNorth.removeAt(index);
                          BreakfastNorthNameTEC.removeAt(index);
                          BreakfastNorthPriceTEC.removeAt(index);
                          BreakfastNorthItemImages.removeAt(index);
                        });
                      },
                    ),
                  )
                ],
              );
            },
          ),

          SizedBox(height: 26),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                rowsBreakfastNorth.add(createRow(
                    name: BreakfastNorthNameTEC,
                    price: BreakfastNorthPriceTEC,
                    itemImages: BreakfastNorthItemImages));
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppConstant.appColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Text('Add another menu'),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: InkWell(
              onTap: () {
                _onDone(
                    cuisinetype: '1',
                    rowsData: rowsBreakfastNorth,
                    nameValidation: BreakfastNorthNameTEC,
                    priceValidation: BreakfastNorthPriceTEC,
                    imageValidation: BreakfastNorthItemImages);
              },
              child: Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                  color: AppConstant.appColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Add Breakfast",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
      ExpansionTile(
        onExpansionChanged: (bool val) {
          setState(() {
            // _isSounIndianMeal = false;
            _isotherIndianist = val;
            // _isNorthIndianist = false;
          });
        },
        title: Text(
          'Other Indian Meal',
          style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: AppConstant.fontRegular),
        ),
        trailing: Container(
          height: 30,
          width: 30,
          margin: EdgeInsets.only(right: 20, top: 10),
          child: CupertinoSwitch(
            activeColor: Color(0xff7EDABF),
            value: _isotherIndianist,
            onChanged: (bool value) {},
          ),
        ),
        children: <Widget>[
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isSelectVeg = breakfast!.otherIndian![0].category!;
                  });
                },
                child: Container(
                  height: 40,
                  width: 110,
                  margin: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                      color: isSelectVeg == breakfast!.otherIndian![0].category
                          ? Color(0xffFFA451)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      breakfast!.otherIndian![0].category!,
                      style: TextStyle(
                          color:
                              isSelectVeg == breakfast!.otherIndian![0].category
                                  ? Colors.white
                                  : Colors.black,
                          fontSize: 14,
                          fontFamily: AppConstant.fontBold),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isSelectVeg = breakfast!.otherIndian![1].category!;
                  });
                },
                child: Container(
                  height: 40,
                  width: 110,
                  margin: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                      color: isSelectVeg == breakfast!.otherIndian![1].category
                          ? Color(0xffFFA451)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      breakfast!.otherIndian![1].category!,
                      style: TextStyle(
                          color:
                              isSelectVeg == breakfast!.otherIndian![1].category
                                  ? Colors.white
                                  : Colors.black,
                          fontSize: 14,
                          fontFamily: AppConstant.fontBold),
                    ),
                  ),
                ),
              )
            ],
          ),
          //row----------------->
          (isSelectVeg == breakfast!.otherIndian![0].category)
              ? CategoryMenuItems(list: breakfast!.otherIndian![0].list)
              : CategoryMenuItems(list: breakfast!.otherIndian![1].list),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: rowsBreakfastOther.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  InkWell(
                    onTap: () {
                      _showPicker(context, index, BreakfastOtherItemImages);
                    },
                    child: Padding(
                        padding: EdgeInsets.only(top: 30, left: 6),
                        child: BreakfastOtherItemImages.isEmpty
                            ? Image.asset(
                                Res.ic_poha,
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                              )

                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      BreakfastOtherItemImages.elementAt(index),
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                  ),
                  rowsBreakfastOther[index],
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          rowsBreakfastOther.removeAt(index);
                          BreakfastOtherNameTEC.removeAt(index);
                          BreakfastOtherPriceTEC.removeAt(index);
                          BreakfastOtherItemImages.removeAt(index);
                        });
                      },
                    ),
                  )
                ],
              );
            },
          ),

          SizedBox(height: 26),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                rowsBreakfastOther.add(createRow(
                    name: BreakfastOtherNameTEC,
                    price: BreakfastOtherPriceTEC,
                    itemImages: BreakfastOtherItemImages));
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppConstant.appColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Text('Add another menu'),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: InkWell(
              onTap: () {
                _onDone(
                    cuisinetype: '2',
                    rowsData: rowsBreakfastOther,
                    nameValidation: BreakfastOtherNameTEC,
                    priceValidation: BreakfastOtherPriceTEC,
                    imageValidation: BreakfastOtherItemImages);
              },
              child: Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                  color: AppConstant.appColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Add Breakfast",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
      SizedBox(height: 26),
      Divider(height: 20, thickness: 5, color: Colors.grey.shade100),
    ]);
  }

  ListView CategoryMenuItems({List<ListElement>? list}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: list!.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            InkWell(
              onTap: () {
                // _showPicker(context, index,);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 30, left: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    list[index].image!,
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              width: 250,
              child: Row(
                children: [
                  (list[index].menutype == '3')
                      ? Container(
                          margin: EdgeInsets.only(top: 30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Color(0xffFFA451))),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'Lunch&Dinner',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                      : (list[index].menutype == '1')
                          ? Container(
                              margin: EdgeInsets.only(top: 30),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Color(0xffFFA451))),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Lunch',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            )
                          : (list[index].menutype == '2')
                              ? Container(
                                  margin: EdgeInsets.only(top: 30),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border:
                                          Border.all(color: Color(0xffFFA451))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      'Dinner',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 10, top: 30),
                    child: Text(list[index].itemname!),
                  )),
                  Expanded(
                      child: Container(
                    width: 50,
                    margin: EdgeInsets.only(left: 10, right: 16, top: 30),
                    child: Text(list[index].itemprice!),
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {

                    ApiProvider()
                        .delete_Menu_item(
                      list[index].menuId!
                    )
                        .then((value) {
                      setState(() {
                        list.removeAt(index);
                      });

                    });
                  });
                },
              ),
            )
          ],
        );
      },
    );
  }

  _onDone(
      {String? cuisinetype,
      List<Widget>? rowsData,
      List<TextEditingController>? nameValidation,
      List<TextEditingController>? priceValidation,
      List<File>? imageValidation}) {
    for (int i = 0; i < rowsData!.length; i++) {
      validationAddBreakfast(i, cuisinetype ?? '', nameValidation!,
          priceValidation!, imageValidation!);
      // addBreakfast(i);
    }
  }

  _onDoneLunch(
      {String? cuisinetype,
      String? menutype,
      List<Widget>? rowsData,
      List<TextEditingController>? nameValidation,
      List<TextEditingController>? priceValidation,
      List<File>? imageValidation}) {
    for (int i = 0; i < rowsData!.length; i++) {
      validationAddLunch(menutype ?? "", i, cuisinetype ?? '', nameValidation!,
          priceValidation!, imageValidation!);
      // addBreakfast(i);
    }
  }

  void validationAddBreakfast(
      int index,
      String cuisinetype,
      List<TextEditingController> nameValidation,
      List<TextEditingController> priceValidation,
      List<File> imageValidation) {
    if (nameValidation[index].text.isEmpty) {
      Utils.showToast("Please add breakfast name",context);
    } else if (priceValidation[index].text.isEmpty) {
      Utils.showToast("Please add breakfast price",context);
    } else if (imageValidation.elementAt(index) == null) {
      Utils.showToast("Please add breakfast image",context);
    } else {
      addBreakfast(index, cuisinetype,
          nameValidation: nameValidation,
          priceValidation: priceValidation,
          imageValidation: imageValidation);
    }
  }

  void validationAddLunch(
      String menutype,
      int index,
      String cuisinetype,
      List<TextEditingController> nameValidation,
      List<TextEditingController> priceValidation,
      List<File> imageValidation) {
    if (nameValidation[index].text.isEmpty) {
      Utils.showToast("Please add Lunch name",context);
    } else if (priceValidation[index].text.isEmpty) {
      Utils.showToast("Please add Lunch price",context);
    } else if (imageValidation.elementAt(index) == null) {
      Utils.showToast("Please add Lunch image",context);
    } else {
      addLunch(index, cuisinetype,
          nameValidation: nameValidation,
          priceValidation: priceValidation,
          imageValidation: imageValidation,
          menutype: menutype);
    }
  }

  void validationAddDinner(
      int index,
      String cuisinetype,
      List<TextEditingController> nameValidation,
      List<TextEditingController> priceValidation,
      List<File> imageValidation) {
    if (nameValidation[index].text.isEmpty) {
      Utils.showToast("Please add Dinner name",context);
    } else if (priceValidation[index].text.isEmpty) {
      Utils.showToast("Please add Dinner price",context);
    } else if (imageValidation.elementAt(index) == null) {
      Utils.showToast("Please add Dinner image",context);
    } else {
      addDinner(index, cuisinetype,
          nameValidation: nameValidation,
          priceValidation: priceValidation,
          imageValidation: imageValidation);
    }
  }

  Future<BeanSaveMenu?> addBreakfast(int index, String cuisineType,
      {List<TextEditingController>? nameValidation,
      List<TextEditingController>? priceValidation,
      List<File>? imageValidation}) async {

    try {
      // FormData from = FormData.fromMap({
      //   "kitchen_id": userId,
      //   "token": "123456789",
      //   "category": isSelectVeg,
      //   "cuisinetype": cuisineType,
      //   "itemname[]": nameValidation![index].text,
      //   "price[]": priceValidation![index].text,
      //   "item_image1": await MultipartFile.fromFile(
      //       imageValidation!.elementAt(index).path,
      //       filename: imageValidation.elementAt(index).path),
      // });
      BeanSaveMenu? bean = await ApiProvider().beanSaveMenu(isSelectVeg,cuisineType,
          nameValidation![index].text,
          priceValidation![index].text,
          await MultipartFile.fromFile(
          imageValidation!.elementAt(index).path,
          filename: imageValidation.elementAt(index).path));

      if (bean.status == true) {

        getAllMenu();
        setState(() {
          nameValidation![index].clear();
          priceValidation![index].clear();
          // imageValidation[index] = null;
        });

        Utils.showToast(bean.message ?? "",context);
        return bean;
      } else {

        setState(() {
          nameValidation![index].clear();
          priceValidation![index].clear();
          // imageValidation[index] = null;
        });
        Utils.showToast(bean.message ?? "",context);
      }
    } on HttpException catch (exception) {

      print(exception);
    } catch (exception) {

      print(exception);
    }
    return null;
  }

  Future<BeanLunchAdd?> addLunch(int index, String cuisineType,
      {List<TextEditingController>? nameValidation,
      List<TextEditingController>? priceValidation,
      List<File>? imageValidation,
      String? menutype}) async {

    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        "token": "123456789",
        "category": SelectLunchCategory,
        "cuisinetype": cuisineType,
        "itemname[]": nameValidation![index].text,
        "price[]": priceValidation![index].text,
        "item_image1": await MultipartFile.fromFile(
            imageValidation!.elementAt(index).path,
            filename: imageValidation.elementAt(index).path),
        "menutype[]": menutype
      });
      BeanLunchAdd? bean = await ApiProvider().beanLunchAdd(SelectLunchCategory,cuisineType,nameValidation[index].text,priceValidation[index].text,await MultipartFile.fromFile(
          imageValidation.elementAt(index).path,
          filename: imageValidation.elementAt(index).path),menutype!);


      if (bean.status == true) {

        getAllMenu();
        setState(() {
          nameValidation[index].clear();
          priceValidation[index].clear();
          // imageValidation[index] = null;
        });

        Utils.showToast(bean.message ?? "",context);
        return bean;
      } else {

        setState(() {
          nameValidation[index].clear();
          priceValidation[index].clear();
          // imageValidation[index] = null;
        });
        Utils.showToast(bean.message ?? "",context);
      }
    } on HttpException catch (exception) {

      print(exception);
    } catch (exception) {

      print(exception);
    }
    return null;
  }

  Future<BeanDinnerAdd?> addDinner(int index, String cuisineType,
      {List<TextEditingController>? nameValidation,
      List<TextEditingController>? priceValidation,
      List<File>? imageValidation}) async {

    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        "token": "123456789",
        "category": SelectDinnerCategory,
        "cuisinetype": cuisineType,
        "itemname[]": nameValidation![index].text,
        "price[]": priceValidation![index].text,
        "item_image1": await MultipartFile.fromFile(
            imageValidation!.elementAt(index).path,
            filename: imageValidation.elementAt(index).path),
      });
      BeanDinnerAdd? bean = await ApiProvider().beanDinnerAdd(SelectDinnerCategory,cuisineType,nameValidation[index].text,priceValidation[index].text,await MultipartFile.fromFile(
          imageValidation.elementAt(index).path,
          filename: imageValidation.elementAt(index).path));

      if (bean.status == true) {

        getAllMenu();
        setState(() {
          nameValidation[index].clear();
          priceValidation[index].clear();
          // imageValidation[index] = null;
        });

        Utils.showToast(bean.message ?? "",context);
        return bean;
      } else {

        setState(() {
          nameValidation[index].clear();
          priceValidation[index].clear();
          // imageValidation[index] = null;
        });
        Utils.showToast(bean.message ?? "",context);
      }
    } on HttpException catch (exception) {

      print(exception);
    } catch (exception) {

      print(exception);
    }
    return null;
  }

  String southMealType = '1';
  String northMealType = '1';
  String otherMealType = '1';

  replaceAddMenu() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Breakfast---------------------------------------------------
            BreakfastTile(),

            //Lunch---------------------------------------------------
            Padding(
              padding: EdgeInsets.only(left: 16, top: 20),
              child: Text(
                'Lunch & Dinner',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: AppConstant.fontBold),
              ),
            ),
            ExpansionTile(
              onExpansionChanged: (bool val) {
                setState(() {
                  isLunchSouth = val;
                });
              },
              title: Text(
                'South Indian Meals',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: AppConstant.fontRegular),
              ),
              trailing: Container(
                height: 30,
                width: 30,
                margin: EdgeInsets.only(right: 20, top: 10),
                child: CupertinoSwitch(
                  activeColor: Color(0xff7EDABF),
                  value: isLunchSouth,
                  onChanged: (bool value) {},
                ),
              ),
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  height: 40,
                  child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            SelectLunchCategory =
                                lunch!.southIndian![index].category!;
                            LunchIndex = index;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 110,
                          margin: EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                              color: SelectLunchCategory ==
                                      lunch!.southIndian![index].category
                                  ? Color(0xffFFA451)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              lunch!.southIndian![index].category!,
                              style: TextStyle(
                                  color: SelectLunchCategory ==
                                          lunch!.southIndian![index].category
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14,
                                  fontFamily: AppConstant.fontBold),
                            ),
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                Divider(),
                Container(
                  height: 40,
                  child: ListView.builder(
                    itemCount: cuisinetype.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            SelectSouthCuisineType = cuisinetype[index];
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 110,
                          margin: EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                              color:
                                  SelectSouthCuisineType == cuisinetype[index]
                                      ? Color(0xffFFA451)
                                      : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              cuisinetype[index],
                              style: TextStyle(
                                  color: SelectSouthCuisineType ==
                                          cuisinetype[index]
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14,
                                  fontFamily: AppConstant.fontBold),
                            ),
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                (SelectLunchCategory ==
                        lunch!.southIndian![LunchIndex].category)
                    ? CategoryMenuItems(
                        list: lunch!.southIndian![LunchIndex].list)
                    : Container(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: rowsLunchSouth.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {
                            _showPicker(context, index, LunchSouthItemImages);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 30, left: 6),
                            child: LunchSouthItemImages.isEmpty
                                ? Image.asset(
                                    Res.ic_poha,
                                    width: 55,
                                    height: 55,
                                    fit: BoxFit.cover,
                                  )

                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          LunchSouthItemImages.elementAt(index),
                                          width: 55,
                                          height: 55,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                          ),
                        ),
                        rowsLunchSouth[index],
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                rowsLunchSouth.removeAt(index);
                                LunchSouthNameTEC.removeAt(index);
                                LunchSouthPriceTEC.removeAt(index);
                                LunchSouthItemImages.removeAt(index);
                              });
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
                SizedBox(height: 26),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      rowsLunchSouth.add(createRow(
                          name: LunchSouthNameTEC,
                          price: LunchSouthPriceTEC,
                          itemImages: LunchSouthItemImages));
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: AppConstant.appColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Text('Add another menu'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: InkWell(
                    onTap: () {
                      _onDoneLunch(
                          menutype: (SelectSouthCuisineType) == 'Lunch'
                              ? '1'
                              : (SelectSouthCuisineType) == 'Dinner'
                                  ? '2'
                                  : '3',
                          cuisinetype: '0',
                          rowsData: rowsLunchSouth,
                          nameValidation: LunchSouthNameTEC,
                          priceValidation: LunchSouthPriceTEC,
                          imageValidation: LunchSouthItemImages);
                    },
                    child: Container(
                      height: 40,
                      width: 110,
                      decoration: BoxDecoration(
                        color: AppConstant.appColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              "Save Menu",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
            SizedBox(height: 15),
            ExpansionTile(
              onExpansionChanged: (bool val) {
                setState(() {
                  isLunchNorth = val;
                });
              },
              title: Text(
                'North Indian Meals',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: AppConstant.fontRegular),
              ),
              trailing: Container(
                height: 30,
                width: 30,
                margin: EdgeInsets.only(right: 20, top: 10),
                child: CupertinoSwitch(
                  activeColor: Color(0xff7EDABF),
                  value: isLunchNorth,
                  onChanged: (bool value) {},
                ),
              ),
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  height: 40,
                  child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            SelectLunchCategory =
                                lunch!.northIndian![index].category!;
                            LunchIndex = index;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 110,
                          margin: EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                              color: SelectLunchCategory ==
                                      lunch!.northIndian![index].category
                                  ? Color(0xffFFA451)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              lunch!.northIndian![index].category!,
                              style: TextStyle(
                                  color: SelectLunchCategory ==
                                          lunch!.northIndian![index].category
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14,
                                  fontFamily: AppConstant.fontBold),
                            ),
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                Divider(),
                Container(
                  height: 40,
                  child: ListView.builder(
                    itemCount: cuisinetype.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            SelectNorthCuisineType = cuisinetype[index];
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 110,
                          margin: EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                              color:
                                  SelectNorthCuisineType == cuisinetype[index]
                                      ? Color(0xffFFA451)
                                      : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              cuisinetype[index],
                              style: TextStyle(
                                  color: SelectNorthCuisineType ==
                                          cuisinetype[index]
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14,
                                  fontFamily: AppConstant.fontBold),
                            ),
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                (SelectLunchCategory ==
                        lunch!.northIndian![LunchIndex].category)
                    ? CategoryMenuItems(
                        list: lunch!.northIndian![LunchIndex].list)
                    : Container(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: rowsLunchNorth.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {
                            _showPicker(context, index, LunchNorthItemImages);
                          },
                          child: Padding(
                              padding: EdgeInsets.only(top: 30, left: 6),
                              child: LunchNorthItemImages.isEmpty
                                  ? Image.asset(
                                      Res.ic_poha,
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.cover,
                                    )

                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            File(LunchNorthItemImages.elementAt(
                                                    index)
                                                .path),
                                            width: 55,
                                            height: 55,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                        ),
                        rowsLunchNorth[index],
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                rowsLunchNorth.removeAt(index);
                                LunchNorthNameTEC.removeAt(index);
                                LunchNorthPriceTEC.removeAt(index);
                                LunchNorthItemImages.removeAt(index);
                              });
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
                SizedBox(height: 26),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      rowsLunchNorth.add(createRow(
                          name: LunchNorthNameTEC,
                          price: LunchNorthPriceTEC,
                          itemImages: LunchNorthItemImages));
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: AppConstant.appColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Text('Add another menu'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: InkWell(
                    onTap: () {
                      _onDoneLunch(
                          menutype: (SelectNorthCuisineType) == 'Lunch'
                              ? '1'
                              : (SelectNorthCuisineType) == 'Dinner'
                                  ? '2'
                                  : '3',
                          cuisinetype: '1',
                          rowsData: rowsLunchNorth,
                          nameValidation: LunchNorthNameTEC,
                          priceValidation: LunchNorthPriceTEC,
                          imageValidation: LunchNorthItemImages);
                    },
                    child: Container(
                      height: 40,
                      width: 110,
                      decoration: BoxDecoration(
                        color: AppConstant.appColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              "Save Menu",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
            SizedBox(height: 15),
            ExpansionTile(
              onExpansionChanged: (bool val) {
                setState(() {
                  isLunchOther = val;
                });
              },
              title: Text(
                'Other Indian Meals',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: AppConstant.fontRegular),
              ),
              trailing: Container(
                height: 30,
                width: 30,
                margin: EdgeInsets.only(right: 20, top: 10),
                child: CupertinoSwitch(
                  activeColor: Color(0xff7EDABF),
                  value: isLunchOther,
                  onChanged: (bool value) {},
                ),
              ),
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  height: 40,
                  child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            SelectLunchCategory =
                                lunch!.otherIndian![index].category!;
                            LunchIndex = index;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 110,
                          margin: EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                              color: SelectLunchCategory ==
                                      lunch!.otherIndian![index].category
                                  ? Color(0xffFFA451)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              lunch!.otherIndian![index].category!,
                              style: TextStyle(
                                  color: SelectLunchCategory ==
                                          lunch!.otherIndian![index].category
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14,
                                  fontFamily: AppConstant.fontBold),
                            ),
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                Divider(),
                Container(
                  height: 40,
                  child: ListView.builder(
                    itemCount: cuisinetype.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            SelectOtherCuisineType = cuisinetype[index];
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 110,
                          margin: EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                              color:
                                  SelectOtherCuisineType == cuisinetype[index]
                                      ? Color(0xffFFA451)
                                      : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              cuisinetype[index],
                              style: TextStyle(
                                  color: SelectOtherCuisineType ==
                                          cuisinetype[index]
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14,
                                  fontFamily: AppConstant.fontBold),
                            ),
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                (SelectLunchCategory ==
                        lunch!.otherIndian![LunchIndex].category)
                    ? CategoryMenuItems(
                        list: lunch!.otherIndian![LunchIndex].list)
                    : Container(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: rowsLunchOther.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {
                            _showPicker(context, index, LunchOtherItemImages);
                          },
                          child: Padding(
                              padding: EdgeInsets.only(top: 30, left: 6),
                              child: LunchOtherItemImages.isEmpty
                                  ? Image.asset(
                                      Res.ic_poha,
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.cover,
                                    )

                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            LunchOtherItemImages.elementAt(
                                                index),
                                            width: 55,
                                            height: 55,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                        ),
                        rowsLunchOther[index],
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                rowsLunchOther.removeAt(index);
                                LunchOtherNameTEC.removeAt(index);
                                LunchOtherPriceTEC.removeAt(index);
                                LunchOtherItemImages.removeAt(index);
                              });
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
                SizedBox(height: 26),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      rowsLunchOther.add(createRow(
                          name: LunchOtherNameTEC,
                          price: LunchOtherPriceTEC,
                          itemImages: LunchOtherItemImages));
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: AppConstant.appColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Text('Add another menu'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: InkWell(
                    onTap: () {
                      _onDoneLunch(
                          menutype: (SelectOtherCuisineType) == 'Lunch'
                              ? '1'
                              : (SelectOtherCuisineType) == 'Dinner'
                                  ? '2'
                                  : '3',
                          cuisinetype: '2',
                          rowsData: rowsLunchOther,
                          nameValidation: LunchOtherNameTEC,
                          priceValidation: LunchOtherPriceTEC,
                          imageValidation: LunchOtherItemImages);
                    },
                    child: Container(
                      height: 40,
                      width: 110,
                      decoration: BoxDecoration(
                        color: AppConstant.appColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              "Save Menu",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
            Divider(height: 20, thickness: 5, color: Colors.grey.shade100),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                getAllMenu().then((value) {
                  setState(() {
                    isReplaceThree = true;
                    isReplaceOne = false;
                    isReplaceTwo = false;
                  });
                });
              },
              child: Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 15),
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xffFFA451),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Save Menu",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: AppConstant.fontBold),
                    ),
                  )),
            ),
            AppConstant().navBarHt()
          ],
        ),
      ),
    );
  }

  replaceDefaultScreen() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Image.asset(
                        Res.ic_default_menu,
                        width: 220,
                        height: 120,
                      ),
                    )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      "No menu added yet",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: AppConstant.fontBold,
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "look's like you, haven't\n made your menu yet.",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: AppConstant.fontRegular,
                          fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isReplaceTwo = true;
                          isReplaceOne = false;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 150,
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Color(0xffFFA451),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 2, color: Colors.grey.shade300)
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Add menu",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: AppConstant.fontBold),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          physics: BouncingScrollPhysics(),
        ));
  }

  replaceSaveMenu() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          height: 90,
          child: DefaultTabController(
            length: 2,
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        color: Colors.white,
                        child: TabBar(
                          labelStyle: TextStyle(
                              fontFamily: AppConstant.fontBold, fontSize: 16),
                          unselectedLabelColor: Colors.black,
                          labelColor: Colors.black,
                          indicatorColor: AppConstant.appColor,
                          indicatorWeight: 5,
                          isScrollable: false,
                          controller: _controller,
                          tabs: [
                            Tab(text: 'BreakFast'),
                            Tab(text: 'Lunch & Dinner'),
                            // Tab(text: 'Dinner'),
                            // Tab(text: 'Dinner'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: TabBarView(
              controller: _controller,
              children: <Widget>[
                // Breakfast
                breakfast == null
                    ? Container(height: 100, width: 200)
                    : getItem(breakfast!, true),
                lunch == null
                    ? Container(height: 100, width: 200)
                    : getItem(lunch!, false),

                // dinner == null
                //     ? Container(height: 100, width: 200)
                //     : getItem(dinner),
              ],
            ),
          ),
        ),
        AppConstant().navBarHt()
      ],
    );
  }

  getItem(BreakfastModelData breakfast, bool isbreakfast) {
    return ListView(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // South Indian Meals--------------------------------->
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            categories[0],
            style: TextStyle(fontFamily: AppConstant.fontBold, fontSize: 15),
          ),
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: breakfast.southIndian!.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Image.asset(
                        Res.ic_veg,
                        width: 15,
                        height: 16,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(breakfast.southIndian![index].category!,
                        style: TextStyle(
                            color: AppConstant.appColor,
                            fontFamily: AppConstant.fontBold)),
                  ],
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, ind) {
                    return getListFood(
                        breakfast.southIndian![index].list![ind], isbreakfast);
                  },
                  itemCount: breakfast.southIndian![index].list!.length,
                ),
                SizedBox(height: 25),
              ],
            );
          },
        ),
        Divider(color: Colors.grey.shade400),

        // North Indian Meals--------------------------------->
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            categories[1],
            style: TextStyle(fontFamily: AppConstant.fontBold, fontSize: 15),
          ),
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: breakfast.northIndian!.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Image.asset(
                        Res.ic_veg,
                        width: 15,
                        height: 16,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(breakfast.northIndian![index].category!,
                        style: TextStyle(
                            color: AppConstant.appColor,
                            fontFamily: AppConstant.fontBold)),
                  ],
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, ind) {
                    return getListFood(
                        breakfast.northIndian![index].list![ind], isbreakfast);
                  },
                  itemCount: breakfast.northIndian![index].list!.length,
                ),
                SizedBox(height: 25),
              ],
            );
          },
        ),
        Divider(color: Colors.grey.shade400),

        // Other Indian Meals--------------------------------->
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            categories[2],
            style: TextStyle(fontFamily: AppConstant.fontBold, fontSize: 15),
          ),
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: breakfast.otherIndian!.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Image.asset(
                        Res.ic_veg,
                        width: 15,
                        height: 16,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(breakfast.otherIndian![index].category!,
                        style: TextStyle(
                            color: AppConstant.appColor,
                            fontFamily: AppConstant.fontBold)),
                  ],
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, ind) {
                    return getListFood(
                        breakfast.otherIndian![index].list![ind], isbreakfast);
                  },
                  itemCount: breakfast.otherIndian![index].list!.length,
                ),
                SizedBox(height: 25),
              ],
            );
          },
        ),
      ],
    );
  }

  getListFood(ListElement element, bool isbreakfast) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 16,
          ),
          Image.network(
            element.image!,
            width: 55,
            height: 55,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  child: Text(
                    element.itemname!,
                    style: TextStyle(
                        fontFamily: AppConstant.fontBold, color: Colors.black),
                  ),
                  padding: EdgeInsets.only(left: 16),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(AppConstant.rupee + element.itemprice!,
                      style: TextStyle(
                          fontFamily: AppConstant.fontBold,
                          color: Color(0xff7EDABF))),
                ),
                (isbreakfast)
                    ? SizedBox()
                    : (element.menutype == '1')
                        ? Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              'Lunch',
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        : (element.menutype == '2')
                            ? Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  'Dinner',
                                  style: TextStyle(fontSize: 12),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  'Lunch & Dinner',
                                  style: TextStyle(fontSize: 12),
                                ),
                              )
              ],
            ),
          ),
          Container(
            height: 30,
            width: 30,
            margin: EdgeInsets.only(right: 20, top: 10),
            child: CupertinoSwitch(
              activeColor: Color(0xff7EDABF),
              value: (element.instock == '0') ? false : true,
              onChanged: (newValue) {
                getMealScreenItems(element.menuId!, element.instock!);
                // setState(() {
                //   _isSounIndianMeal = newValue;
                //   if (_isSounIndianMeal == true) {
                //   } else {}
                // });
              },
            ),
          )
        ],
      ),
    );
  }

  Future<BeanUpdateMenuStock> getMealScreenItems(
      String menuId, String inStock) async {

      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        "token": "123456789",
        "menu_id": menuId,
        "instock": (inStock == '0') ? '1' : '0',
      });
      BeanUpdateMenuStock? bean = await ApiProvider().updateMenuStock(menuId,(inStock == '0') ? '1' : '0');


      if (bean.status == true) {
        setState(() {
          (_controller!.index == 0)
              ? getBreakFastMenu()
              : (_controller!.index == 1)
                  ? getMenuLunch()
                  : getMenuDinner();
        });

        return bean;
      } else {
       return Utils.showToast(bean.message ?? "",context);
      }
  }

  visileMenuheader() {
    if (flag == 0) {
      return Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                    Image.asset(
                      Res.ic_chef,
                      width: 65,
                      height: 65,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16, top: 50),
                          child: Text(
                            userBean!.data!.kitchenName ?? "",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: AppConstant.fontBold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            "Finest multi-cusine",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: AppConstant.fontRegular),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                (isSelected == 1)
                    ? IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isReplaceOne = false;
                            isReplaceTwo = true;
                            isReplaceThree = false;
                          });
                        },
                      )
                    : Container(),
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
                          isReplaceOne = true;
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
                            "Menu",
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
                            "Packages",
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
        ],
      );
    } else {
      return Container();
    }
  }

  void getBreakFastMenu() async {
    var map = FormData.fromMap(
      {"token": "123456789", "kitchen_id": userId},
    );
    BreakfastModel? menuBean = await ApiProvider().getMenu();
    if (menuBean.status!) {
      //Log.info(menuBean.data.southindian.breakfast.mealName);
      setState(() {
        breakfast = menuBean.data;
      });
    } else {
      Utils.showToast(menuBean.message ?? "",context);
    }
  }

  void getMenuLunch() async {

      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        "token": "123456789",
      });
      BreakfastModel? bean = await ApiProvider().beanGetLunch();
      if (bean.status == true) {
        //other.add(bean.data.otherIndian);
        setState(() {
          lunch = bean.data;
        });

      } else {
        Utils.showToast(bean.message ?? "",context);
      }

  }

  void getMenuDinner() async {
    //_progressDialog.show();
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        "token": "123456789",
      });
      BreakfastModel? bean = await ApiProvider().beanGetDinner();
      if (bean.status!) {
        //other.add(bean.data.otherIndian);
        setState(() {
          dinner = bean.data;
        });
        //_progressDialog.dismiss();
      } else {
        //_progressDialog.dismiss();
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {
      print(exception);
    }
  }

  _showPicker(context, int index, List<File> itemImages) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery(index, itemImages);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(index, itemImages);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  showPickerDinner(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGalleryDinner();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCameraDinner();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera(int index, List<File> itemImages) async {
    // DecorationImage image = DecorationImage(image: ImageSource.camera as ImageProvider,filterQuality:FilterQuality.medium);
    File? image = (await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50)) as File?;
    setState(() {
      _image = File(image!.path);
      itemImages.insert(index, File(image.path));
    });
  }

  _imgFromGallery(int index, List<File> itemImages) async {

    // DecorationImage image = DecorationImage(image: ImageSource.camera as ImageProvider,filterQuality:FilterQuality.medium);
    File? image = (await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50)) as File?;
    setState(() {
      itemImages.insert(index, File(image!.path));
    });
  }

  _imgFromGalleryDinner() async {
    // DecorationImage image = DecorationImage(image: ImageSource.camera as ImageProvider,filterQuality:FilterQuality.medium);
    File? image = (await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50)) as File?;
    setState(() {
      _imageDinner = File(image!.path);
    });
  }

  _imgFromCameraDinner() async {
    // DecorationImage image = DecorationImage(image: ImageSource.camera as ImageProvider,filterQuality:FilterQuality.medium);
    File? image = (await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50)) as File?;
    setState(() {
      _imageDinner = File(image!.path);
    });
  }

  _imgFromGalleryLunch() async {
    // DecorationImage image = DecorationImage(image: ImageSource.camera as ImageProvider,filterQuality:FilterQuality.medium);
    File? image = (await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50)) as File?;
    setState(() {
      _imageLunch = File(image!.path);
    });
  }
}

class UserEntry {
  final String name;
  final String price;
  final File image;

  UserEntry(this.name, this.price, this.image);
}
