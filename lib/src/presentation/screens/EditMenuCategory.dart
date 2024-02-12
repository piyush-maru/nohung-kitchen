import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/model/EditCategory.dart';
import 'package:kitchen/model/GetCategoryDetails.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';

import '../../../model/KitchenData/BeanLogin.dart';

class EditMenuCategoryScreen extends StatefulWidget {
  final String categoryId;

  EditMenuCategoryScreen({required this.categoryId});
  @override
  _EditMenuCategoryScreenState createState() => _EditMenuCategoryScreenState();
}

class _EditMenuCategoryScreenState extends State<EditMenuCategoryScreen> {
  bool isPageLoading = true;
  var categoryTitle = TextEditingController();
  var description = TextEditingController();

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

    getCategoryDetail(context, widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16,
                          ),
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
                              "Edit Category",
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
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Text(
                        "Category *",
                        style: TextStyle(
                            color: AppConstant.appColor,
                            fontSize: 16,
                            fontFamily: AppConstant.fontRegular),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 6),
                        child: TextField(
                          controller: categoryTitle,
                          decoration:
                              InputDecoration(hintText: 'Enter Category Name'),
                        )),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Text(
                        "Description",
                        style: TextStyle(
                            color: AppConstant.appColor,
                            fontSize: 16,
                            fontFamily: AppConstant.fontRegular),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 6),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 8,
                        controller: description,
                        decoration: InputDecoration(
                            hintText: 'Enter Category Description'),
                      ),
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
                            "UPDATE",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppConstant.fontBold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
          physics: BouncingScrollPhysics(),
        ));
  }

  void validaton() {
    var title = categoryTitle.text.toString();
    var descriptionText = description.text.toString();
    if (title.isEmpty) {
      Utils.showToast("Enter Category Title", context);
    } else {
      editCategory(title, descriptionText);
    }
  }

  Future<EditCategory> editCategory(String title, String desciption) async {
    var userBean = await Utils.getUser();

    var id = userBean.data!.id;

    FormData data;
    data = FormData.fromMap({
      "kitchen_id": id,
      "category_id": widget.categoryId,
      "category_name": title,
      "description": desciption,
      "token": "123456789",
    });

    EditCategory bean =
        await ApiProvider().editCategory(widget.categoryId, title, desciption);

    if (bean.status == true) {
      Navigator.pop(context, true);
      return Utils.showToast("Category Updated Successfully", context);
    } else {
      return Utils.showToast(bean.message ?? "", context);
    }
  }

  Future<GetCategoryDetails?> getCategoryDetail(
      BuildContext context, String categoryId) async {
    // progressDialog.show();
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        'category_id': categoryId,
        "token": "123456789"
      });
      GetCategoryDetails? bean =
          await ApiProvider().getCategoryDetail(categoryId);

      if (bean.status == true) {
        setState(() {
          isPageLoading = false;
          categoryTitle.text = bean.data!.categoryName!;
          description.text = bean.data!.description!;
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
