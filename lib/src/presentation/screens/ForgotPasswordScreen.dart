import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';
import 'package:kitchen/utils/Utils.dart';

import '../../../model/KitchenData/BeanForgotPassword.dart';
import '../../../model/KitchenData/GetAccountDetail.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var email = TextEditingController();
  var emailId;

  GetAccountDetails? accValue;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 16, left: 16),
                    child: Image.asset(
                      Res.ic_back,
                      width: 16,
                      height: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 16),
                  child: Text(
                    "Forgot password",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppConstant.fontBold,
                        fontSize: 16),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, top: 20, right: 16),
              child: TextFormField(
                controller: email,
                decoration: InputDecoration(
                  labelText: "Enter Email ",
                  fillColor: Colors.grey,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 1,
              ),
            ),
            InkWell(
              onTap: () {
                //emailId==email.toString()?
                forgotPassword(); //:ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a correct email with this account"),),);
              },
              child: Container(
                margin:
                    EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                decoration: BoxDecoration(
                  color: AppConstant.appColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "CONTINUE",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                height: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<GetAccountDetails?> getAccountDetails(BuildContext context) async {
    var user = await Utils.getUser();

    try {
      FormData from = FormData.fromMap(
          {"user_id": user.data!.id.toString(), "token": "123456789"});
      GetAccountDetails bean = await ApiProvider().getAccountDetails();

      if (bean.status == true) {
        setState(() {
          emailId = bean.data!.email;
        });
        return bean;
      } else {
        Utils.showToast(bean.message.toString(), context);
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {
      print(exception);
    }
    return null;
  }

  Future<BeanForgotPassword?> forgotPassword() async {
    try {
      FormData from = FormData.fromMap(
          {"email": email.text.toString(), "token": "123456789"});
      BeanForgotPassword? bean = await ApiProvider().forgotPassword(email.text);

      if (bean.status == true) {
        Utils.showToast(bean.message ?? "", context);
        setState(() {
          email.text = "";
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
}
