import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kitchen/model/GetCategoryDetails.dart';
import 'package:kitchen/model/GetCategoryItems.dart';
import 'package:kitchen/model/updateItemStock.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/src/presentation/screens/HomeBaseScreen.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';

import '../../../model/KitchenData/BeanLogin.dart';
import 'AddCategoryItem.dart';
import 'ArrangeCategoryItems.dart';
import 'CustomerChatScreen.dart';
import 'EditCategoryItem.dart';

class CategoryItemsScreen extends StatefulWidget {
  var categoryId;

  CategoryItemsScreen({this.categoryId});

  @override
  _CategoryItemsScreenState createState() => _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends State<CategoryItemsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<GetCategoryItems?>? futureLive;
  BeanLogin? userBean;
  bool isPageLoading = true;
  UpdateItemStock? bean;
  String categoryTitle = '';
  String description = '';
  var name = "";
  var menu = "";
  var userId = "";

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      futureLive = getCategoryItems(context);
    });

    super.initState();
  }

  Future<GetCategoryDetails?> getCategoryDetail(
      BuildContext context, String categoryId) async {
    try {
      var userBean = await Utils.getUser();
      FormData from = FormData.fromMap({
        "kitchen_id": userBean.data!.id,
        'category_id': categoryId,
        "token": "123456789"
      });
      GetCategoryDetails? bean =
          await ApiProvider().getCategoryDetail(categoryId);

      if (bean.status == true) {
        setState(() {
          isPageLoading = false;
          categoryTitle = bean.data!.categoryName!;
          description = bean.data!.description!;
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

  Future<void> _pullRefresh() async {
    setState(() async {
      await Future.delayed(Duration.zero, () {
        futureLive = getCategoryItems(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawers(),
        key: _scaffoldKey,
        backgroundColor: AppConstant.appColor,
        appBar: AppBar(
          backgroundColor: AppConstant.appColor,
          elevation: 0,
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoryTitle,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: AppConstant.fontBold),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 10),
                    backgroundColor: AppConstant.lightGreen),
                onPressed: () {
                  arrangeCategoryItems();
                },
                child: const Text(
                  'Re-Arrange Category Items',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        body: new RefreshIndicator(
          onRefresh: _pullRefresh,
          child: Column(
            children: [
              Text(
                description,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: AppConstant.fontRegular),
              ),
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
          ),
        ));
  }

  MenuSelected() {
    return Column(
      children: [
        Expanded(
            child: Stack(
          children: [
            FutureBuilder<GetCategoryItems?>(
                future: futureLive,
                builder: (context, projectSnap) {
                  if (projectSnap.connectionState == ConnectionState.done) {
                    var result;
                    if (projectSnap.data != null) {
                      result = projectSnap.data!.data;
                      if (result != null) {
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return getCategoryItemsWidget(result[index]);
                          },
                          itemCount: result.length,
                        );
                      }
                    }
                  }
                  return Container(
                      child: Center(
                    child: Text(
                      "No Items Found",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: AppConstant.fontBold),
                    ),
                  ));
                }),
            Positioned.fill(
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                      padding: EdgeInsets.only(right: 16, bottom: 0),
                      child: InkWell(
                        onTap: () {
                          _ackAlert(context);
                        },
                        child: Image.asset(
                          Res.ic_add_round,
                          width: 65,
                          height: 65,
                        ),
                      ))),
            )
          ],
        )),
        AppConstant().navBarHt()
      ],
    );
  }

  Future<void> updateItemInstockStatus(String value, menuId) async {
    var userBean = await Utils.getUser();
    FormData form = FormData.fromMap({
      "token": "123456789",
      "instock": value,// ? "y" : "n"
      "kitchen_id": userBean.data!.id.toString(),
      "category_id": widget.categoryId,
      "menu_id": menuId
    });
    print("==============================value====================>${value}");
    print("==============================userBean.data!.id.toString()====================>${userBean.data!.id.toString()}");
    print("==============================categoryId====================>${widget.categoryId}");
    print("==============================menuId====================>${menuId}");
    bean = await ApiProvider()
        .updateItemInStock(value, widget.categoryId, menuId);// ? "y" : "n"
    if (bean!.status == true) {
      print("=======================INSTOCK====================>${bean}");
      Utils.showToast(bean!.message ?? "", context);
      setState(() {
        // isKitchenActive = value;
      });
    } else {
      Utils.showToast(bean!.message ?? "", context);
    }
  }


  Future<GetCategoryItems?> getCategoryItems(BuildContext context) async {
    var user = await Utils.getUser();
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": user.data!.id,
        "category_id": widget.categoryId,
        "token": "123456789"
      });
      GetCategoryItems bean =
          await ApiProvider().getCategoryItems(widget.categoryId);

      if (bean.status == true) {
        setState(() {});

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

  getCategoryItemsWidget(result) {
    String itemTypeModified;
    if (result.itemType == "nonveg") {
      itemTypeModified = "Non-Veg";
    } else if (result.itemType == "veg") {
      itemTypeModified = "Veg";
    } else {
      itemTypeModified = "Veg / Non-Veg";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: AppConstant.appColor),
                  color: Colors.white,
                  //result.itemType == "nonveg" ? Colors.brown : Colors.green,
                  borderRadius: BorderRadius.circular(5)),
              height: 30,
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      result.itemType == "nonveg" ? Res.ic_chiken : Res.ic_veg,
                      width: 20,
                      height: 20,
                    ),
                    Text(
                      itemTypeModified,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: AppConstant.fontBold,
                          fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  child: Switch(
                    value: result.instock == 'y' ? true : false,
                    onChanged: (value) {
                      updateItemInstockStatus(value?"y":"n", result.menuId);
                      setState(() {
                        print("=---------------=>${result.instock }");
                        result.instock = result.instock == 'y' ? 'n' : 'y';
                      });
                    },
                    activeColor: AppConstant.appColor,
                    activeTrackColor: AppConstant.appColorLite,
                  ),
                ),
                // IconButton(
                //   onPressed: () {
                //     editCategoryItems(result.menuId);
                //     // Navigator.push(
                //     //     context,
                //     //     MaterialPageRoute(
                //     //         builder: (context) =>
                //     //             EditCategoryItemScreen(categoryId: widget.categoryId,categoryItemId: result.menuId,)));
                //   },
                //   icon: Icon(Icons.edit),
                //   color: Colors.blue,
                // ),
                // IconButton(
                //   onPressed: () async {
                //     var user = await Utils.getUser();
                //     ApiProvider()
                //         .deleteCategoryItem(FormData.fromMap({
                //       'token': '123456789',
                //       'kitchen_id': user.data!.id,
                //       'category_id': widget.categoryId,
                //       'menu_id': result.menuId,
                //     }))
                //         .then((value) {
                //       setState(() {
                //         futureLive = getCategoryItems(context);
                //       });
                //     });
                //   },
                //   icon: Icon(Icons.delete),
                //   color: Colors.red,
                // ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  result.itemName,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstant.fontBold,
                      fontSize: 14),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
              width: 65,
              decoration: BoxDecoration(
                  color: Color(0xffBEE8FF),
                  borderRadius: BorderRadius.circular(5)),
              height: 25,
              child: Center(
                child: Text(
                  "₹ " + result.itemPrice,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppConstant.fontBold,
                      fontSize: 11),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5),
          child: Text(
            "Cuisine:- " + result.cuisineType.join(', '),
            style: TextStyle(
                color: Colors.grey,
                fontFamily: AppConstant.fontBold,
                fontSize: 12),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5),
          child: Text(
            "Mealfor:- " + result.mealFor.join(', '),
            style: TextStyle(
                color: Colors.grey,
                fontFamily: AppConstant.fontBold,
                fontSize: 12),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5),
          child: Text(
            "Description:- " + result.description,
            style: TextStyle(
                color: Colors.grey,
                fontFamily: AppConstant.fontBold,
                fontSize: 12),
            maxLines: 8,
            overflow: TextOverflow.visible,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Divider(
          thickness: 2,
          color: Colors.grey.shade200,
        ),
      ],
    );
  }

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
                padding: EdgeInsets.all(12),
                height: MediaQuery.of(context).size.height * 0.45,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.cancel,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    SvgPicture.asset("assets/images/contact_us.svg"),
                    Text(
                      "Contact NOHUNG \n     to add Items",
                      style: TextStyle(
                          fontSize: 20, fontFamily: AppConstant.fontRegular),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                      child: Text(
                        'Contact',
                        style: TextStyle(fontFamily: AppConstant.fontRegular),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(AppConstant.appColor),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/adminChat');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerChatScreen()),
                        );
                        //_launchInBrowser(toLaunch);
                        // Navigator.pop(context);
                      },
                    )
                  ],
                )));
      },
    );
  }

  addCategoryItems() async {
    var data = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddCategoryItemScreen(
        categoryId: widget.categoryId,
      ),
    ));
    if (data != null) {
      futureLive = getCategoryItems(context);
    }
  }

  editCategoryItems(menuId) async {
    var data = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditCategoryItemScreen(
        categoryId: widget.categoryId,
        categoryItemId: menuId,
      ),
    ));
    if (data != null) {
      futureLive = getCategoryItems(context);
    }
  }

  arrangeCategoryItems() async {
    var data = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ArrangeCategoryItemsScreen(
          categoryId: widget.categoryId, kitchenId: userId),
    ));
    if (data != null) {
      futureLive = getCategoryItems(context);
    }
  }
}
