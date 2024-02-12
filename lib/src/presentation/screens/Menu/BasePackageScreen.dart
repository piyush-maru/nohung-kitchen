import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kitchen/Menu/SuccessPackageScreen.dart';
import 'package:kitchen/const/size_const.dart';
import 'package:kitchen/model/BeanAddMenu.dart';
import 'package:kitchen/model/BeanAddPackagePrice.dart';
import 'package:kitchen/model/BeanDeletePackage.dart';
import 'package:kitchen/model/BeanGetPackages.dart';
import 'package:kitchen/model/BeanPackagePriceDetail.dart';
import 'package:kitchen/model/updatePackageAvailability.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/Utils.dart';

import '../../../../model/KitchenData/BeanLogin.dart';

class BasePackageScreen extends StatefulWidget {
  final bool fromSettings;

  const BasePackageScreen({Key? key, this.fromSettings = false})
      : super(key: key);

  @override
  _BasePackageScreenState createState() => _BasePackageScreenState();
}

class _BasePackageScreenState extends State<BasePackageScreen> {
  BeanLogin? userBean;
  BeanAddMenu? bean;
  UpdatePackageAvailability? packageStatus;
  PickedFile? mediaFile;
  List<String> Files = [
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
  ];
  var cuisineSI = -1;
  var cuisineNI = -1;
  var cuisineDM = -1;
  var cuisineOC = -1;
  var cuisineSIE = -1;
  var cuisineNIE = -1;
  var cuisineDME = -1;
  var cuisineOCE = -1;
  var createPackageid;
  var packageId = '';
  BeanPackagePriceDetail? beanprice;
  BeanGetPackages? getPackagesbean;
  double variance = 0;
  double varianceMontly = 0;
  bool isReplaceDefault = true;
  bool isReplaceMenu = false;
  bool isReplaceAddPackages = false;
  bool isCreatePackages = false;
  bool isPackageEdit = false;
  var isMealType = -1;
  var isSelected = -1;
  var isSelectMenu = -1;
  var isSelectFood = -1;
  var isSelectedNorth = 1;
  var isMealTypeEdit = -1;
  var isSelectedEdit = -1;
  var isSelectMenuEdit = -1;
  var isSelectFoodEdit = -1;
  var isSelectedNorthEdit = 1;
  var _other2 = false;
  var sunday = false;
  var _other2Edit = false;
  var sundayEdit = false;
  var addDefaultIcon = true;
  bool isSelectPlanTypeWeekly = false;
  bool isSelectPlanTypeMonthly = false;
  bool isSelectPlanTypeWeeklyEdit = false;
  bool isSelectPlanTypeMonthlyEdit = false;
  Future? future;
  var packagename = TextEditingController();
  var packagenameEdit = TextEditingController();
  var packname = "";
  var date = "";
  var dateEdit = '';
  var userId;
  var weekly = TextEditingController();
  var monthly = TextEditingController();

  bool isPageLoading = true;

  final Uri toLaunch =
      Uri(scheme: 'https', host: 'nohung.com', path: '/kitchen/package');

  @override
  void initState() {
    getUser().then((value) {
      // getMenuPackageList();
      // getPackagePriceDetail(context);
      //getMealScreenItems();
      setState(() async {
        await Future.delayed(Duration.zero, () {
          getMealScreenItems();
        });
      });
    });
    super.initState();
  }

  Future getUser() async {
    userBean = await Utils.getUser();
    userId = userBean!.data!.id.toString();
  }

