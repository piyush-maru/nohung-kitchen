import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/model/GetCategoryItems.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';

import '../../../model/Rearrange Category/rearrangeCategoryItems.dart';

class ArrangeCategoryItemsScreen extends StatefulWidget {
  String? categoryId;
  String? kitchenId;

  ArrangeCategoryItemsScreen({this.categoryId, this.kitchenId});

  @override
  _ArrangeCategoryItemsScreenState createState() =>
      _ArrangeCategoryItemsScreenState();
}

class _ArrangeCategoryItemsScreenState
    extends State<ArrangeCategoryItemsScreen> {
  List<Data>? categoryItems;
  List<int>? _items;
  var name = "";
  var menu = "";

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getCategoryItems(context);
    });
    super.initState();
  }

  Future<void> _pullRefresh() async {
    setState(() async {
      await Future.delayed(Duration.zero, () {
        getCategoryItems(context);
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
          elevation: 0,
          backgroundColor: AppConstant.appColor,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Re-Arrange Category Items",
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: AppConstant.fontBold),
          ),
        ),
        body: Column(children: [
          // Container(
          //   padding: EdgeInsets.all(12),
          //   color: AppConstant.appColor,
          //   height: 80,
          //   child: Row(
          //     children: [
          //       IconButton(
          //           onPressed: () {
          //             Navigator.pop(context);
          //           },
          //           icon: Icon(Icons.arrow_back)),
          //       Text(
          //         "Re-Arrange Category Items",
          //         style: TextStyle(
          //             color: Colors.black,
          //             fontSize: 18,
          //             fontFamily: AppConstant.fontBold),
          //       ),
          //     ],
          //   ),
          // ),
          Text(
            "Note : Please Scroll From Top to Bottom to Re-Arrange Category",
            style: TextStyle(fontFamily: AppConstant.fontBold),
          ),
          new RefreshIndicator(
            onRefresh: _pullRefresh,
            child: Stack(children: [
              SizedBox(
                height: 12,
              ),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.only(top: 24),
                  height: 650,
                  child: _items != null
                      ? ReorderableListView(
                          primary: true,
                          clipBehavior: Clip.none,
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
                                  '${categoryItems!.where((element) => int.parse(element.menuId!) == _items![index]).first.itemName}',
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
              ),
              SizedBox(
                height: 12,
              ),
            ]),
          )
        ]));
  }

  void reorderData(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;

        rearrageCategoryItems();
      }
      int item = _items!.removeAt(oldIndex);
      _items!.insert(newIndex, item);
    });
  }

  Future<GetCategoryItems?> getCategoryItems(BuildContext context) async {
    try {
      var userBean = await Utils.getUser();
      FormData from = FormData.fromMap({
        "kitchen_id": userBean.data!.id,
        "category_id": widget.categoryId,
        "token": "123456789"
      });

      GetCategoryItems bean =
          await ApiProvider().getCategoryItems(widget.categoryId!);

      if (bean.status == true) {
        setState(() {
          categoryItems = bean.data;
          _items = categoryItems!
              .map<int>((row) => int.parse(row.menuId ?? ""))
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

  Future<RearrangeCategoryItems?> rearrageCategoryItems() async {
    var userBean = await Utils.getUser();
    try {
      FormData data;

      data = FormData.fromMap({
        "kitchen_id": userBean.data!.id,
        "category_id": widget.categoryId,
        "menu_ids": jsonEncode(_items),
        "token": "123456789",
      });

      RearrangeCategoryItems? bean = await ApiProvider()
          .reArrangeCategoryItems(widget.categoryId!, jsonEncode(_items));

      if (bean.status == true) {
        Utils.showToast(bean.message ?? "", context);
        return bean;
      } else {
        Utils.showToast(bean.message ?? "", context);
      }
    } on HttpException {
    } catch (exception) {}
    return null;
  }
}
