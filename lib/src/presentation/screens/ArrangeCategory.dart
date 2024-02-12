import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';

import '../../../model/GetCategories.dart';
import '../../../model/Rearrange Category/rearrangeCategory.dart';

class ArrangeCategoryScreen extends StatefulWidget {
  ArrangeCategoryScreen();

  @override
  _ArrangeCategoryScreenState createState() => _ArrangeCategoryScreenState();
}

class _ArrangeCategoryScreenState extends State<ArrangeCategoryScreen> {
  List<Data>? categoryItems;
  List<int>? _items;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getCategories(context);
      //rearrangeCategory();
    });
    super.initState();
  }

  Future<void> _pullRefresh() async {
    setState(() async {
      await Future.delayed(Duration.zero, () {
        getCategories(context);
        rearrangeCategory();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Re-Arrange Category",
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: AppConstant.fontBold),
          ),
          backgroundColor: AppConstant.appColor,
          elevation: 0,
        ),
        body: new RefreshIndicator(
          onRefresh: _pullRefresh,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Note : Please Scroll From Top to Bottom to Re-Arrange Category",
                  style: TextStyle(fontFamily: AppConstant.fontBold),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  margin: EdgeInsets.only(top: 24),
                  padding: EdgeInsets.only(bottom: 72),
                  height: 700, // Change as per your requirement
                  // width: 350.0,
                  child: _items != null
                      ? ReorderableListView(
                          anchor: 0.5,
                          buildDefaultDragHandles: true,

                          physics: BouncingScrollPhysics(),

                          primary: true,
                          // header: InkWell(
                          //   onTap: () {
                          //     rearrageCategory();
                          //   },
                          //   child: Container(
                          //     height: 55,
                          //     margin: EdgeInsets.only(
                          //         left: 16, right: 16, bottom: 16, top: 36),
                          //     decoration: BoxDecoration(
                          //         color: AppConstant.appColor,
                          //         borderRadius: BorderRadius.circular(10)),
                          //     child: Center(
                          //       child: Text(
                          //         "SAVE",
                          //         style: TextStyle(
                          //             fontSize: 14,
                          //             fontFamily: AppConstant.fontBold,
                          //             color: Colors.white),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          clipBehavior: Clip.none,
                          reverse: false,
                          scrollDirection: Axis.vertical,

                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          children: <Widget>[
                            for (int index = 0;
                                index < _items!.length;
                                index += 1)
                              ListTile(
                                key: ValueKey('$index'),
                                tileColor:
                                    index.isOdd ? oddItemColor : evenItemColor,
                                title: Text(
                                  '${categoryItems!.where((element) => int.parse(element.categoryId!) == _items![index]).first.categoryName}',
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontRegular),
                                ),
                                trailing: Icon(Icons.menu),
                              ),
                          ],
                          onReorder: reorderData,
                        )
                      : Container(),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ));
  }

  void reorderData(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
        rearrangeCategory();
        rearrangeCategory();
      }

      int item = _items!.removeAt(oldIndex);
      _items!.insert(newIndex, item);
    });
  }

  Future<GetCategories?> getCategories(BuildContext context) async {
    var user = await Utils.getUser();
    var id = user.data!.id;
    try {
      FormData from =
          FormData.fromMap({"kitchen_id": id, "token": "123456789"});
      GetCategories bean = await ApiProvider().getCategories();

      if (bean.status == true) {
        setState(() {
          categoryItems = bean.data;
          _items = categoryItems!
              .map<int>((row) => int.parse(row.categoryId!))
              .toList();
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

  void validaton() {
    // var title = categoryTitle.text.toString();
    // var descriptionText = description.text.toString();
    // if (title.isEmpty) {
    //   Utils.showToast("Enter Category Title");
    // }  else {
    //   if(descriptionText.isEmpty)
    //   {
    //     descriptionText = " ";
    //   }
    //   addCategory(title, descriptionText);
    // }
  }

  Future<RearrangeCategory?> rearrangeCategory() async {
    var userBean = await Utils.getUser();

    var id = userBean.data!.id;
    try {
      FormData data;
      data = FormData.fromMap({
        "kitchen_id": id,
        "category_ids": jsonEncode(_items),
        "token": "123456789",
      });
      RearrangeCategory? bean =
          await ApiProvider().reArrangeCategory(jsonEncode(_items));

      if (bean.status == true) {
        Utils.showToast(bean.message ?? "", context);
        //Navigator.pop(context, true);
        return bean;
      } else {
        Utils.showToast(bean.message ?? "", context);
      }
    } on HttpException {
    } catch (exception) {}
    return null;
  }
}
