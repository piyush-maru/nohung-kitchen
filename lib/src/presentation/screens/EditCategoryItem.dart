import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitchen/model/EditCategoryItem.dart';
import 'package:kitchen/model/GetCategoryItemDetails.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../model/KitchenData/BeanLogin.dart';
import '../../../utils/Utils.dart';

class EditCategoryItemScreen extends StatefulWidget {
  var categoryId;
  var categoryItemId;
  EditCategoryItemScreen({this.categoryId, this.categoryItemId});
  @override
  _EditCategoryItemScreenState createState() => _EditCategoryItemScreenState();
}

class _EditCategoryItemScreenState extends State<EditCategoryItemScreen> {
  bool isChecked = false;
  var isSelectB = -1;
  var isSelectL = -1;
  var isSelectD = -1;
  var isSelectON = -1;
  var cuisineSI = -1;
  var cuisineNI = -1;
  var cuisineDM = -1;
  var cuisineOC = -1;
  var cuisineType = 1;
  var mealType = 1;
  var imageURL = '';
  var itemTitle = TextEditingController();
  var itemPrice = TextEditingController();
  var description = TextEditingController();
  File? _image;
  String isRemoved = '0';
  bool isPageLoading = true;

  BeanLogin? userBean;
  var name = "";
  var menu = "";
  var userId = "";
  @override
  void initState() {
    getCategoryItemDetail(context, widget.categoryId);
    getUser();
    super.initState();
  }

  void getUser() async {
    userBean = await Utils.getUser();
    name = userBean!.data!.kitchenName!;
    menu = userBean!.data!.menuFile!;
    userId = userBean!.data!.id.toString();
  }

