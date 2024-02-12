import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kitchen/main.dart';
import 'package:kitchen/model/BeanSignUp.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/PrefManager.dart';
import 'package:kitchen/utils/Utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/KitchenData/BeanLogin.dart';

class LoginSignUpScreen extends StatefulWidget {
  @override
  _LoginSignUpScreenState createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<LoginSignUpScreen>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  List state = [];
  List city = [];
  String? stateId;
  String? cityId;

  // var password_controller = TextEditingController();
  final kitchenNameController = TextEditingController();
  final kitchenAddressController = TextEditingController();
  final pincodeController = TextEditingController();
  final contactPersonNameController = TextEditingController();
  final contactPersonRoleController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final kitchenContactNoController = TextEditingController();
  final fSSAILicenseNoController = TextEditingController();
  final expiryDateController = TextEditingController();
  final emailController = TextEditingController();
  final panCardController = TextEditingController();
  final gstRegisterController = TextEditingController();
  var dateCtlController = TextEditingController();
  final kitchenIdController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool selected = false;
  File? _uploadImage;
  File? _uploadImage1;
  File? _uploadImage2;
  File? _uploadImage3;
  File? _uploadImage4;
  final picker = ImagePicker();
  var type = "";
  var menuFile = "";
  var panCard = "";
  var gstCertificate = "";
  var fssaiCertificate = "";
  var businessAddressProof = "";

  bool isNext = false;
  bool isDocument = false;

