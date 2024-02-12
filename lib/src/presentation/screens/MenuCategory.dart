import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitchen/Order/OrderScreen.dart';
import 'package:kitchen/main.dart';
import 'package:kitchen/model/BeanGetOrderRequest.dart';
import 'package:kitchen/model/GetCategories.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/network/OrderRepo/order_request_model.dart';
import 'package:kitchen/res.dart';
  import 'package:kitchen/src/presentation/screens/CategoryItems.dart';
import 'package:kitchen/src/presentation/screens/DashboardScreen.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../../../model/KitchenData/BeanLogin.dart';
import 'AddMenuCategory.dart';
import 'ArrangeCategory.dart';
import 'CustomerChatScreen.dart';
import 'EditMenuCategory.dart';
import 'HomeBaseScreen.dart';

class MenuCategoryScreen extends StatefulWidget {
  final bool? currentTablSelected;
  MenuCategoryScreen(this.currentTablSelected);
  @override
  _MenuCategoryScreenState createState() => _MenuCategoryScreenState();
}

class _MenuCategoryScreenState extends State<MenuCategoryScreen>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<GetCategories?>? _future;
  List<Data>? categoryItems;
  List<int>? _items;
  Timer? timer;
  bool? kitchenStatus = true;
  var userId;
  bool isBackground = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _future = getCategories(context);
    });
    getUserData();
    // getOrderRequest(context);
    super.initState();
    const twentyMillis = Duration(seconds: 2);
    timer = Timer.periodic(twentyMillis, (timer) {
      if (kitchenStatus == true || kitchenStatus == null) {
        final orderRequest =
            Provider.of<OrderRequestModel>(context, listen: false);
        getOrderRequest2(context);
        // _future = getOrders(context);
      } else {
        timer.cancel();
      }
    });
    WidgetsBinding.instance.addObserver(this);
    if (WidgetsBinding.instance.lifecycleState != null) {
      // _stateHistoryList.add(WidgetsBinding.instance.lifecycleState!);
    }
    // const twentyMillis = Duration(seconds: 20);
    // timer = Timer.periodic(twentyMillis, (timer) {

    //   if(widget.currentTablSelected!){
    //   if (kitchenStatus == true || kitchenStatus == null) {

    //     getOrderRequest(context);
    //     // _future = getOrders(context);
    //   }
    //   } else {

    //     timer.cancel();
    //   }
    // });
  }

  @override
  void dispose() {
    //timer!.cancel();
    super.dispose();
  }

  Future<void> _pullRefresh() async {
    setState(() async {
      await Future.delayed(Duration.zero, () {
        _future = getCategories(context);
      });
    });
  }

  /* @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      setState(() {
        isBackground = true;
      });

    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        isBackground = false;
      });

    } else if (AppLifecycleState.paused == state) {
      //setState(() {
        isBackground = true;
      //});

    }
  }*/

  Future<dynamic> getOrderRequest(BuildContext context) async {
    try {
      BeanGetOrderRequest? bean = await ApiProvider().getOrderRequest();
      if (bean!.status == true) {
        int? lenght = await getOrdersRequestCount();
        if (bean.data!.length > (lenght ?? 0)) {
          // PerfectVolumeControl.setVolume(1);
          // AudioPlayer().play(AssetSource('notification_sound.mp3'));
          if (!isBackground) {
            timer!.cancel();
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: OrderScreen(true, 0),
              withNavBar: true,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          } else {
            // PerfectVolumeControl.setVolume(1);
            // AudioPlayer().play(AssetSource('notification_sound.mp3'));
          }
          // Navigator.pushNamed(context, '/orders');
        }
        // saveOrdersRequestCount(bean.data.length);

        return bean;
      } else {
        return bean;
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<void> getUserData() async {
    kitchenStatus = await getKitchenStatus();
    var userBean = await Utils.getUser();
    setState(() {
      userId = userBean.data!.id.toString();
      kitchenStatus = kitchenStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          backgroundColor: AppConstant.appColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            _ackAlert(context);
          },
        ),
      ),
      drawer: MyDrawers(),
      key: _scaffoldKey,
      backgroundColor: AppConstant.appColor,
      appBar: AppBar(
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Master Menu",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: AppConstant.fontBold),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 12),
                    backgroundColor: AppConstant.lightGreen),
                onPressed: () {
                  arrangeCategory();
                },
                child: const Text(
                  'Re-Arrange Category',
                  style: TextStyle(
                      color: Colors.black, fontFamily: AppConstant.fontRegular),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          new RefreshIndicator(
            onRefresh: _pullRefresh,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              height: MediaQuery.of(context).size.height * 0.85,
              margin: EdgeInsets.only(top: 20),
              child: menuSelected(),
            ),
          ),
        ],
      ),
    );
  }

  menuSelected() {
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            FutureBuilder<GetCategories?>(
                future: _future,
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
                            return getCategoriesWidget(result[index]);
                          },
                          itemCount: result.length,
                        );
                      }
                    }
                  }
                  return Container(
                      child: Center(
                    child: Text(
                      "No Active Categories Found",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: AppConstant.fontBold),
                    ),
                  ));
                }),
            /* Align(
          alignment: Alignment.bottomRight,
          child: InkWell(
            onTap: () {
              _ackAlert(context);
              //addcategory();
            },
            child: Image.asset(
              Res.ic_add_round,
              width: 65,
              height: 65,
            ),
          ),
        ),*/
            AppConstant().navBarHt(),
            SizedBox(
              height: 48,
            ),
          ],
        ));
  }

  reArrange(context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return Container(
      height: 300.0, // Change as per your requirement
      width: 260.0,
      child: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        children: <Widget>[
          for (int index = 0; index < _items!.length; index += 1)
            ListTile(
              key: ValueKey('$index'),
              tileColor: index.isOdd ? oddItemColor : evenItemColor,
              title: Text(
                  '${categoryItems!.where((element) => int.parse(element.categoryId!) == _items![index]).first.categoryName}'),
            ),
        ],
        onReorder: reorderData,
      ),
    );
  }

  void reorderData(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      int item = _items!.removeAt(oldIndex);
      _items!.insert(newIndex, item);
    });
  }

  getCategoriesWidget(result) {
    return Container(
      margin: EdgeInsets.only(left: 10, bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                child: Center(
                  child: Text(
                    result.categoryName,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppConstant.fontBold,
                        fontSize: 18),
                  ),
                ),
              ),
              Row(
                children: [
                  // IconButton(
                  //   onPressed: () {
                  //     editCategory(result.categoryId);
                  //     // Navigator.push(context, MaterialPageRoute(builder: (context) => EditMenuCategoryScreen(categoryId :result.categoryId)));
                  //   },
                  //   icon: Icon(Icons.edit),
                  //   color: Colors.blue,
                  // ),
                  // IconButton(
                  //   onPressed: () async {
                  //     _ackAlert(context,result.categoryId);

                  //   },
                  //   icon: Icon(Icons.delete),
                  //   color: Colors.red,
                  // ),

                  // IconButton(
                  //   onPressed: () {
                  //     editCategory(result.categoryId);
                  //     // Navigator.push(context, MaterialPageRoute(builder: (context) => EditMenuCategoryScreen(categoryId :result.categoryId)));
                  //   },
                  //   icon: Icon(Icons.edit),
                  //   color: Colors.blue,
                  // ),
                  // IconButton(
                  //   onPressed: () async {
                  //     //_ackAlert(context, result.categoryId);

                  //   },
                  //   icon: Icon(Icons.delete),
                  //   color: Colors.red,
                  // ),

                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryItemsScreen(
                              categoryId: result.categoryId),
                        ),
                      );
                    },
                    icon: Icon(Icons.remove_red_eye),
                    color: AppConstant.appColor,
                  ),
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
                    result.description,
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Divider(
            thickness: 2,
            color: AppConstant.appColor,
          ),
        ],
      ),
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
                  "Contact NOHUNG \n  to add Menu",
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
            ),
          ),
        );
      },
    );
  }

  Future<void> _ackAlert123(BuildContext context, String categoryId) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: const Text('Are you sure to delete this'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                deleteMenu(categoryId);

                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Future<void> deleteMenu(String categoryId) async {
    BeanLogin? userBean = await Utils.getUser();

    ApiProvider().deleteCategory(categoryId).then((value) {
      setState(() {
        _future = getCategories(context);

        Navigator.pop(context);
      });
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

  addcategory() async {
    var data = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddMenuCategoryScreen()));
    if (data != null) {
      _future = getCategories(context);
    }
  }

  editCategory(categoryId) async {
    var data = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditMenuCategoryScreen(
              categoryId: categoryId,
            )));
    if (data != null) {
      _future = getCategories(context);
    }
  }

  arrangeCategory() async {
    var data = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ArrangeCategoryScreen(),
    ));
    if (data != null) {
      _future = getCategories(context);
    }
  }
}
