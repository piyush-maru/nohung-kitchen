import 'dart:core';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/model/BeanSendMessage.dart' as Chat;
import 'package:kitchen/model/GetChat.dart';
import 'package:kitchen/model/GetChat.dart' as response;
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/HttpException.dart';

import '../../../model/KitchenData/BeanLogin.dart';
import '../../../res.dart';
import '../../../utils/Utils.dart';

class CustomerChatScreen extends StatefulWidget {
  @override
  _CustomerChatScreenState createState() => _CustomerChatScreenState();
}

class _CustomerChatScreenState extends State<CustomerChatScreen> {
  var type = "";
  Future? future;
  ScrollController scrollController = ScrollController();

  List<response.Chat>? list;
  List<response.Data>? temp;
  Future<List<response.Chat>?>? _future;

  BeanLogin? userBean;
  var userId = "";

  var _msg = TextEditingController();

  void getUser() async {
    userBean = await Utils.getUser();
    userId = userBean!.data!.id.toString();

    setState(() {});
  }

  @override
  void initState() {
    getUser();
    Future.delayed(Duration.zero, () {
      _future = getChat(context);
    });
    super.initState();
  }

/*
  Future<List<Chat.Result>> getChat(BuildContext context) async {
    var user = await Utils.getUser();
    userID = user.result[0].userId;
    FormData data = FormData.fromMap({
      "user_id": userID,
      "fri_id": bean.tutorId
    });
    GetMsg getMsg = await ApiProvider.baseUrl().getMsg(data);
    list = getMsg.result;
    if(list==null){
      list = List();
    }
    return list;

  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          leading: BackButton(),
          backgroundColor: AppConstant.appColor,
          title: Row(
            children: [
              Image.asset(
                Res.ic_chef,
                width: 50,
                height: 50,
              ),
              Text('Admin'),
            ],
          )),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: FutureBuilder<List<response.Chat>?>(
                future: _future,
                builder: (context, projectSnap) {
                  if (projectSnap.connectionState == ConnectionState.done) {
                    if (projectSnap.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: list!.length,
                        reverse: true,
                        //controller: scrollController,
                        itemBuilder: (context, index) {
                          return chatDesign(list![index]);
                        },
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Color(0xffF3F6FA),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _msg,
                          decoration: InputDecoration.collapsed(
                              hintText: "  Write message"),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          validation();
                        },
                        child: Image.asset(
                          Res.ic_send,
                          width: 30,
                          height: 30,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      )
                    ],
                  )),
            ),
            //AppConstant().navBarHt(),
          ],
        ),
      ),
    );
  }

  Future<List<response.Chat>?> getChat(BuildContext context) async {
    FormData from =
        FormData.fromMap({"kitchen_id": userId, "token": "123456789"});
    GetChat? bean = await ApiProvider().getChat();

    list = bean.data!.chat!.reversed.toList();
    if (bean.status == true) {
      if (list == null) {
        list = [];
      }
      setState(() {});

      return list;
    }
    return null;
  }

  chatDesign(response.Chat result) {
    if (result.msgType == "sent") {
      return Align(
        alignment: Alignment.topRight,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.25,
              right: 6,
              top: 6,
              bottom: 6),
          decoration: BoxDecoration(
              color: Color(0xffBEE8FF),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                  child: Text(
                result.message! + '',
                style: TextStyle(
                    color: Colors.black, fontFamily: AppConstant.fontRegular),
              )),
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: Text(result.time!,
              //         style: TextStyle(
              //           fontFamily: AppConstant.fontRegular,
              //             fontSize: 10, color: Color(0xff757575))),
              //   ),
            ],
          ),
        ),
      );
    } else if (result.msgType == "received") {
      return Container(
          margin: EdgeInsets.only(
              top: 6,
              bottom: 6,
              left: 6,
              right: MediaQuery.of(context).size.width * 0.6),
          // width: MediaQuery.of(context).size.width*0.25,
          padding: EdgeInsets.only(left: 12, top: 16, right: 16, bottom: 16),
          decoration: BoxDecoration(
              color: Color(0xffF3F6FA),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10))),
          child: AutoSizeText(
            result.message!,
            style: TextStyle(
                color: Colors.black, fontFamily: AppConstant.fontRegular),

            // Text(result.time!,style: TextStyle(fontFamily: AppConstant.fontRegular,fontSize: 10, color: Color(0xff757575)),)
          ));
    }
  }

  Future<Chat.BeanSendMessage?> sendMessage(String messageInput) async {
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId,
        "token": "123456789",
        "message": messageInput,
      });
      Chat.BeanSendMessage? bean =
          await ApiProvider().sendMessage(messageInput);
      //
      if (bean.status == true) {
        Utils.showToast(bean.message ?? "", context);
        getChat(context);

        messageInput = _msg.text = "";

        response.Chat result = response.Chat();
        result.message = bean.data!.message;
        result.msgType = bean.data!.msgType;
        result.createddate = bean.data!.createddate;

        if (list != null) {
          list!.add(result);
        } else {
          list = [];
          list!.add(result);
        }
        setState(() {
          messageInput = _msg.text = "";
        });
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

  void validation() {
    var messageInput = _msg.text.toString();
    if (messageInput.isEmpty) {
      Utils.showToast("Please Enter Message", context);
    } else {
      sendMessage(messageInput);
    }
  }
}