  _uploadImgFromCamera(VerificationDocument documentType) async {
    var permission = await Permission.camera.request();
    if (permission.isGranted) {
      File? uploadingImage = (await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 50)) as File?;
      setState(() {
        final imagePath = uploadingImage!.path;
        switch (documentType) {
          case VerificationDocument.pan:
            _uploadImage = File(imagePath);
            break;
          case VerificationDocument.fssai:
            _uploadImage1 = File(imagePath);
            break;
          case VerificationDocument.gst:
            _uploadImage2 = File(imagePath);
            break;
          case VerificationDocument.bda:
            _uploadImage3 = File(imagePath);
            break;
          case VerificationDocument.menu:
            _uploadImage4 = File(imagePath);
            break;
        }
      });
    }
  }

  Widget commonSizedBoc() => SizedBox(
        height: 15,
      );

  _uploadingFromGallery(VerificationDocument documentType) async {
    var permission = await Permission.storage.request();
    if (permission.isGranted) {
      XFile? uploadingImage = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 50);
      setState(() {
        final imagePath = uploadingImage!.path;
        switch (documentType) {
          case VerificationDocument.pan:
            _uploadImage = File(imagePath);
            break;
          case VerificationDocument.fssai:
            _uploadImage1 = File(imagePath);
            break;
          case VerificationDocument.gst:
            _uploadImage2 = File(imagePath);
            break;
          case VerificationDocument.bda:
            _uploadImage3 = File(imagePath);
            break;
          default:
            _uploadImage4 = File(imagePath);
            break;
        }
      });
    }
  }

  FormData from = FormData.fromMap({'token': '123456789'});
  checkBatteryOptimizationPermissions() async {
    bool? isBatteryOptimizationDisabled =
        await DisableBatteryOptimization.isBatteryOptimizationDisabled;
    print("Nikhil battery");
    print(isBatteryOptimizationDisabled);

    if (!isBatteryOptimizationDisabled!) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    // height: MediaQuery.of(context).size.height / 4,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 25),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(12, 26),
                              blurRadius: 50,
                              spreadRadius: 0,
                              color: Colors.grey.withOpacity(.1)),
                        ]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppConstant.appColor,
                          radius: 25,
                          child: Icon(Icons.priority_high,
                              color: Color(0xffffffff)),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text("Grant Permissions",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 3.5,
                        ),
                        Text(
                          "Enhance Your Experience! \u{1F525} Please disable battery optimization for timely notifications about new and upcoming orders. Stay ahead and never miss out! \u{1F958}",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: Colors.black54),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                            elevation: 0,
                            color: AppConstant.appColor,
                            child: Text(
                              "Grant Permission",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                            ),
                            onPressed: () async {
                              await DisableBatteryOptimization
                                  .showDisableBatteryOptimizationSettings();

                              Navigator.pop(context);
                            }),
                        MaterialButton(
                            elevation: 0,
                            color: Colors.white,
                            child: Text(
                              "No, Thanks",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                  ),
                ));
          });
    }
  }

  @override
  void initState() {
    super.initState();
    checkBatteryOptimizationPermissions();
    ApiProvider().getState().then((value) {
      setState(() {
        state = value['data'];
      });
    });
    setState(() {
      selected = !selected;
    });
    _controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          new Container(
            alignment: Alignment.center,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/ic_bg_login.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: 100,
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0.0,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(0.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          child: Container(
                            color: Colors.white,
                            child: TabBar(
                              unselectedLabelColor: Colors.grey,
                              labelColor: Colors.black,
                              indicatorColor: Colors.black,
                              isScrollable: true,
                              controller: _controller,
                              tabs: [
                                Tab(
                                  child: Text("Login"),
                                ),
                                Tab(
                                  child: Text("SignUp"),
                                ),
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
          ),
          Expanded(
            child: Container(
              child: TabBarView(
                controller: _controller,
                children: <Widget>[
                  UserLogin(),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Welcome,\nUser",
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black,
                                        fontFamily: AppConstant.fontRegular),
                                  ),
                                  SizedBox(height: 10),
                                  isNext == false
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              Text(
                                                "Enter you basic details here",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        AppConstant.fontBold),
                                              ),
                                              commonSizedBoc(),
                                              TextFormField(
                                                controller:
                                                    kitchenNameController,
                                                decoration: InputDecoration(
                                                  labelText: "Kitchen Name",
                                                  fillColor: Colors.grey,
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(
                                                    RegExp("[a-z A-Z]"),
                                                  ),
                                                ],
                                              ),
                                              commonSizedBoc(),
                                              TextField(
                                                controller:
                                                    kitchenAddressController,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                  labelText: "Kitchen Address",
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  fillColor: Colors.grey,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              ),
                                              commonSizedBoc(),
                                              Container(
                                                height: 50,
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  items: state.map((item) {
                                                    return DropdownMenuItem(
                                                      child: Text(item['name']),
                                                      value: item['state_id']
                                                          .toString(),
                                                    );
                                                  }).toList(),
                                                  onChanged: (String? newVal) {
                                                    setState(() {
                                                      city = [];
                                                      stateId = newVal;

                                                      ApiProvider()
                                                          .getCity(stateId!)
                                                          .then((value) {
                                                        setState(() {
                                                          city = value['data'];
                                                          cityId = null;
                                                        });
                                                      });
                                                    });
                                                  },
                                                  value: stateId,
                                                  hint: Text('Select State'),
                                                ),
                                              ),
                                              commonSizedBoc(),
                                              Container(
                                                height: 50,
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  items: city.map((item) {
                                                    return DropdownMenuItem(
                                                      child: Text(item['name']),
                                                      value: item['city_id']
                                                          .toString(),
                                                    );
                                                  }).toList(),
                                                  onChanged: (String? newVal) {
                                                    setState(() {
                                                      cityId = newVal;
                                                    });
                                                  },
                                                  value: cityId,
                                                  hint: Text('Select City'),
                                                ),
                                              ),
                                              commonSizedBoc(),
                                              TextFormField(
                                                controller: pincodeController,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: "Pincode",
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  fillColor: Colors.grey,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      6),
                                                ],
                                                validator: (String? value) {
                                                  if (value!.isEmpty) {
                                                    return "*Pincode needed";
                                                  }
                                                  return value;
                                                },
                                              ),
                                              commonSizedBoc(),
                                              TextFormField(
                                                controller:
                                                    contactPersonNameController,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      "Contact Person Name",
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  fillColor: Colors.grey,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(
                                                    RegExp("[a-z A-Z]"),
                                                  ),
                                                ], // Only,
                                              ),
                                              commonSizedBoc(),
                                              TextField(
                                                controller:
                                                    contactPersonRoleController,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      "Contact Person Role",
                                                  fillColor: Colors.grey,
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(
                                                    RegExp("[a-z A-Z]"),
                                                  ),
                                                ],
                                              ),
                                              commonSizedBoc(),
                                              TextField(
                                                controller:
                                                    mobileNumberController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      10),
                                                ],
                                                decoration: InputDecoration(
                                                  labelText: "Mobile Number",
                                                  fillColor: Colors.grey,
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              ),
                                              commonSizedBoc(),
                                              TextField(
                                                controller:
                                                    kitchenContactNoController,
                                                keyboardType:
                                                    TextInputType.phone,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      10),
                                                ],
                                                decoration: InputDecoration(
                                                  labelText:
                                                      "Kitchen Contact Number",
                                                  fillColor: Colors.grey,
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      validation1();
                                                      // isNext = true;
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 55,
                                                    width: 90,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffFFA451),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13),
                                                    ),
                                                    margin: EdgeInsets.only(
                                                        bottom: 16, right: 8),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Center(
                                                        child: Image.asset(
                                                            Res.ic_back,
                                                            width: 20,
                                                            height: 20),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ])
                                      : SizedBox(),
                                  commonSizedBoc(),
                                  SizedBox(height: 5),
                                  isNext == true
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              Text(
                                                "Enter you business details here",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        AppConstant.fontBold),
                                              ),
                                              commonSizedBoc(),
                                              TextFormField(
                                                controller:
                                                    fSSAILicenseNoController,
                                                keyboardType:
                                                    TextInputType.number,
                                                maxLength: 14,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      "FSSAI Licence Number",
                                                  fillColor: Colors.grey,
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              ),
                                              commonSizedBoc(),
                                              TextFormField(
                                                controller: dateCtlController,
                                                keyboardType:
                                                    TextInputType.text,
                                                onTap: () async {
                                                  var result =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(
                                                        DateTime.now().year -
                                                            10),
                                                    lastDate: DateTime(
                                                        DateTime.now().year +
                                                            10),
                                                  );

                                                  setState(() {
                                                    dateCtlController.text =
                                                        DateFormat(
                                                                'dd-MMM-yyyy')
                                                            .format(result!);
                                                  });
                                                },
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  labelText: "Expiry Date Date",
                                                  fillColor: Colors.grey,
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              ),
                                              commonSizedBoc(),
                                              TextFormField(
                                                controller: emailController,
                                                decoration: InputDecoration(
                                                  labelText: "Email",
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  fillColor: Colors.grey,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              ),
                                              commonSizedBoc(),
                                              TextFormField(
                                                maxLength: 10,
                                                controller: panCardController,
                                                decoration: InputDecoration(
                                                  labelText: "Pan Card",
                                                  fillColor: Colors.grey,
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              ),
                                              commonSizedBoc(),
                                              TextFormField(
                                                maxLength: 12,
                                                controller:
                                                    gstRegisterController,
                                                decoration: InputDecoration(
                                                  labelText: "Gst Registration",
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  fillColor: Colors.grey,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey,
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              ),
                                              commonSizedBoc(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 0,
                                                    top: 20,
                                                    right: 16),
                                                child: Text(
                                                  "Upload Documents",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily:
                                                          AppConstant.fontBold,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              commonSizedBoc(),
                                              isNext == true
                                                  ? Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Pan Card",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          AppConstant
                                                                              .fontRegular,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.08,
                                                                ),
                                                                Text(
                                                                  "FSSAI Certificate",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          AppConstant
                                                                              .fontRegular,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                                SizedBox(
                                                                  height: 90,
                                                                ),
                                                                Text(
                                                                  "GST Certificate",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          AppConstant
                                                                              .fontRegular,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                                SizedBox(
                                                                  height: 100,
                                                                ),
                                                                Text(
                                                                  "Business Address\nProof",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          AppConstant
                                                                              .fontRegular,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.03,
                                                                ),
                                                                Text(
                                                                  "Upload Menu",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          AppConstant
                                                                              .fontRegular,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              width: 12,
                                                            ),
                                                            Column(
                                                              children: [
                                                                //pan card
                                                                _uploadImage ==
                                                                        null
                                                                    ? ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          _uploadProfile(
                                                                              context,
                                                                              VerificationDocument.pan);
                                                                        },
                                                                        style:
                                                                            ButtonStyle(
                                                                          elevation:
                                                                              MaterialStateProperty.all(0),
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(
                                                                            Color(0xffF6F6F6),
                                                                          ),
                                                                          fixedSize:
                                                                              MaterialStateProperty.all(
                                                                            Size(150,
                                                                                40),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "Upload",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontFamily: AppConstant.fontRegular),
                                                                        ),
                                                                      )
                                                                    : Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                _uploadProfile(context, VerificationDocument.pan);
                                                                              },
                                                                              style: ButtonStyle(
                                                                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                                                                elevation: MaterialStateProperty.all(1),
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.edit,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  _uploadImage = null;
                                                                                });
                                                                              },
                                                                              style: ButtonStyle(
                                                                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                                                                elevation: MaterialStateProperty.all(1),
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.delete,
                                                                                color: Colors.black,
                                                                              ),
                                                                            )
                                                                          ]),
                                                                SizedBox(
                                                                  height: 53,
                                                                ),
                                                                // fssai certificate
                                                                _uploadImage1 ==
                                                                        null
                                                                    ? ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          _uploadProfile(
                                                                              context,
                                                                              VerificationDocument.fssai);
                                                                        },
                                                                        style:
                                                                            ButtonStyle(
                                                                          elevation:
                                                                              MaterialStateProperty.all(0),
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(
                                                                            Color(0xffF6F6F6),
                                                                          ),
                                                                          fixedSize:
                                                                              MaterialStateProperty.all(
                                                                            Size(150,
                                                                                40),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "Upload",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontFamily: AppConstant.fontRegular),
                                                                        ),
                                                                      )
                                                                    : Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                _uploadProfile(context, VerificationDocument.bda);
                                                                              },
                                                                              style: ButtonStyle(
                                                                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                                                                elevation: MaterialStateProperty.all(1),
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.edit,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  _uploadImage1 = null;
                                                                                });
                                                                              },
                                                                              style: ButtonStyle(
                                                                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                                                                elevation: MaterialStateProperty.all(1),
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.delete,
                                                                                color: Colors.black,
                                                                              ),
                                                                            )
                                                                          ]),
                                                                SizedBox(
                                                                  height: 64,
                                                                ),

                                                                /// gst certificate
                                                                _uploadImage2 ==
                                                                        null
                                                                    ? ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          _uploadProfile(
                                                                              context,
                                                                              VerificationDocument.gst);
                                                                        },
                                                                        style:
                                                                            ButtonStyle(
                                                                          elevation:
                                                                              MaterialStateProperty.all(0),
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(
                                                                            Color(0xffF6F6F6),
                                                                          ),
                                                                          fixedSize:
                                                                              MaterialStateProperty.all(
                                                                            Size(150,
                                                                                40),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "Upload",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontFamily: AppConstant.fontRegular),
                                                                        ),
                                                                      )
                                                                    : Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                _uploadProfile(context, VerificationDocument.gst);
                                                                              },
                                                                              style: ButtonStyle(
                                                                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                                                                elevation: MaterialStateProperty.all(1),
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.edit,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  _uploadImage2 = null;
                                                                                });
                                                                              },
                                                                              style: ButtonStyle(
                                                                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                                                                elevation: MaterialStateProperty.all(1),
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.delete,
                                                                                color: Colors.black,
                                                                              ),
                                                                            )
                                                                          ]),
                                                                SizedBox(
                                                                  height: 72,
                                                                ),
                                                                _uploadImage3 ==
                                                                        null
                                                                    ? ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          _uploadProfile(
                                                                              context,
                                                                              VerificationDocument.bda);
                                                                        },
                                                                        style:
                                                                            ButtonStyle(
                                                                          elevation:
                                                                              MaterialStateProperty.all(0),
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(
                                                                            Color(0xffF6F6F6),
                                                                          ),
                                                                          fixedSize:
                                                                              MaterialStateProperty.all(
                                                                            Size(150,
                                                                                40),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "Upload",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontFamily: AppConstant.fontRegular),
                                                                        ),
                                                                      )
                                                                    : Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                _uploadProfile(context, VerificationDocument.bda);
                                                                              },
                                                                              style: ButtonStyle(
                                                                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                                                                elevation: MaterialStateProperty.all(1),
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.edit,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  _uploadImage3 = null;
                                                                                });
                                                                              },
                                                                              style: ButtonStyle(
                                                                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                                                                elevation: MaterialStateProperty.all(1),
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.delete,
                                                                                color: Colors.black,
                                                                              ),
                                                                            )
                                                                          ]),
                                                                SizedBox(
                                                                  height: 24,
                                                                ),
                                                                _uploadImage4 ==
                                                                        null
                                                                    ? ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          _uploadProfile(
                                                                              context,
                                                                              VerificationDocument.menu);
                                                                        },
                                                                        style:
                                                                            ButtonStyle(
                                                                          elevation:
                                                                              MaterialStateProperty.all(0),
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(
                                                                            Color(0xffF6F6F6),
                                                                          ),
                                                                          fixedSize:
                                                                              MaterialStateProperty.all(
                                                                            Size(150,
                                                                                40),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          "Upload",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontFamily: AppConstant.fontRegular),
                                                                        ),
                                                                      )
                                                                    : Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                _uploadProfile(context, VerificationDocument.menu);
                                                                              },
                                                                              style: ButtonStyle(
                                                                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                                                                elevation: MaterialStateProperty.all(1),
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.edit,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  _uploadImage4 = null;
                                                                                });
                                                                              },
                                                                              style: ButtonStyle(
                                                                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                                                                elevation: MaterialStateProperty.all(1),
                                                                              ),
                                                                              child: Icon(
                                                                                Icons.delete,
                                                                                color: Colors.black,
                                                                              ),
                                                                            )
                                                                          ])
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              width: 48,
                                                            ),
                                                            Column(
                                                              children: [
                                                                Container(
                                                                  width: 50,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets.only(
                                                                        top: 10,
                                                                        right:
                                                                            16),
                                                                    height: 50,
                                                                    width: double
                                                                        .infinity,
                                                                    child: _uploadImage ==
                                                                            null
                                                                        ? SizedBox()
                                                                        : Container(
                                                                            color:
                                                                                Color(0xffF9F9F9),
                                                                            child:
                                                                                Image.file(
                                                                              _uploadImage!,
                                                                              width: double.infinity,
                                                                              height: 150,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 48,
                                                                ),
                                                                Container(
                                                                  width: 50,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets.only(
                                                                        top: 10,
                                                                        right:
                                                                            16),
                                                                    height: 50,
                                                                    width: double
                                                                        .infinity,
                                                                    child: _uploadImage1 ==
                                                                            null
                                                                        ? SizedBox()
                                                                        : Container(
                                                                            color:
                                                                                Color(0xffF9F9F9),
                                                                            child:
                                                                                Image.file(
                                                                              _uploadImage1!,
                                                                              width: double.infinity,
                                                                              height: 150,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 48,
                                                                ),
                                                                Container(
                                                                  width: 50,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets.only(
                                                                        top: 10,
                                                                        right:
                                                                            16),
                                                                    height: 50,
                                                                    width: double
                                                                        .infinity,
                                                                    child: _uploadImage2 ==
                                                                            null
                                                                        ? SizedBox()
                                                                        : Container(
                                                                            color:
                                                                                Color(0xffF9F9F9),
                                                                            child:
                                                                                Image.file(
                                                                              _uploadImage2!,
                                                                              width: double.infinity,
                                                                              height: 150,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 48,
                                                                ),
                                                                Container(
                                                                  width: 50,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets.only(
                                                                        top: 10,
                                                                        right:
                                                                            16),
                                                                    height: 50,
                                                                    width: double
                                                                        .infinity,
                                                                    child: _uploadImage3 ==
                                                                            null
                                                                        ? SizedBox()
                                                                        : Container(
                                                                            color:
                                                                                Color(0xffF9F9F9),
                                                                            child:
                                                                                Image.file(
                                                                              _uploadImage3!,
                                                                              width: double.infinity,
                                                                              height: 150,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: 50,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets.only(
                                                                        top: 10,
                                                                        right:
                                                                            16),
                                                                    height: 50,
                                                                    width: double
                                                                        .infinity,
                                                                    child: _uploadImage4 ==
                                                                            null
                                                                        ? SizedBox()
                                                                        : Container(
                                                                            color:
                                                                                Color(0xffF9F9F9),
                                                                            child:
                                                                                Image.file(
                                                                              _uploadImage4!,
                                                                              width: double.infinity,
                                                                              height: 150,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        commonSizedBoc(),
                                                        Text(
                                                          "(you can upload  your menu in PNG,JPEG or PDF Format)",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontFamily:
                                                                  AppConstant
                                                                      .fontRegular,
                                                              fontSize: 12),
                                                        ),
                                                        commonSizedBoc(),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  isNext =
                                                                      false;
                                                                });
                                                              },
                                                              child: Text(
                                                                "Previous",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        AppConstant
                                                                            .fontRegular),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomRight,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  validation();
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 55,
                                                                  width: 90,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0xffFFA451),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            13),
                                                                  ),
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              16,
                                                                          right:
                                                                              8),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomRight,
                                                                    child:
                                                                        Center(
                                                                      child: Image.asset(
                                                                          Res
                                                                              .ic_back,
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              20),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox()
                                            ])
                                      : SizedBox(),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDetailsVerifyDialog(
      String kitchenName,
      String kitchenAddress,
      String pincode,
      String contactpersonname,
      String contactPersonRole,
      String mobileNo,
      String kitchenContactNo,
      String licence,
      String expDate,
      String panCard,
      String gst,
      String email) {
    showDialog(
      context: context,
      builder: (_) => Center(
        // Aligns the container to center
        child: GestureDetector(
          onTap: () {},
          child: Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ), // A simplified version of dialog.
                width: 270.0,
                height: 280.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        Res.ic_verify,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16, top: 20, right: 16),
                        child: Text(
                          "User Under Verification",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontFamily: AppConstant.fontBold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16, top: 20, right: 16),
                        child: Text(
                          "Now You can add your kitchen and start",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.grey,
                              fontFamily: AppConstant.fontRegular,
                              fontSize: 12),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16, top: 5, right: 16),
                        child: Text(
                          "your business!",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.grey,
                              fontFamily: AppConstant.fontRegular,
                              fontSize: 12),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          signUpUser(
                              kitchenName,
                              kitchenAddress,
                              pincode,
                              contactpersonname,
                              contactPersonRole,
                              mobileNo,
                              kitchenContactNo,
                              licence,
                              expDate,
                              panCard,
                              gst,
                              email);
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/userLogin", (route) => false);
                        },
                        child: Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Color(0xffFFA451),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          margin: EdgeInsets.only(top: 25),
                          child: Center(
                            child: Text(
                              "Ok",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: AppConstant.fontBold,
                                fontSize: 12,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validation1() {
    var kitchenName = kitchenNameController.text.toString();
    var kitchenAddress = kitchenAddressController.text.toString();
    var pincode = pincodeController.text.toString();
    var contactPersonName = contactPersonNameController.text.toString();
    var contactPersonRole = contactPersonRoleController.text.toString();
    var mobileNumber = mobileNumberController.text.toString();
    var kitchenContactNumber = kitchenContactNoController.text.toString();

    if (kitchenName.isEmpty) {
      Utils.showToast("Enter Kitchen Name", context);
    } else if (kitchenAddress.isEmpty) {
      Utils.showToast("Enter Kitchen Address", context);
    } else if (stateId == null) {
      Utils.showToast("Select state", context);
    } else if (cityId == null) {
      Utils.showToast("Select city", context);
    } else if (pincode.isEmpty) {
      Utils.showToast("Enter Pincode ", context);
    } else if (contactPersonName.isEmpty) {
      Utils.showToast("Enter Contact Person Name ", context);
    } else if (contactPersonRole.isEmpty) {
      Utils.showToast("Enter Contact Person Role ", context);
    } else if (mobileNumber.isEmpty) {
      Utils.showToast("Enter Mobile Number ", context);
    } else if (kitchenContactNumber.isEmpty) {
      Utils.showToast("Enter Kitchen Contact Number ", context);
    } else {
      isNext = true;
    }
  }

  void validation() {
    var kitchenName = kitchenNameController.text.toString();
    var kitchenAddress = kitchenAddressController.text.toString();
    var pincode = pincodeController.text.toString();
    var contactPersonName = contactPersonNameController.text.toString();
    var contactPersonRole = contactPersonRoleController.text.toString();
    var mobileNumber = mobileNumberController.text.toString();
    var kitchenContactNumber = kitchenContactNoController.text.toString();
    var licence = fSSAILicenseNoController.text.toString();
    var expDate = expiryDateController.text.toString();
    var panCard = panCardController.text.toString();
    var gst = gstRegisterController.text.toString();
    var email = emailController.text.toString();
    RegExp regexEmail = RegExp(r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@'
        r'"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (kitchenName.isEmpty) {
      Utils.showToast("Enter Kitchen Name", context);
    } else if (kitchenAddress.isEmpty) {
      Utils.showToast("Enter Kitchen Address", context);
    } else if (stateId == null) {
      Utils.showToast("Select state", context);
    } else if (cityId == null) {
      Utils.showToast("Select city", context);
    } else if (pincode.isEmpty) {
      Utils.showToast("Enter Pincode ", context);
    } else if (contactPersonName.isEmpty) {
      Utils.showToast("Enter Contact Person Name ", context);
    } else if (contactPersonRole.isEmpty) {
      Utils.showToast("Enter Contact Person Role ", context);
    } else if (mobileNumber.isEmpty) {
      Utils.showToast("Enter Mobile Number ", context);
    } else if (kitchenContactNumber.isEmpty) {
      Utils.showToast("Enter Kitchen Contact Number ", context);
    } else if (licence.isEmpty) {
      Utils.showToast("Enter Licence no ", context);
    } else if (dateCtlController.text.isEmpty) {
      Utils.showToast("Enter Exp Date ", context);
    } else if (email.isEmpty) {
      Utils.showToast("Enter Email ", context);
    } else if (!regexEmail.hasMatch(email)) {
      Utils.showToast("Please Enter Valid Email", context);
    } else if (_uploadImage == null) {
      Utils.showToast("Upload Pan Card ", context);
    } else if (_uploadImage1 == null) {
      Utils.showToast("Upload FSSAI Certificate", context);
    } else if (_uploadImage2 == null) {
      Utils.showToast("Upload Gst Certificate ", context);
    } else if (_uploadImage3 == null) {
      Utils.showToast("Upload Business Address Proof Certificate", context);
    } else if (_uploadImage4 == null) {
      Utils.showToast("Menu is empty", context);
    } else {
      showDetailsVerifyDialog(
          kitchenName,
          kitchenAddress,
          pincode,
          contactPersonName,
          contactPersonRole,
          mobileNumber,
          kitchenContactNumber,
          licence,
          expDate,
          panCard,
          gst,
          email);
    }
  }

  void saveUser() async {
    BeanLogin? userBean = await Utils.getUser();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool("isLoggedIn", true);
    await sharedPreferences.setString(
        "userid", userBean.data!.kitchenId.toString());
  }

  Future<BeanSignUp?> signUpUser(
      String kitchenName,
      String kitchenAddress,
      String pincode,
      String contactPersonName,
      String contactPersonRole,
      String mobileNumber,
      String kitchenContactNumber,
      String licence,
      String expDate,
      String panCard,
      String gst,
      String email) async {
    try {
      // FormData data = FormData.fromMap({
      //   "token": "123456789",
      //   "kitchenname": kitchenName,
      //   "address": kitchenAddress,
      //   "stateid": stateId.toString(),
      //   "cityid": cityId.toString(),
      //   "pincode": pincode,
      //   "contactpersonname": contactPersonName,
      //   "contactpersonrole": contactPersonRole,
      //   "mobilenumber": mobileNumber,
      //   "kitchenscontactnumber": kitchenContactNumber,
      //   "email": email,
      //   "FSSAILicenceNo": licence,
      //   "expirydate": dateCtlController.text.toString(),
      //   "pancard": panCard,
      //   "gstnumber": gst,
      //   "menufile": _uploadImage4,
      //   //await MultipartFile.fromFile(_image!.path, filename: _image!.path),
      //   "pan_card": _uploadImage,
      //   "fssai_certificate": _uploadImage2,
      //   "gst_certificate": _uploadImage1,
      //   "business_address_proof": _uploadImage3,
      //   //await MultipartFile.fromFile(_uploadImage!.path,
      //   //  filename: _uploadImage!.path),
      // });
      BeanSignUp bean = await ApiProvider().registerUser(
          kitchenName,
          kitchenAddress,
          pincode,
          contactPersonName,
          contactPersonRole,
          mobileNumber,
          kitchenContactNumber,
          licence,
          expDate,
          panCard,
          gst,
          email,
          stateId,
          cityId,
          dateCtlController.text,
          _uploadImage,
          _uploadImage1,
          _uploadImage2,
          _uploadImage3,
          _uploadImage4);

      if (bean.status == true) {
        saveUser();

        PrefManager.putBool(AppConstant.session, true);
        PrefManager.putString(AppConstant.user, jsonEncode(bean));
        Navigator.pushNamedAndRemoveUntil(
            context, "/userLogin", (route) => false);
        _controller!.animateTo(0);
      } else {}
    } on HttpException {
    } catch (exception) {}
    return null;
  }

  void _uploadProfile(context, VerificationDocument documentType) {
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
                      onTap: () async {
                        _uploadingFromGallery(documentType);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _uploadImgFromCamera(documentType);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

enum VerificationDocument { pan, fssai, gst, bda, menu }

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final kitchenIdController = TextEditingController();
  final passwordController = TextEditingController();
  bool? _passwordVisible;
  FormData from = FormData.fromMap({'token': '123456789'});

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(top: 72),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontFamily: AppConstant.fontRegular),
                      ),
                      Text(
                        "User",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontFamily: AppConstant.fontBold),
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      TextFormField(
                        controller: kitchenIdController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Enter Kitchen ID",
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          fillColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !_passwordVisible!,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible!;
                              });
                            },
                            // onLongPressUp: () {
                            //   setState(() {
                            //     _passwordVisible = false;
                            //   });
                            // },
                            child: Icon(
                              _passwordVisible!
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                          fillColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/forgot');
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 16, left: 8),
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: AppConstant.fontRegular),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      validationLogin();
                    },
                    child: Container(
                      height: 55,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Color(0xffFFA451),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      margin: EdgeInsets.only(bottom: 16, right: 8),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Center(
                          child:
                              Image.asset(Res.ic_back, width: 20, height: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validationLogin() {
    var id = kitchenIdController.text.toString();
    var pass = passwordController.text.toString();
    if (id.isEmpty) {
      Utils.showToast("Please Enter  your  Kitchen Id", context);
    } else if (pass.isEmpty) {
      Utils.showToast("Please Enter  Password", context);
    } else {
      loginUser(id, pass);
    }
  }

  Future<BeanLogin?> loginUser(String kitchenId, String password) async {
    try {
      FormData data = FormData.fromMap({
        "kitchen_id": kitchenId,
        "token": "123456789",
        "password": password,
      });
      BeanLogin bean = await ApiProvider().loginUser(kitchenId, password);

      if (bean.status == true) {
        saveUser();
        print(bean.data);
        PrefManager.putBool(AppConstant.session, true);
        PrefManager.putString(AppConstant.user, jsonEncode(bean));
        Utils.showToast(bean.message ?? "", context);
        saveKitchenStatus(bean.data!.availableStatus == "1" ? true : false);
        //  isKitchenActive
        Navigator.pushReplacementNamed(context, '/homebase');
      } else {
        Utils.showToast(bean.message ?? "", context);
      }
    } on HttpException {
    } catch (exception) {}
    return null;
  }

  void saveToken(String firebaseToken) async {
    await Firebase.initializeApp();

    ApiProvider().addFirebaseToken(firebaseToken);
  }

  void saveUser() async {
    await Firebase.initializeApp();
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? token = await _firebaseMessaging.getToken();

    //String? id =FirebaseAuth.instance.currentUser!.uid;
    await ApiProvider().addFirebaseToken(token!);

    print("Firebase token login Screen $token");
    final CollectionReference _tokenRef =
        FirebaseFirestore.instance.collection('fcmTokens');

    try {
      await _tokenRef
          .add({"token": token})
          .then((value) async {})
          .catchError((error) {
            debugPrint('kError 84 $error');
          });
    } catch (e) {
      debugPrint('kError 88 $e');
    }
    BeanLogin? userBean = await Utils.getUser();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool("isLoggedIn", true);
    await sharedPreferences.setString(
        "userid", userBean.data!.kitchenId.toString());
  }
}