  Future<void> _showPicker(context) async {
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
      isRemoved = '1';
      _image = File(image!.path);
    });
  }

  _imgFromGallery() async {
    var permission = await Permission.storage.request();
    if (permission.isGranted) {
      // DecorationImage image = DecorationImage(image: '',filterQuality:FilterQuality.medium);
      XFile? image = (await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 50));
      setState(() {
        isRemoved = '1';
        _image = File(image!.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: isPageLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Image.asset(
                                  Res.ic_right_arrow,
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 10, right: 16, top: 16),
                              child: Text(
                                "Edit Item",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: AppConstant.fontBold),
                              ),
                            ),
                          ],
                        ),
                        height: 70,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Item Name *",
                        style: TextStyle(
                            color: AppConstant.appColor,
                            fontSize: 16,
                            fontFamily: AppConstant.fontRegular),
                      ),
                      TextField(
                        controller: itemTitle,
                        decoration:
                            InputDecoration(hintText: 'Enter Item Name'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Price *",
                        style: TextStyle(
                            color: AppConstant.appColor,
                            fontSize: 16,
                            fontFamily: AppConstant.fontRegular),
                      ),
                      TextField(
                        controller: itemPrice,
                        decoration: InputDecoration(hintText: "Enter Price"),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 16,
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
                        "Meal For *",
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
                                    "Snack",
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
                        height: 10,
                      ),
                      Text(
                        "Meal Type *",
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
                                  mealType = 1;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 110,
                                margin: EdgeInsets.only(left: 16),
                                decoration: BoxDecoration(
                                    color: mealType == 1
                                        ? Color(0xffFFA451)
                                        : Color(0xffF3F6FA),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
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
                                            color: mealType == 1
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14,
                                            fontFamily:
                                                AppConstant.fontRegular),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  mealType = 2;
                                });
                              },
                              child: Container(
                                height: 40,
                                margin: EdgeInsets.only(left: 16),
                                decoration: BoxDecoration(
                                    color: mealType == 2
                                        ? Color(0xffFFA451)
                                        : Color(0xffF3F6FA),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        Res.ic_chiken,
                                        width: 20,
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Non-Veg",
                                        style: TextStyle(
                                            color: mealType == 2
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14,
                                            fontFamily:
                                                AppConstant.fontRegular),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Cuisine *",
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
                                  cuisineSI = cuisineSI == 1 ? -1 : 1;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 110,
                                margin: EdgeInsets.only(left: 16),
                                decoration: BoxDecoration(
                                    color: cuisineSI == 1
                                        ? Color(0xffFFA451)
                                        : Color(0xffF3F6FA),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "South Indian",
                                    style: TextStyle(
                                        color: cuisineSI == 1
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
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "North Indian",
                                    style: TextStyle(
                                        color: cuisineNI == 1
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
                                  cuisineDM = cuisineDM == 1 ? -1 : 1;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 110,
                                margin: EdgeInsets.only(left: 16),
                                decoration: BoxDecoration(
                                    color: cuisineDM == 1
                                        ? Color(0xffFFA451)
                                        : Color(0xffF3F6FA),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "Diet Meals",
                                    style: TextStyle(
                                        color: cuisineDM == 1
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
                                  cuisineOC = cuisineOC == 1 ? -1 : 1;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 110,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                    color: cuisineOC == 1
                                        ? Color(0xffFFA451)
                                        : Color(0xffF3F6FA),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "Other Cuisine",
                                    style: TextStyle(
                                        color: cuisineOC == 1
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
                        height: 10,
                      ),
                      Text(
                        "Cuisine Type *",
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
                                  cuisineType = 1;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 110,
                                margin: EdgeInsets.only(left: 16),
                                decoration: BoxDecoration(
                                    color: cuisineType == 1
                                        ? Color(0xffFFA451)
                                        : Color(0xffF3F6FA),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "None",
                                    style: TextStyle(
                                        color: cuisineType == 1
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
                                  cuisineType = 2;
                                });
                              },
                              child: Container(
                                height: 40,
                                margin: EdgeInsets.only(left: 16),
                                decoration: BoxDecoration(
                                    color: cuisineType == 2
                                        ? Color(0xffFFA451)
                                        : Color(0xffF3F6FA),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "Mild",
                                    style: TextStyle(
                                        color: cuisineType == 2
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
                                  cuisineType = 3;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 110,
                                margin: EdgeInsets.only(left: 16),
                                decoration: BoxDecoration(
                                    color: cuisineType == 3
                                        ? Color(0xffFFA451)
                                        : Color(0xffF3F6FA),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "Hot Dish",
                                    style: TextStyle(
                                        color: cuisineType == 3
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
                                  cuisineType = 4;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 110,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                    color: cuisineType == 4
                                        ? Color(0xffFFA451)
                                        : Color(0xffF3F6FA),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "Very Hot Dish",
                                    style: TextStyle(
                                        color: cuisineType == 4
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Image",
                              style: TextStyle(
                                  color: AppConstant.appColor,
                                  fontFamily: AppConstant.fontRegular),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 16, right: 16),
                              child: new ListTile(
                                  leading: new Icon(Icons.photo_library),
                                  title: new Text('Photo Library'),
                                  onTap: () {
                                    _showPicker(context);
                                  }),
                            ),
                          ),
                          imageURL != AppConstant.noImageUrl
                              ? InkWell(
                                  onTap: (() => {emptyImage()}),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.red),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.red,
                                      size: 26.0,
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(height: 10, width: 20)
                        ],
                      ),
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: (_image == null)
                                    ? NetworkImage(imageURL)
                                    : FileImage(File(_image!.path))
                                        as ImageProvider)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          validaton();
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(AppConstant.appColor),
                            fixedSize:
                                MaterialStateProperty.all(Size(450, 50))),
                        child: Text(
                          "UPDATE ITEM",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: AppConstant.fontBold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  )),
          physics: BouncingScrollPhysics(),
        ));
  }

  void emptyImage() {
    setState(() {
      isRemoved = '1';
      imageURL = AppConstant.noImageUrl;
    });
  }

  void validaton() {
    var title = itemTitle.text.toString();
    var price = itemPrice.text.toString();
    var descriptionText = description.text.toString();
    if (title.isEmpty) {
      Utils.showToast("Enter Item Title", context);
    } else if (price.isEmpty) {
      Utils.showToast("Enter Item Price", context);
    } else if (isSelectB == -1 &&
        isSelectL == -1 &&
        isSelectD == -1 &&
        isSelectON == -1) {
      Utils.showToast("Please select Meal For", context);
    } else if (cuisineSI == -1 &&
        cuisineNI == -1 &&
        cuisineDM == -1 &&
        cuisineOC == -1) {
      Utils.showToast("Please select Cuisine For", context);
    } else {
      ediCategoryItem(title, price, descriptionText);
    }
  }

  Future<EditCategoryItem> ediCategoryItem(
      String title, String itemPrice, String desciption) async {
    FormData data;
    data = FormData.fromMap({
      "kitchen_id": userId,
      "token": "123456789",
      "category_id": widget.categoryId,
      "menu_id": widget.categoryItemId,
      "item_name": title,
      "item_price": itemPrice,
      "meal_for": ((isSelectB == 1 ? "Breakfast," : "") +
          (isSelectL == 1 ? "Lunch," : '') +
          (isSelectD == 1 ? "Dinner," : "") +
          (isSelectON == 1 ? "Snack," : "")),
      "item_type":
          (mealType == 1 ? "veg" : (mealType == 2 ? "nonveg" : "veg/nonveg")),
      "cuisine_type": ((cuisineSI == 1 ? "South Indian," : "") +
          (cuisineNI == 1 ? "North Indian," : '') +
          (cuisineDM == 1 ? "Diet Meals," : "") +
          (cuisineOC == 1 ? "Other Cuisine," : "")),
      "dish_type": (cuisineType == 1
          ? "none"
          : (cuisineType == 2
              ? "mild"
              : (cuisineType == 3 ? "hot" : "veryhot"))),
      "description": desciption,
      "image": _image != null
          ? await MultipartFile.fromFile(_image!.path, filename: _image!.path)
          : AppConstant.noImageUrl,
      "update_image": isRemoved,
    });
    EditCategoryItem bean = await ApiProvider().editCategoryItem(
      widget.categoryId,
      widget.categoryItemId,
      title,
      itemPrice,
      ((isSelectB == 1 ? "Breakfast," : "") +
          (isSelectL == 1 ? "Lunch," : '') +
          (isSelectD == 1 ? "Dinner," : "") +
          (isSelectON == 1 ? "Snack," : "")),
      (mealType == 1 ? "veg" : (mealType == 2 ? "nonveg" : "veg/nonveg")),
      ((cuisineSI == 1 ? "South Indian," : "") +
          (cuisineNI == 1 ? "North Indian," : '') +
          (cuisineDM == 1 ? "Diet Meals," : "") +
          (cuisineOC == 1 ? "Other Cuisine," : "")),
      (cuisineType == 1
          ? "none"
          : (cuisineType == 2
              ? "mild"
              : (cuisineType == 3 ? "hot" : "veryhot"))),
      desciption,
      await MultipartFile.fromFile(_image!.path, filename: _image!.path),
      isRemoved,
    );

    if (bean.status == true) {
      Navigator.pop(context, true);
      return Utils.showToast("Item Updated Successfully", context);
    } else {
      return Utils.showToast(bean.message ?? "", context);
    }
  }

  Future<GetCategoryItemDetails?> getCategoryItemDetail(
      BuildContext context, String categoryId) async {
    var userBean = await Utils.getUser();

    var userId = userBean.data!.id;
    // progressDialog.show();
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        'category_id': categoryId,
        "menu_id": widget.categoryItemId,
        "token": "123456789"
      });
      GetCategoryItemDetails? bean = await ApiProvider()
          .getCategoryItemDetail(categoryId, widget.categoryItemId);

      if (bean.status == true) {
        setState(() {
          itemTitle.text = bean.data!.itemName!;
          itemPrice.text = bean.data!.itemPrice!;
          description.text = bean.data!.description!;
          mealType = bean.data!.itemType == "veg"
              ? 1
              : (bean.data!.itemType == "nonveg" ? 2 : 3);
          final appliestoSplit = bean.data!.mealFor;
          for (int i = 0; i < appliestoSplit!.length; i++) {
            if (appliestoSplit[i] == 'Breakfast') {
              isSelectB = 1;
            } else if (appliestoSplit[i] == 'Lunch') {
              isSelectL = 1;
            } else if (appliestoSplit[i] == 'Dinner') {
              isSelectD = 1;
            } else if (appliestoSplit[i] == 'Snack') {
              isSelectON = 1;
            }
          }
          // _image = File(bean.data.image);

          imageURL = bean.data!.image == ''
              ? AppConstant.noImageUrl
              : bean.data!.image!;
          // _image = File(bean.data.image);
          cuisineType = bean.data!.dishType == "none"
              ? 1
              : (bean.data!.dishType == "mild"
                  ? 2
                  : (bean.data!.dishType == "hot" ? 3 : 4));
          final cuisineSplit = bean.data!.cuisineType;
          for (int i = 0; i < cuisineSplit!.length; i++) {
            if (cuisineSplit[i] == 'South Indian') {
              cuisineSI = 1;
            } else if (cuisineSplit[i] == 'North Indian') {
              cuisineNI = 1;
            } else if (cuisineSplit[i] == 'Diet Meals') {
              cuisineDM = 1;
            } else if (cuisineSplit[i] == 'Other Cuisine') {
              cuisineOC = 1;
            }
          }
          isPageLoading = false;
        });

        return bean;
      } else {
        Utils.showToast(bean.message ?? "", context);
      }
    } on HttpException catch (exception) {
      // progressDialog.dismiss();
      print(exception);
    } catch (exception) {
      // progressDialog.dismiss();
      print(exception);
    }
    return null;
  }
}
