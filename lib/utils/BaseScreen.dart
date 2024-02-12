import 'package:flutter/material.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/utils/Constants.dart';

import '../src/presentation/screens/HomeBaseScreen.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var isSelected = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawers(),
        key: _scaffoldKey,
        backgroundColor: AppConstant.appColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                    ),
                    InkWell(
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
                    SizedBox(
                      width: 16,
                    ),
                    Image.asset(
                      Res.ic_chef,
                      width: 65,
                      height: 65,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16, top: 50),
                          child: Text(
                            "Name oF Kitchen",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: AppConstant.fontBold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            "Finest multi-cusine",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: AppConstant.fontRegular),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                height: 150,
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                height: 55,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white)),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              isSelected = 1;
                            });
                          },
                          child: Container(
                            height: 60,
                            width: 180,
                            decoration: BoxDecoration(
                                color: isSelected == 1
                                    ? Colors.white
                                    : Color(0xffFFA451),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(100),
                                    bottomLeft: Radius.circular(100))),
                            child: Center(
                              child: Text(
                                "Menu",
                                style: TextStyle(
                                    color: isSelected == 1
                                        ? Colors.black
                                        : Colors.white,
                                    fontFamily: AppConstant.fontBold),
                              ),
                            ),
                          )),
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              isSelected = 2;
                            });
                          },
                          child: Container(
                            height: 60,
                            width: 180,
                            decoration: BoxDecoration(
                                color: isSelected == 2
                                    ? Colors.white
                                    : Color(0xffFFA451),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(100),
                                    bottomRight: Radius.circular(100))),
                            child: Center(
                              child: Text(
                                "Packages",
                                style: TextStyle(
                                    color: isSelected == 2
                                        ? Colors.black
                                        : Colors.white,
                                    fontFamily: AppConstant.fontBold),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
