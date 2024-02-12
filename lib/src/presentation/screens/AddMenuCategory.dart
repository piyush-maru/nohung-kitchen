import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:kitchen/model/Category/AddCategory.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/Utils.dart';

class AddMenuCategoryScreen extends StatefulWidget {

  AddMenuCategoryScreen();
  @override
  _AddMenuCategoryScreenState createState() => _AddMenuCategoryScreenState();
}

class _AddMenuCategoryScreenState extends State<AddMenuCategoryScreen> {


  var categoryTitle = TextEditingController();
  var description = TextEditingController();


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
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
                      padding: EdgeInsets.only(left: 10, right: 16, top: 16),
                      child: Text(
                        "Add Category",
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
                    decoration: InputDecoration(hintText: 'Enter Category Name'),
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
                    decoration: InputDecoration(hintText: 'Enter Category Description'),
                  ),
              ),
              InkWell(
                onTap: () {
                  validaton();
                },
                child: Container(
                  height: 55,
                  margin:
                      EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 36),
                  decoration: BoxDecoration(
                      color: AppConstant.appColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "SAVE",
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
      Utils.showToast("Enter Category Title",context);
    }  else {
      if(descriptionText.isEmpty)
      {
        descriptionText = " ";
      }
      addCategory(title, descriptionText);
    }
  }

  Future<AddCategory> addCategory(String title,  String desciption) async {


    var userBean = await Utils.getUser();

    var id = userBean.data!.id;


      FormData data;
      data = FormData.fromMap({
        "kitchen_id": id,
        "category_name": title,
        "description":desciption,
        "token": "123456789",
      });
      AddCategory bean = await ApiProvider().addCategory(title,desciption);
      if (bean.status == true) {
        Navigator.pop(context, true);
        return Utils.showToast("Category Added Successfully",context);
      } else {
        return Utils.showToast(bean.message??"",context);
      }

  }
}
