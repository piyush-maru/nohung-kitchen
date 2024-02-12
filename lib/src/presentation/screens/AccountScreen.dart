import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitchen/model/BeanUpdateSetting.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/src/presentation/screens/HomeBaseScreen.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';

import '../../../model/KitchenData/BeanLogin.dart';
import '../../../model/KitchenData/GetAccountDetail.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  BeanLogin? userBean;

  bool _passwordVisible = false;
  File? mediaFile;
  var name = "";
  var email = "";
  var address = "";
  var number = "";
  var password = "";
  var id;
  var imageURL;
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();

  Future getUser() async {
    userBean = await Utils.getUser();
    name = userBean!.data!.kitchenName!;
    email = userBean!.data!.email!;
    address = userBean!.data!.address!;
    password = userBean!.data!.password!;
    id = userBean!.data!.id!;
  }

  Future? future;

  @override
  void initState() {
    getUser().then((value) {
      setState(() {
        future = getAccountDetails();
      });
    });

    super.initState();
  }

  Future<void> _showPicker(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              height: 250,
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        setState(() {
                          _imgFromGallery();
                        });

                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      setState(() {
                        _imgFromCamera();
                      });

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future _imgFromCamera() async {
    // var image = DecorationImage(image: ImageSource.gallery as ImageProvider,filterQuality:FilterQuality.medium);
    var image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      mediaFile = File(image!.path);
    });
  }

  Future _imgFromGallery() async {
    // var image = DecorationImage(image: ImageSource.gallery as ImageProvider,filterQuality:FilterQuality.medium);
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      mediaFile = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawers(),
      appBar: AppBar(
        title: Text(
          "SETTINGS",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: AppConstant.fontBold),
        ),
        elevation: 0,
        backgroundColor: AppConstant.appColor,
        leading: InkWell(
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
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            (imageURL == null)
                ? Container(
                    height: 150,
                    width: double.infinity,
                    child: Image.asset(
                      Res.ic_gallery,
                      fit: BoxFit.cover,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, top: 16),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: (mediaFile == null)
                                    ? NetworkImage(imageURL)
                                    : FileImage(File(mediaFile!.path))
                                        as ImageProvider)),
                      ),
                    ),
                  ),
            Container(
              decoration: BoxDecoration(
                //  color: Colors.yellow,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Image.asset(
                          Res.ic_contact,
                          width: 18,
                          height: 18,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: TextField(
                            autofocus: false,
                            controller: nameController,
                            style: TextStyle(
                                fontFamily: AppConstant.fontRegular,
                                fontSize: 14,
                                color: Colors.black),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xffd3dde4), width: 3),
                              ),
                              labelText: "Kitchen Name",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontFamily: "CentraleSansRegular"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Image.asset(
                          Res.ic_loc,
                          width: 18,
                          height: 18,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: TextField(
                            autofocus: false,
                            controller: addressController,
                            style: TextStyle(
                                fontFamily: AppConstant.fontRegular,
                                fontSize: 14,
                                color: Colors.black),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xffd3dde4), width: 3),
                              ),
                              labelText: "Location",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontFamily: "CentraleSansRegular"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Image.asset(
                          Res.ic_messag,
                          width: 18,
                          height: 18,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: TextField(
                            autofocus: false,
                            controller: emailController,
                            style: TextStyle(
                                fontFamily: AppConstant.fontRegular,
                                fontSize: 14,
                                color: Colors.black),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xffd3dde4), width: 3),
                              ),
                              labelText: "Email",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontFamily: "CentraleSansRegular"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Image.asset(
                          Res.ic_phn,
                          width: 18,
                          height: 18,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: TextField(
                            autofocus: false,
                            maxLength: 10,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xffd3dde4), width: 3),
                              ),
                              labelText: "Mobile Number",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontFamily: "CentraleSansRegular"),
                            ),
                            controller: numberController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontFamily: AppConstant.fontRegular,
                                fontSize: 14,
                                color: Colors.black),
                            //decoration: InputDecoration.collapsed(
                            //hintText: number == "" ? "Number" : number,
                            //),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Image.asset(
                          Res.ic_pass,
                          width: 18,
                          height: 18,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: TextField(
                            autofocus: false,
                            decoration: InputDecoration(
                              filled: true,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                                child: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xffd3dde4), width: 3),
                              ),
                              labelText: "Password",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontFamily: AppConstant.fontRegular),
                            ),
                            controller: passwordController,
                            obscureText: _passwordVisible,
                            style: TextStyle(
                                fontFamily: AppConstant.fontRegular,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Image.asset(
                          Res.ic_messag,
                          width: 18,
                          height: 18,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: TextField(
                            autofocus: false,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color(0xffd3dde4), width: 3),
                              ),
                              labelText: "Description",
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontFamily: "CentraleSansRegular"),
                            ),
                            controller: descriptionController,
                            keyboardType: TextInputType.text,
                            maxLines: 5,
                            style: TextStyle(
                                fontFamily: AppConstant.fontRegular,
                                fontSize: 14,
                                color: Colors.black),
                            //decoration: InputDecoration.collapsed(
                            //hintText: number == "" ? "Number" : number,
                            //),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    onTap: () {
                      uploadProfileImage();
                      nameController.text.isEmpty
                          ? ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Please enter Kitchen Name",
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontRegular),
                                ),
                              ),
                            )
                          : addressController.text.isEmpty
                              ? ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Please enter Kitchen Location",
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontRegular),
                                    ),
                                  ),
                                )
                              : emailController.text.isEmpty
                                  ? ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Please enter Kitchen Email",
                                          style: TextStyle(
                                              fontFamily:
                                                  AppConstant.fontRegular),
                                        ),
                                      ),
                                    )
                                  : numberController.text.isEmpty
                                      ? ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Please enter Kitchen Number",
                                              style: TextStyle(
                                                  fontFamily:
                                                      AppConstant.fontRegular),
                                            ),
                                          ),
                                        )
                                      : passwordController.text.isEmpty
                                          ? ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Please Enter Password",
                                                  style: TextStyle(
                                                      fontFamily: AppConstant
                                                          .fontRegular),
                                                ),
                                              ),
                                            )
                                          : descriptionController.text.isEmpty
                                              ? ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Please enter Kitchen Name",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              AppConstant
                                                                  .fontRegular),
                                                    ),
                                                  ),
                                                )
                                              : updateAccount();
                      getAccountDetails();
                    },
                    child: Container(
                      height: 55,
                      margin: EdgeInsets.only(
                          left: 16, right: 16, bottom: 16, top: 16),
                      decoration: BoxDecoration(
                        color: AppConstant.appColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: AppConstant.fontBold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  AppConstant().navBarHt()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future uploadProfileImage() async {
    var userBean = await Utils.getUser();
    try {
      FormData from = FormData.fromMap({
        "user_id": userBean.data!.id,
        "token": "123456789",
        "profile_image": await MultipartFile.fromFile(mediaFile!.path,
            filename: mediaFile!.path),
      });
      var bean = await ApiProvider().uploadProfileImage(
          await MultipartFile.fromFile(mediaFile!.path,
              filename: mediaFile!.path));

      if (bean.status == true) {
        setState(() {
          getAccountDetails();
        });

        Utils.showToast(bean.message!, context);
        return bean;
      } else {
        setState(() {});
        Utils.showToast(bean.message!, context);
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {
      print(exception);
    }
  }

  Future<BeanUpdateSetting?> updateAccount() async {
    try {
      FormData data = FormData.fromMap({
        "token": "123456789",
        "user_id": id,
        "kitchen_name": nameController.text,
        "address": addressController.text,
        "email": emailController.text,
        "mobile_number": numberController.text,
        "password": passwordController.text,
        "description": descriptionController.text,
      });
      BeanUpdateSetting bean = await ApiProvider().updateSetting(
          nameController.text,
          addressController.text,
          emailController.text,
          passwordController.text,
          numberController.text,
          descriptionController.text);

      if (bean.status == true) {
        //Utils.showToast(bean.message ?? "");
        Navigator.pop(context);
      } else {
        Utils.showToast(bean.message ?? "", context);
      }
    } on HttpException {
    } catch (exception) {}
    return null;
  }

  Future<GetAccountDetails?> getAccountDetails() async {
    try {
      FormData from = FormData.fromMap({"user_id": id, "token": "123456789"});
      GetAccountDetails bean = await ApiProvider().getAccountDetails();

      if (bean.status!) {
        setState(() {
          nameController.text = bean.data!.kitchenName!;
          addressController.text = bean.data!.address!;
          emailController.text = bean.data!.email!;
          numberController.text = bean.data!.mobileNumber!;
          passwordController.text = bean.data!.password!;
          descriptionController.text = bean.data!.description!;
          imageURL = bean.data!.profileImage!;
        });

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
}
