import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:kitchen/utils/Constants.dart';

import '../model/KitchenData/BeanLogin.dart';
import 'PrefManager.dart';

class Utils {
  String formattedDate(String x) {
    final parsedDateTime = DateTime.parse(x);
    return DateFormat.yMMMd().format(parsedDateTime);
  }

  static const gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.05, 0.9],
      colors: [Color(0xffEFEFEF)]);

  static showToast(String msg, BuildContext context) {
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   backgroundColor: AppConstant.appColor,
    //   duration: Duration(seconds: 5),
    //   closeIconColor: Colors.white,
    //   onVisible: (){
    //     Navigator.pop(context);
    //   },
    //   elevation: 20.0,
    //   showCloseIcon: true,
    //   content: Container(
    //       height: 30,
    //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
    //       child: Text(
    //         msg,
    //         style: TextStyle(fontFamily: AppConstant.fontRegular, fontSize: 20),
    //       )),
    // ));
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static Widget getLoader() {
    return CircularProgressIndicator();
  }

  static void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print("${match.group(0)}"));
  }

  static Future<BeanLogin> getUser() async {
    var data = await PrefManager.getString(AppConstant.user);

    return BeanLogin.fromJson(json.decode(data));
  }
}
