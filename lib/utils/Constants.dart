import 'package:flutter/material.dart';

const String UserBoxName = 'UserBoxName';
const String UserKey = 'userKey';

 //final testingUrl = "https://nohungtest.tech/api/kitchen/";
 final testingUrl = "https://nohung.com/api/kitchen/";

class AppConstant {
  static const fontRegular = 'productsans_regular';
  static const fontBold = 'productsans_bold';
  static const dollar = '\$';
  static const rupee = '₹';
  static const lang = "lang";
  static const appColor = Color(0xffFFA451);
  static const appColorLite = Color.fromARGB(255, 255, 195, 116);
  static const lightGreen = Color(0xff7EDABF);
  static const user = "UserData";
  static const session = "session";
  static const ImageUrl = "https://nohungtesting.com/assets/uploaded/customer/";
  static const noImageUrl =
      'https://nohungtesting.com/assets/image/noimage.jpg';
  static const menuUrl = "https://nohungtesting.com/assets/uploaded/menu/";
  static const document = "https://nohungtesting.com/assets/uploaded/document/";
  Widget navBarHt() => SizedBox(
        height: 65,
      );
}
