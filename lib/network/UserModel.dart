import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../model/KitchenData/BeanLogin.dart';
import '../utils/Constants.dart';
import 'EndPoints.dart';

class UserModel extends ChangeNotifier{

  Dio? _dio;
  DioError? _dioError;
  BeanLogin? user;

  Future<BeanLogin?> getUser()async{
    if(user==null)
      user=(await Hive.openBox<BeanLogin>(UserBoxName)).get(UserKey,defaultValue: null);
    return user;
  }

  Future<void> cacheUser(BeanLogin user)async{
    await Hive.box(UserBoxName).put(UserKey, user);
  }

  Future loginUser(FormData params) async {
    try {
      Response response = await _dio!.post("$testingUrl${EndPoints.login}", data: params);
      return BeanLogin.fromJson(json.decode(response.data));
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      Map<dynamic, dynamic> map = _dioError!.response!.data;
      if (_dioError!.response!.statusCode == 500) {
        throwIfNoSuccess(map['message']);
      } else {
        throwIfNoSuccess("Something gone wrong.");
      }
    }
  }

  void throwIfNoSuccess(String response) {
    throw new HttpException(response);
  }


}