  Future<void> _pullRefresh() async {
    setState(() async {
      await Future.delayed(Duration.zero, () {
        getMealScreenItems();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(
      context,
    );

    return new RefreshIndicator(
      onRefresh: _pullRefresh,
      child: Scaffold(
        body: isPageLoading ? Container() : getPaged(),
        appBar: (widget.fromSettings)
            ? AppBar(
                elevation: 0,
                backgroundColor: AppConstant.appColor,
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: (isReplaceDefault == true)
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 65),
                child: FloatingActionButton(
                  backgroundColor: AppConstant.appColor,
                  onPressed: () {
                    setState(() {
                      // _ackAlert(context);
                      successfullyacceptDialog(context);
                      // isReplaceDefault = false;
                      // isReplaceAddPackages = true;
                      //
                      // isReplaceMenu = false;
                      //
                      // isCreatePackages = false;
                    });
                  },
                  child: Icon(Icons.add),
                ),
              )
            : Container(),
      ),
    );
  }

  getPaged() {
    if (isReplaceDefault == true) {
      // return addDafultIcon();
      return packageList();
      // return addMenu();
    } else if (isReplaceAddPackages == true) {
      return addPackages();
    } else if (isReplaceMenu == true) {
      return addMenu();
    } else if (isCreatePackages == true) {
      return createPackage();
    } else if (isPackageEdit == true) {
      return editPackages();
    }
  }

  addMenu() {
    var cuisineData = bean!.data!.cuisinetype!.split(',');
    var cuisineFinal = '';
    for (int i = 0; i < cuisineData.length; i++) {
      if (cuisineData[i] == '0') {
        cuisineFinal += 'South Indian,';
      } else if (cuisineData[i] == '1') {
        cuisineFinal += 'North Indian,';
      } else if (cuisineData[i] == '2') {
        cuisineFinal += 'Diet Meals,';
      } else if (cuisineData[i] == '3') {
        cuisineFinal += 'Other Cuisine,';
      }
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 16,
            ),
            height: 60,
            child: Row(
              children: [
                Text(
                  bean!.data!.mealfor == '0'
                      ? "Breakfast"
                      : bean!.data!.mealfor == '1'
                          ? "Lunch"
                          : "Dinner",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstant.fontBold,
                      fontSize: 16),
                ),
                VerticalDivider(
                  color: Colors.grey,
                  width: 20,
                ),
                SizedBox(
                  width: 16,
                ),
                Image.asset(
                  mealIcon(bean!.data!.mealtype!),
                  width: 20,
                  height: 20,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  bean!.data!.mealtype == "0"
                      ? "Veg"
                      : bean!.data!.mealtype == "1"
                          ? "Non-veg"
                          : "Veg/ Non-veg",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstant.fontBold,
                      fontSize: 16),
                ),
                SizedBox(
                  width: 16,
                ),
                VerticalDivider(color: Colors.grey, width: 20),
                Expanded(
                  child: Text(
                    cuisineFinal,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppConstant.fontBold,
                        fontSize: 16),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Divider(
            color: Colors.grey.shade400,
          ),
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return getList(
                bean!.data!.weeklyDetail!,
                index,
                bean!.data!.packageId!,
                cuisineFinal,
                bean!.data!.mealtype == "0"
                    ? "Veg"
                    : bean!.data!.mealtype == "1"
                        ? "Non-veg"
                        : "Veg/ Non-veg",
              );
            },
            itemCount: bean!.data!.weeklyDetail!.length,
          ),
          SizedBox(
            height: 60,
          ),
          GestureDetector(
            onTap: () {
              for (int i = 0; i < Files.length; i++) {
                if (Files[i].toString() == 'null') {
                } else {
                  postImage(i);
                }
              }

              getPackagePriceDetail(context).then((value) {
                setState(() {
                  isCreatePackages = true;
                  addDefaultIcon = false;
                  isReplaceMenu = false;
                  isReplaceAddPackages = false;
                });
              });
            },
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              height: 55,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "SET PRICE",
                  style: TextStyle(
                      color: Colors.white, fontFamily: AppConstant.fontBold),
                ),
              ),
            ),
          ),
          AppConstant().navBarHt()
        ],
      ),
      physics: BouncingScrollPhysics(),
    );
  }

  Future postImage(int index) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("https://nohung.com/api/kitchen/add_package_info.php"),
    );
    request.fields['token'] = '123456789';
    request.fields['kitchen_id'] = userId;
    request.fields['package_id'] = bean!.data!.packageId!;
    request.fields['day'] = (index + 1).toString();
    request.fields['token'] = '123456789';

    var pic = await http.MultipartFile.fromPath("image", Files[index]);
    request.files.add(pic);

    //Get the response from the server
  }

  /*Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
          child: Container(
            padding: EdgeInsets.all(12),
            height: 250,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.cancel),
                  ),
                ),
                Text(
                  "Contact Nohung\n to add packages",
                  style: TextStyle(
                      fontSize: 20, fontFamily: AppConstant.fontRegular),
                ),
                SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  child: Text('Contact'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppConstant.appColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/adminChat');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerChatScreen(),),
                    );
                    Navigator.pop(context);
                    //_launchInBrowser(toLaunch);
                    // Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }*/
  Future<void> successfullyacceptDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(12),
          )),
          child: Container(
            //height: 200,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                height: 10,
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
              SizedBox(
                height: 15,
              ),
              Image.asset(
                Res.ic_contact_us_image,
                fit: BoxFit.fill,
                //width: 16,
                height: 170,
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                "contact NOHUNG \nto add packages",
                style: TextStyle(
                    fontFamily: AppConstant.fontRegular, fontSize: 16),
              ),
              InkWell(
                onTap: () async {
                  await Navigator.pushNamed(context, '/adminChat');
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppConstant.appColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      'Contact',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: AppConstant.fontRegular),
                    ),
                  ),
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

  addDafultIcon() {
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
                        Res.ic_default_order,
                        width: 220,
                        height: 120,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    "No package added yet",
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
                    "look's like you, haven't\n made your package yet.",
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
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isReplaceDefault = false;
                        isReplaceAddPackages = true;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Color(0xffFFA451),
                        boxShadow: [
                          BoxShadow(blurRadius: 2, color: Colors.grey.shade300)
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "CREATE PACKAGE",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontFamily: AppConstant.fontBold),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            AppConstant().navBarHt()
          ],
        ),
        physics: BouncingScrollPhysics(),
      ),
    );
  }

  getList(
    List<WeeklyDetail> choic,
    int index,
    String packageId,
    String cuisine,
    String mealType,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              mealDay(choic[index].day!),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: AppConstant.fontBold),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showPicker(context, index);
            },
            child: Padding(
                padding: EdgeInsets.only(right: 36, left: 5),
                child: Image(
                  image: (Files[index].toString() == 'null')
                      ? NetworkImage(choic[index].image!)
                      : FileImage(
                          File(Files[index]),
                        ) as ImageProvider,
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                )
                // Image.file(
                //   choic[index].image,

                // ),
                ),
          ),
          Expanded(
            child: Text(
              choic[index].itemName.toString(),
              style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 14,
                  fontFamily: AppConstant.fontRegular),
            ),
          ),
          SizedBox(width: 16),
          InkWell(
            onTap: () {
              // -
              successfullyacceptDialog(context);
              //_ackAlert(context);
            },
            child: Container(
              height: 50,
              margin: EdgeInsets.only(right: 10),
              width: 50,
              decoration: BoxDecoration(
                color: AppConstant.appColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Image.asset(
                  Res.ic_plus,
                  width: 15,
                  height: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String mealIcon(String meal) {
    switch (meal) {
      case 'Breakfast':
        return Res.ic_breakfast;
      case 'Lunch':
        return Res.ic_dinner;
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

  String mealDay(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Wrong day';
    }
  }

  Widget getItems(BeanGetPackagesData item) {
    var cuisineItemsData = item.cuisinetype!.split(',');
    var cuisineFinal = '';
    for (int i = 0; i < cuisineItemsData.length; i++) {
      if (cuisineItemsData[i] == '0') {
        cuisineFinal += 'South Indian,';
      } else if (cuisineItemsData[i] == '1') {
        cuisineFinal += 'North Indian,';
      } else if (cuisineItemsData[i] == '2') {
        cuisineFinal += 'Diet Meals,';
      } else if (cuisineItemsData[i] == '3') {
        cuisineFinal += 'Other Cuisine,';
      }
    }

    return LayoutBuilder(
      builder: (_, c) {
        final width = c.maxWidth;
        var fontSize = 10.0;
        if (width <= 380) {
          fontSize = 8.0;
        }
        if (width < 380 && width <= 480) {
          fontSize = 10.0;
        } else if (width > 480 && width <= 960) {
          fontSize = 12.0;
        } else if (width > 380 && width <= 844) {
          fontSize = 11.5;
        } else {
          fontSize = 12.0;
        }
        return Container(
          margin: EdgeInsets.all(6),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade600, spreadRadius: 1, blurRadius: 2)
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    (item.mealtype == '0')
                        ? Image.asset(
                            Res.ic_veg,
                            width: 20,
                            height: 20,
                          )
                        : Image.asset(
                            Res.ic_chiken,
                            width: 20,
                            height: 20,
                          ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      item.packagename!,
                      style: TextStyle(
                          fontFamily: AppConstant.fontBold, fontSize: 16),
                    ),
                  ]),
                  Spacer(),
                  Container(
                    child: Switch(
                      value: item.displayInFoodie == 'y' ? true : false,
                      onChanged: (value) async {
                        print(value);

                        updatePackageStatus(value, item.packageId)
                            .then((value) {
                          getMealScreenItems();
                        });

                        setState(() {
                          item.displayInFoodie =
                              item.displayInFoodie == 'y' ? 'n' : 'y';
                        });
                      },
                      activeColor: AppConstant.appColor,
                      activeTrackColor: AppConstant.appColorLite,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     _ackAlert(context);
                  //     // getMenuPackageList(item.packageId!).then((value) {
                  //     //   setState(() {
                  //     //     createPackageid = item.packageId;
                  //     //     isReplaceDefault = false;
                  //     //     addDefaultIcon = false;
                  //     //     isReplaceMenu = false;
                  //     //     isPackageEdit = true;
                  //     //     isReplaceAddPackages = false;
                  //     //   });
                  //     // });
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(top: 8.0),
                  //     child: Image.asset(
                  //       Res.ic_edit,
                  //       width: 20,
                  //       height: 20,
                  //       color: Colors.grey,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(width: 15),
                  // IconButton(
                  //   onPressed: () {
                  //
                  //       _deletePackage(context, item.packageId.toString());
                  //
                  //   },
                  //   icon: Icon(Icons.delete, color: AppConstant.appColor),
                  // ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'From ' + item.createddate!.substring(0, 10),
                        style: TextStyle(fontFamily: AppConstant.fontBold),
                      ),
                      Row(
                        children: [
                          Text(
                            'Including',
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: AppConstant.fontRegular),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          (item.includingSaturday == '1')
                              ? Text(
                                  'Saturday,',
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontRegular),
                                )
                              : Text(''),
                          (item.includingSunday == '1')
                              ? Text(
                                  ' Sunday',
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontRegular),
                                )
                              : Text(''),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Meal for',
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: AppConstant.fontBold),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            Res.ic_breakfast,
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(width: 7),
                          Text(
                            (item.mealfor == '0')
                                ? 'Breakfast'
                                : (item.mealfor == '1')
                                    ? 'Lunch'
                                    : (item.mealfor == "2")
                                        ? 'Dinner'
                                        : "BreakFast,Lunch,Dinner",
                            style: TextStyle(
                                fontFamily: AppConstant.fontBold, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Type of cuisine',
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: AppConstant.fontBold),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.10,
                        ),
                        Expanded(
                          child: Container(
                            // color: Colors.red,
                            alignment: Alignment.topRight,
                            child: Text(
                              "$cuisineFinal",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: AppConstant.fontBold,
                                  fontSize: MySize.size13 /*10*/),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (item.weeklyplantype == '1')
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppConstant.rupee + item.weeklyprice!,
                              style: TextStyle(
                                  color: AppConstant.lightGreen,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Weekly  Package',
                              style: TextStyle(
                                  fontFamily: AppConstant.fontRegular),
                            ),
                          ],
                        )
                      : Container(),
                  (item.monthlyplantype == '1')
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppConstant.rupee + item.monthlyprice!,
                              style: TextStyle(
                                fontFamily: AppConstant.fontBold,
                                color: AppConstant.lightGreen,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Monthly Package',
                              style: TextStyle(
                                  fontFamily: AppConstant.fontRegular),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  packageList() {
    return (userBean!.data == null)
        ? Container()
        : (getPackagesbean!.status == false)
            ? addDafultIcon()
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: getPackagesbean!.data!.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return getItems(getPackagesbean!.data![index]);
                      },
                    ),
                    AppConstant().navBarHt()
                  ],
                ),
              );
  }

  addPackages() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Packages Name",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontRegular),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: TextField(
              controller: packagename,
              decoration: InputDecoration(hintText: "Package 1"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Type of Cuisine",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontRegular),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      cuisineSI = cuisineSI == 0 ? -1 : 0;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 110,
                    margin: EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: cuisineSI == 0
                          ? Color(0xffFFA451)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "South Indian",
                        style: TextStyle(
                            color: cuisineSI == 0 ? Colors.white : Colors.black,
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
                      cuisineNI = cuisineNI == 1 ? -1 : 1;
                    });
                  },
                  child: Container(
                    height: 40,
                    margin: EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: cuisineNI == 1
                          ? Color(0xffFFA451)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "North Indian",
                        style: TextStyle(
                            color: cuisineNI == 1 ? Colors.white : Colors.black,
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
                      cuisineDM = cuisineDM == 2 ? -1 : 2;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 110,
                    margin: EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: cuisineDM == 2
                          ? Color(0xffFFA451)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Diet Meals",
                        style: TextStyle(
                            color: cuisineDM == 2 ? Colors.white : Colors.black,
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
                      cuisineOC = cuisineOC == 3 ? -1 : 3;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 110,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: cuisineOC == 3
                          ? Color(0xffFFA451)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Other Cuisine",
                        style: TextStyle(
                            color: cuisineOC == 3 ? Colors.white : Colors.black,
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
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Meal Type",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontRegular),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Expanded(
              InkWell(
                onTap: () {
                  setState(() {
                    isMealType = 0;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 16,
                  ),
                  height: 45,
                  //width: 50,
                  decoration: BoxDecoration(
                    color:
                        isMealType == 0 ? Color(0xff7EDABF) : Color(0xffF3F6FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        Res.ic_veg,
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Veg",
                        style: TextStyle(
                            color:
                                isMealType == 0 ? Colors.white : Colors.black,
                            fontFamily: AppConstant.fontBold),
                      )
                    ],
                  ),
                ),
              ),
              //),
              //Expanded(
              InkWell(
                onTap: () {
                  setState(() {
                    isMealType = 1;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 5, right: 16),
                  height: 45,
                  //width: 100,
                  decoration: BoxDecoration(
                    color:
                        isMealType == 1 ? Color(0xff7EDABF) : Color(0xffF3F6FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        Res.ic_chiken,
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Non Veg",
                        style: TextStyle(
                            color:
                                isMealType == 1 ? Colors.white : Colors.black,
                            fontFamily: AppConstant.fontBold),
                      )
                    ],
                  ),
                ),
              ),
              // ),
              //Expanded(
              InkWell(
                onTap: () {
                  setState(() {
                    isMealType = 2;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 16,
                  ),
                  height: 45,
                  // width: 110,
                  decoration: BoxDecoration(
                    color:
                        isMealType == 2 ? Color(0xff7EDABF) : Color(0xffF3F6FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Veg / Non-Veg",
                        style: TextStyle(
                            color:
                                isMealType == 2 ? Colors.white : Colors.black,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ],
                  ),
                ),
              ),
              //  ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Meal For",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontRegular),
            ),
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
                      isSelectMenu = 0;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 110,
                    margin: EdgeInsets.only(left: 16, top: 16),
                    decoration: BoxDecoration(
                      color: isSelectMenu == 0
                          ? Color(0xffFEDF7C)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Breakfast",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSelectMenu = 1;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16, top: 16),
                    height: 50,
                    width: 110,
                    decoration: BoxDecoration(
                      color: isSelectMenu == 1
                          ? Color(0xffFEDF7C)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Lunch",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSelectMenu = 2;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16, top: 16, right: 10),
                    height: 50,
                    width: 110,
                    decoration: BoxDecoration(
                      color: isSelectMenu == 2
                          ? Color(0xffFEDF7C)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Dinner",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Plan Type",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontRegular),
            ),
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
                      isSelectPlanTypeWeekly = !isSelectPlanTypeWeekly;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 110,
                    margin: EdgeInsets.only(left: 16, top: 16, right: 16),
                    decoration: BoxDecoration(
                      color: isSelectPlanTypeWeekly
                          ? Color(0xffFEDF7C)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Weekly",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSelectPlanTypeMonthly = !isSelectPlanTypeMonthly;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16, top: 16, right: 16),
                    height: 50,
                    width: 110,
                    decoration: BoxDecoration(
                      color: isSelectPlanTypeMonthly
                          ? Color(0xffFEDF7C)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Monthly",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 26),
            child: Text(
              "Start Date",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontBold),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(date == "" ? "select date" : date),
              ),
              InkWell(
                onTap: () async {
                  var result = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 10),
                    lastDate: DateTime(DateTime.now().year + 10),
                  );
                  setState(() {
                    date = result!.year.toString() +
                        "-" +
                        result.month.toString() +
                        "-" +
                        result.day.toString();
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Image.asset(
                    Res.ic_calendar,
                    width: 20,
                    height: 20,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, top: 16),
                    child: Text(
                      'Including Saturday',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: AppConstant.fontRegular),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  width: 30,
                  margin: EdgeInsets.only(right: 20, top: 10),
                  child: CupertinoSwitch(
                    activeColor: Color(0xff7EDABF),
                    value: _other2,
                    onChanged: (newValue) {
                      setState(() {
                        _other2 = newValue;
                        if (_other2 == true) {
                        } else {}
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, top: 16),
                    child: Text(
                      'Including Sunday',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: AppConstant.fontRegular),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  width: 30,
                  margin: EdgeInsets.only(right: 20, top: 10),
                  child: CupertinoSwitch(
                    activeColor: Color(0xff7EDABF),
                    value: sunday,
                    onChanged: (newValue) {
                      setState(() {
                        sunday = newValue;
                        if (sunday == true) {
                        } else {}
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 80,
          ),
          InkWell(
            onTap: () {
              setState(() {
                validation();
              });
            },
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              height: 55,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "SET MENU",
                  style: TextStyle(
                      color: Colors.white, fontFamily: AppConstant.fontBold),
                ),
              ),
            ),
          ),
          AppConstant().navBarHt()
        ],
      ),
    );
  }

  createPackage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            height: 150,
            child: Center(
              child:
                  Image.asset(Res.ic_create_package, width: 130, height: 130),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  child: Text(
                    AppConstant.rupee +
                        " " +
                        beanprice!.data!.actualWeeklyPackage!,
                    style: TextStyle(
                        color: Color(0xff7EDABF),
                        fontFamily: AppConstant.fontBold,
                        fontSize: 18),
                  ),
                  padding: EdgeInsets.only(left: 16, top: 16),
                ),
              ),
              Padding(
                child: Text(
                  AppConstant.rupee +
                      " " +
                      beanprice!.data!.actualMonthlyPackage!,
                  style: TextStyle(
                      color: Color(0xff7EDABF),
                      fontFamily: AppConstant.fontBold,
                      fontSize: 18),
                ),
                padding: EdgeInsets.only(left: 16, top: 16, right: 16),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  child: Text(
                    "Actual Total Price",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppConstant.fontRegular,
                        fontSize: 14),
                  ),
                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                ),
              ),
              Padding(
                child: Text(
                  "Actual Total Price",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstant.fontRegular,
                      fontSize: 14),
                ),
                padding: EdgeInsets.only(top: 16, right: 16),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  child: Text(
                    "Weekly Package",
                    style: TextStyle(
                        color: Color(0xff555555),
                        fontFamily: AppConstant.fontBold,
                        fontSize: 14),
                  ),
                  padding: EdgeInsets.only(left: 16, top: 8, right: 16),
                ),
              ),
              Padding(
                child: Text(
                  "Monthly Package",
                  style: TextStyle(
                      color: Color(0xff555555),
                      fontFamily: AppConstant.fontBold,
                      fontSize: 14),
                ),
                padding: EdgeInsets.only(top: 8, right: 16),
              ),
            ],
          ),
          Padding(
            child: Text(
              "Set your price (weekly)",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontBold,
                  fontSize: 14),
            ),
            padding: EdgeInsets.only(left: 16, top: 30, right: 16),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 100,
                  margin: EdgeInsets.only(right: 16, left: 16),
                  child: TextField(
                    onChanged: (val) {
                      double diff = double.parse(weekly.text) -
                          double.parse(
                            beanprice!.data!.actualWeeklyPackage.toString(),
                          );
                      setState(() {
                        variance = double.parse(((diff /
                                    double.parse(beanprice!
                                        .data!.actualWeeklyPackage!)) *
                                100)
                            .toStringAsFixed(2));
                      });
                    },
                    controller: weekly,
                    decoration:
                        InputDecoration(hintText: AppConstant.rupee + "25,00"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  "Variation",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: AppConstant.fontRegular),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  variance.toString() + " %",
                  // .substring(0, 5) + " %",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: AppConstant.fontRegular),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            child: Text(
              "Set your price (Monthly)",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontBold,
                  fontSize: 14),
            ),
            padding: EdgeInsets.only(left: 16, top: 30, right: 16),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 100,
                  margin: EdgeInsets.only(right: 16, left: 16),
                  child: TextField(
                    onChanged: (val) {
                      double diff = double.parse(monthly.text) -
                          double.parse(
                              beanprice!.data!.actualMonthlyPackage.toString());
                      setState(() {
                        varianceMontly = double.parse(((diff /
                                    double.parse(beanprice!
                                        .data!.actualMonthlyPackage!)) *
                                100)
                            .toStringAsFixed(2));
                      });
                    },
                    controller: monthly,
                    decoration:
                        InputDecoration(hintText: AppConstant.rupee + "25,00"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  "Variation",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: AppConstant.fontRegular),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Text(
                  varianceMontly.toString() + " %",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: AppConstant.fontRegular),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              addPackagePriceValidation(createPackageid);
            },
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 15),
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xffFFA451),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "CREATE PACKAGE",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: AppConstant.fontBold),
                ),
              ),
            ),
          ),
          AppConstant().navBarHt()
        ],
      ),
    );
  }

  editPackages() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Packages Name",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontRegular),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: TextField(
              controller: packagenameEdit,
              decoration: InputDecoration(hintText: "Package 1"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Type of Cuisine",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontRegular),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      cuisineSIE = cuisineSIE == 0 ? -1 : 0;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 110,
                    margin: EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: cuisineSIE == 0
                          ? Color(0xffFFA451)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "South Indian",
                        style: TextStyle(
                            color:
                                cuisineSIE == 0 ? Colors.white : Colors.black,
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
                      cuisineNIE = cuisineNIE == 1 ? -1 : 1;
                    });
                  },
                  child: Container(
                    height: 40,
                    margin: EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: cuisineNIE == 1
                          ? Color(0xffFFA451)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "North Indian",
                        style: TextStyle(
                            color:
                                cuisineNIE == 1 ? Colors.white : Colors.black,
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
                      cuisineDME = cuisineDME == 2 ? -1 : 2;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 110,
                    margin: EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: cuisineDME == 2
                          ? Color(0xffFFA451)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Diet Meals",
                        style: TextStyle(
                            color:
                                cuisineDME == 2 ? Colors.white : Colors.black,
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
                      cuisineOCE = cuisineOCE == 3 ? -1 : 3;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 110,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: cuisineOCE == 3
                          ? Color(0xffFFA451)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Other Cuisine",
                        style: TextStyle(
                            color:
                                cuisineOCE == 3 ? Colors.white : Colors.black,
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
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Meal Type",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontRegular),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Expanded(
              InkWell(
                onTap: () {
                  setState(() {
                    isMealTypeEdit = 0;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 16,
                  ),
                  height: 45,
                  //width: 50,
                  decoration: BoxDecoration(
                    color: isMealTypeEdit == 0
                        ? Color(0xff7EDABF)
                        : Color(0xffF3F6FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        Res.ic_veg,
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Veg",
                        style: TextStyle(
                            color: isMealTypeEdit == 0
                                ? Colors.white
                                : Colors.black,
                            fontFamily: AppConstant.fontBold),
                      )
                    ],
                  ),
                ),
              ),
              //),
              //Expanded(
              InkWell(
                onTap: () {
                  setState(() {
                    isMealTypeEdit = 1;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 5, right: 16),
                  height: 45,
                  //width: 100,
                  decoration: BoxDecoration(
                    color: isMealTypeEdit == 1
                        ? Color(0xff7EDABF)
                        : Color(0xffF3F6FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        Res.ic_chiken,
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Non Veg",
                        style: TextStyle(
                            color: isMealTypeEdit == 1
                                ? Colors.white
                                : Colors.black,
                            fontFamily: AppConstant.fontBold),
                      )
                    ],
                  ),
                ),
              ),
              // ),
              //Expanded(
              InkWell(
                onTap: () {
                  setState(() {
                    isMealTypeEdit = 2;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: 5,
                    right: 16,
                  ),
                  height: 45,
                  // width: 110,
                  decoration: BoxDecoration(
                    color: isMealTypeEdit == 2
                        ? Color(0xff7EDABF)
                        : Color(0xffF3F6FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Veg / Non-Veg",
                        style: TextStyle(
                            color: isMealTypeEdit == 2
                                ? Colors.white
                                : Colors.black,
                            fontFamily: AppConstant.fontBold),
                      ),
                      // Image.asset(
                      //   Res.ic_veg,
                      //   width: 20,
                      //   height: 20,
                      // ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      // Text(
                      //   "Veg /",
                      //   style: TextStyle(
                      //       color:
                      //           isMealType == 2 ? Colors.white : Colors.black,
                      //       fontFamily: AppConstant.fontBold),
                      // ),
                      // Image.asset(
                      //   Res.ic_chiken,
                      //   width: 20,
                      //   height: 20,
                      // ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      // Text(
                      //   "Non Veg ",
                      //   style: TextStyle(
                      //       color:
                      //           isMealType == 2 ? Colors.white : Colors.black,
                      //       fontFamily: AppConstant.fontBold),
                      // ),
                    ],
                  ),
                ),
              ),
              //  ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Meal For",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontRegular),
            ),
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
                      isSelectMenuEdit = 0;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 110,
                    margin: EdgeInsets.only(left: 16, top: 16),
                    decoration: BoxDecoration(
                      color: isSelectMenuEdit == 0
                          ? Color(0xffFEDF7C)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Breakfast",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSelectMenuEdit = 1;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16, top: 16),
                    height: 50,
                    width: 110,
                    decoration: BoxDecoration(
                      color: isSelectMenuEdit == 1
                          ? Color(0xffFEDF7C)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Lunch",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSelectMenuEdit = 2;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16, top: 16, right: 10),
                    height: 50,
                    width: 110,
                    decoration: BoxDecoration(
                      color: isSelectMenuEdit == 2
                          ? Color(0xffFEDF7C)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Dinner",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text(
              "Plan Type",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontRegular),
            ),
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
                      isSelectPlanTypeWeeklyEdit = !isSelectPlanTypeWeeklyEdit;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 110,
                    margin: EdgeInsets.only(left: 16, top: 16, right: 16),
                    decoration: BoxDecoration(
                      color: isSelectPlanTypeWeeklyEdit
                          ? Color(0xffFEDF7C)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Weekly",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSelectPlanTypeMonthlyEdit =
                          !isSelectPlanTypeMonthlyEdit;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16, top: 16, right: 16),
                    height: 50,
                    width: 110,
                    decoration: BoxDecoration(
                      color: isSelectPlanTypeMonthlyEdit
                          ? Color(0xffFEDF7C)
                          : Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Monthly",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: AppConstant.fontBold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, top: 26),
            child: Text(
              "Start Date",
              style: TextStyle(
                  color: AppConstant.appColor,
                  fontFamily: AppConstant.fontBold),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(dateEdit == "" ? "select date" : dateEdit),
              ),
              InkWell(
                onTap: () async {
                  var result = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 10),
                    lastDate: DateTime(DateTime.now().year + 10),
                  );
                  setState(() {
                    dateEdit = result!.year.toString() +
                        "-" +
                        result.month.toString() +
                        "-" +
                        result.day.toString();
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Image.asset(
                    Res.ic_calendar,
                    width: 20,
                    height: 20,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, top: 16),
                    child: Text(
                      'Including Saturday',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: AppConstant.fontRegular),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  width: 30,
                  margin: EdgeInsets.only(right: 20, top: 10),
                  child: CupertinoSwitch(
                    activeColor: Color(0xff7EDABF),
                    value: _other2Edit,
                    onChanged: (newValue) {
                      setState(() {
                        _other2Edit = newValue;
                        if (_other2Edit == true) {
                        } else {}
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, top: 16),
                    child: Text(
                      'Including Sunday',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: AppConstant.fontRegular),
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  width: 30,
                  margin: EdgeInsets.only(right: 20, top: 10),
                  child: CupertinoSwitch(
                    activeColor: Color(0xff7EDABF),
                    value: sundayEdit,
                    onChanged: (newValue) {
                      setState(() {
                        sundayEdit = newValue;
                        if (sundayEdit == true) {
                        } else {}
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 80,
          ),
          InkWell(
            onTap: () {
              setState(() {
                editvalidation();
              });
            },
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              height: 55,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "SET MENU",
                  style: TextStyle(
                      color: Colors.white, fontFamily: AppConstant.fontBold),
                ),
              ),
            ),
          ),
          AppConstant().navBarHt()
        ],
      ),
    );
  }

  Future<BeanPackagePriceDetail> getPackagePriceDetail(
      BuildContext context) async {
    // FormData from = FormData.fromMap({
    //   "kitchen_id": userId,
    //   "token": '123456789',
    //   "package_id": createPackageid,
    // });

    BeanPackagePriceDetail beanprice =
        await ApiProvider().getPackagePriceDetail(createPackageid);

    if (bean!.status == true) {
      return beanprice;
    } else {
      return Utils.showToast(bean!.message ?? "", context);
    }
  }

  void addPackagePriceValidation(String packageId) {
    if (weekly.text.isEmpty) {
      Utils.showToast("please enter weekly price", context);
    } else if (monthly.text.isEmpty) {
      Utils.showToast("please enter monthly price", context);
    } else {
      addPackagePrice(context, packageId);
    }
  }

  Future<BeanAddPackagePrice> addPackagePrice(
      BuildContext context, String packageId) async {
    // FormData from = FormData.fromMap({
    //   "kitchen_id": userId,
    //   "token": '123456789',
    //   "package_id": packageId,
    //   "weekly_price": weekly.text.toString(),
    //   "monthly_price": monthly.text.toString(),
    // });

    BeanAddPackagePrice? bean = await ApiProvider()
        .addPackagePrice(packageId, weekly.text, monthly.text);

    if (bean.status == true) {
      weekly.clear();
      monthly.clear();
      variance = 0.0;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessPackageScreen(),
        ),
      ).then((value) {
        setState(() {
          getMealScreenItems();
          isReplaceDefault = true;
          isReplaceMenu = false;
          isReplaceAddPackages = false;
          isCreatePackages = false;
        });
      });
      return bean;
    } else {
      return Utils.showToast(bean.message ?? "", context);
    }
  }

  Future<BeanAddMenu?> getMenuPackageList(String packageId) async {
    // FormData from = FormData.fromMap({
    //   "kitchen_id": userId,
    //   "token": "123456789",
    //   "package_id": packageId,
    // });
    BeanAddMenu bean = await ApiProvider().getMenuPackageList(packageId);

    if (bean.status == true) {
      setState(() {
        packagenameEdit.text = bean.data!.packagename ?? '';

        final cuisineSplit = bean.data!.cuisinetype!.split(',');
        for (int i = 0; i < cuisineSplit.length; i++) {
          if (cuisineSplit[i] == '0') {
            cuisineSIE = 0;
          } else if (cuisineSplit[i] == '1') {
            cuisineNIE = 1;
          } else if (cuisineSplit[i] == '2') {
            cuisineDME = 2;
          } else if (cuisineSplit[i] == '3') {
            cuisineOCE = 3;
          }
        }
        isMealTypeEdit = bean.data!.mealtype == "0"
            ? 0
            : bean.data!.mealtype == "1"
                ? 1
                : 2;
        isSelectMenuEdit = bean.data!.mealfor == "0"
            ? 0
            : bean.data!.mealfor == "1"
                ? 1
                : 2;
        isSelectPlanTypeWeeklyEdit =
            bean.data!.weeklyPlanType == "1" ? true : false;
        isSelectPlanTypeMonthlyEdit =
            bean.data!.monthlyPlanType == "1" ? true : false;
        dateEdit = bean.data!.startDate!;
        _other2Edit = bean.data!.includingSaturday == "1" ? true : false;
        sundayEdit = bean.data!.includingSunday == "1" ? true : false;
      });
      setState(() {
        bean = bean;
        packageId = packageId;
      });
      return bean;
    } else {
      Utils.showToast(bean.message ?? "", context);
      return bean;
    }
  }

  Future<void> updatePackageStatus(value, packageId) async {
    // FormData form = FormData.fromMap({
    //   "token": "123456789",
    //   "status": value ? "y" : "n",
    //   "kitchen_id": userBean!.data!.id.toString(),
    //   "package_id": packageId
    // });
    packageStatus = await ApiProvider().updatePackageStatus(
        value == true ? "y" : "n" /*value ==false?"n":""*/, packageId);
    if (packageStatus!.status == true) {
      Utils.showToast(packageStatus!.message ?? "", context);

      setState(() {
        // isKitchenActive = value;
      });
    } else {
      Utils.showToast(packageStatus!.message ?? "", context);
    }
  }

  Future<BeanGetPackages?> getMealScreenItems() async {
    // FormData from = FormData.fromMap({
    //
    //   "token": "123456789",
    // });
    getPackagesbean = await ApiProvider().getPackages();

    if (getPackagesbean!.status == true) {
      setState(() {
        isPageLoading = false;
      });
      return getPackagesbean;
    } else {
      Utils.showToast(getPackagesbean!.message ?? "", context);
      setState(() {});
      return getPackagesbean;
    }
  }

  Future<BeanDeletePackage> deletePackage(String packageId) async {
    // FormData from = FormData.fromMap({
    //   "kitchen_id": userId,
    //   "token": "123456789",
    //   "package_id": packageId,
    // });
    BeanDeletePackage? bean = await ApiProvider().deletePackage(packageId);

    if (bean.status == true) {
      getMealScreenItems();
      Navigator.pop(context);
      Utils.showToast(bean.message ?? "", context);

      return bean;
    } else {
      return Utils.showToast(bean.message ?? "", context);
    }
  }

  Future? _showPicker(context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        setState(() {
                          _imgFromGallery(index);
                        });

                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      setState(() {
                        _imgFromCamera(index);
                      });

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
    return null;
  }

  Future _imgFromCamera(int index) async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    //.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      mediaFile = image as PickedFile;
      Files.insert(index, mediaFile!.path);
    });
  }

  Future _imgFromGallery(int index) async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      mediaFile = image as PickedFile;
      Files.insert(index, mediaFile!.path);
    });
  }

  Future addPackage(BuildContext context, String packName) async {
    // FormData from = FormData.fromMap({
    //   "user_id": userId,
    //   "token": "123456789",
    //   "package_name": packName,
    //   "cuisine_type": ((cuisineSI == 0 ? "$cuisineSI," : "") +
    //       (cuisineNI == 1 ? "$cuisineNI," : '') +
    //       (cuisineDM == 2 ? "$cuisineDM," : "") +
    //       (cuisineOC == 3 ? "$cuisineOC," : "")),
    //   "meal_type": isMealType == 0
    //       ? "0"
    //       : isMealType == 1
    //           ? "1"
    //           : isMealType == 2
    //               ? "2"
    //               : "",
    //   "meal_for": isSelectMenu == 0
    //       ? "0"
    //       : isSelectMenu == 1
    //           ? "1"
    //           : isSelectMenu == 2
    //               ? "2"
    //               : "",
    //   "weekly_plan_type": isSelectPlanTypeWeekly ? '1' : '0',
    //   "monthly_plan_type": isSelectPlanTypeMonthly ? '1' : '0',
    //   "start_date": date,
    //   "including_saturday": _other2 == false ? "0" : "1",
    //   "including_sunday": sunday == false ? "0" : "1"
    // });
    var bean = await ApiProvider().addPackage(
        packName,
        ((cuisineSI == 0 ? "$cuisineSI," : "") +
            (cuisineNI == 1 ? "$cuisineNI," : '') +
            (cuisineDM == 2 ? "$cuisineDM," : "") +
            (cuisineOC == 3 ? "$cuisineOC," : "")),
        isMealType == 0
            ? "0"
            : isMealType == 1
                ? "1"
                : isMealType == 2
                    ? "2"
                    : "",
        isSelectMenu == 0
            ? "0"
            : isSelectMenu == 1
                ? "1"
                : isSelectMenu == 2
                    ? "2"
                    : "",
        isSelectPlanTypeWeekly ? '1' : '0',
        isSelectPlanTypeMonthly ? '1' : '0',
        date,
        _other2 == false ? "0" : "1",
        sunday == false ? "0" : "1");

    if (bean.status == true) {
      Utils.showToast(bean.message ?? "", context);
      setState(() {
        getMenuPackageList(bean.data![0].packageId!);

        createPackageid = bean.data![0].packageId;
        isReplaceDefault = false;
        addDefaultIcon = false;
        isReplaceMenu = true;
        isPackageEdit = false;
        isReplaceAddPackages = false;
      });

      return bean;
    } else {
      Utils.showToast(bean.message ?? "", context);
    }
  }

  Future updatePackage(BuildContext context, String packName) async {
    // FormData from = FormData.fromMap({
    //   "user_id": userId,
    //   "token": "123456789",
    //   "package_name": packName,
    //   "cuisine_type": ((cuisineSIE == 0 ? "$cuisineSIE," : "") +
    //       (cuisineNIE == 1 ? "$cuisineNIE," : '') +
    //       (cuisineDME == 2 ? "$cuisineDME," : "") +
    //       (cuisineOCE == 3 ? "$cuisineOCE," : "")),
    //   "meal_type": isMealTypeEdit == 0
    //       ? "0"
    //       : isMealTypeEdit == 1
    //           ? "1"
    //           : isMealTypeEdit == 2
    //               ? "2"
    //               : "",
    //   "meal_for": isSelectMenuEdit == 0
    //       ? "0"
    //       : isSelectMenuEdit == 1
    //           ? "1"
    //           : isSelectMenuEdit == 2
    //               ? "2"
    //               : "",
    //   "weekly_plan_type": isSelectPlanTypeWeeklyEdit ? '1' : '0',
    //   "monthly_plan_type": isSelectPlanTypeMonthlyEdit ? '1' : '0',
    //   "start_date": dateEdit,
    //   "including_saturday": _other2Edit == false ? "0" : "1",
    //   "including_sunday": sundayEdit == false ? "0" : "1",
    //   "package_id": packageId,
    // });

    var response = await ApiProvider().updatePackage(
      packName,
      packageId,
      ((cuisineSIE == 0 ? "$cuisineSIE," : "") +
          (cuisineNIE == 1 ? "$cuisineNIE," : '') +
          (cuisineDME == 2 ? "$cuisineDME," : "") +
          (cuisineOCE == 3 ? "$cuisineOCE," : "")),
      isMealTypeEdit == 0
          ? "0"
          : isMealTypeEdit == 1
              ? "1"
              : isMealTypeEdit == 2
                  ? "2"
                  : "",
      isSelectMenuEdit == 0
          ? "0"
          : isSelectMenuEdit == 1
              ? "1"
              : isSelectMenuEdit == 2
                  ? "2"
                  : "",
      isSelectPlanTypeWeeklyEdit ? '1' : '0',
      isSelectPlanTypeMonthlyEdit ? '1' : '0',
      dateEdit,
      _other2Edit == false ? "0" : "1",
      sundayEdit == false ? "0" : "1",
    );
    if (response.status == true) {
      Utils.showToast(response.message ?? "", context);

      getMenuPackageList(packageId).then((value) {
        setState(() {
          createPackageid = packageId;
          isReplaceDefault = false;
          addDefaultIcon = false;
          isReplaceMenu = true;
          isPackageEdit = false;
          isReplaceAddPackages = false;
        });
      });

      return response;
    } else {
      Utils.showToast(response.message ?? "", context);
    }
  }

  void editvalidation() {
    var packName = packagenameEdit.text.toString();
    if (packName.isEmpty) {
      Utils.showToast("please select package name", context);
    } else if (cuisineSIE == -1 &&
        cuisineNIE == -1 &&
        cuisineDME == -1 &&
        cuisineOCE == -1) {
      Utils.showToast("please select cuisine type", context);
    } else if (isMealTypeEdit == -1) {
      Utils.showToast("please select meal type", context);
    } else if (isSelectMenuEdit == -1) {
      Utils.showToast("please select meal for", context);
    } else if (dateEdit.isEmpty) {
      Utils.showToast("please add start date", context);
    } else if (!isSelectPlanTypeWeeklyEdit && !isSelectPlanTypeMonthlyEdit) {
      Utils.showToast("please select plan type", context);
    } else {
      updatePackage(context, packName);
    }
  }

  void validation() {
    var packName = packagename.text.toString();
    if (packName.isEmpty) {
      Utils.showToast("please select package name", context);
    } else if (cuisineSI == -1 &&
        cuisineNI == -1 &&
        cuisineDM == -1 &&
        cuisineOC == -1) {
      Utils.showToast("please select cuisine type", context);
    } else if (isMealType == -1) {
      Utils.showToast("please select meal type", context);
    } else if (isSelectMenu == -1) {
      Utils.showToast("please select meal for", context);
    } else if (date.isEmpty) {
      Utils.showToast("please add start date", context);
    } else if (!isSelectPlanTypeWeekly && !isSelectPlanTypeMonthly) {
      Utils.showToast("please select plan type", context);
    } else {
      addPackage(context, packName);
    }
  }
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
