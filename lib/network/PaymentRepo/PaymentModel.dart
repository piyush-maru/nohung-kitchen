import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../model/Bank Account Data/GetPayment.dart';
import '../../model/Bank Account Data/bankAccountsModel.dart';
import '../../utils/Constants.dart';
import '../../utils/Utils.dart';
import '../EndPoints.dart';

class TransactionHistoryModel extends ChangeNotifier {
  GetPayment? payment;
  var data = [];
  List<GetPayment> filter = [];

  BankAccountsModel? bankAccounts;
  List<BankAccountsModel> account = [];

  List<BankAccountsModel> accounts() => account;

  Future<GetPayment?> transactionHistory(String page, String? query) async {
    var userBean = await Utils.getUser();

    http.Response response = await http
        .post(Uri.parse("$testingUrl" + EndPoints.get_transaction), body: {
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
      "page_no": page
    });

    if (response.statusCode == 200) {
      GetPayment payment = GetPayment.fromJson(jsonDecode(response.body));

      filter = data.map((e) => GetPayment.fromJson(e)).toList();

      if (query != null) {
        // GetPayment(data: getPayment.data).data.transaction.where((element) {
        //   return element.customerName.contains(query);
        //}).toList();
        filter = filter
            .where((element) =>
                element.data.transaction.contains(query.toLowerCase()))
            .toList();
        filter.forEach((element) {});
      }
      payment.data.transaction = payment.data.transaction
          .where((transaction) =>
              transaction.customerName
                  .toLowerCase()
                  .startsWith(query?.toLowerCase() ?? "") ||
              transaction.orderNumber.contains(query ?? ""))
          .toList();

      return payment;
    } else {
      throw Exception("Something went wrong");
    }
  }

  Future<BankAccountsModel> getBankAccount() async {
    var userBean = await Utils.getUser();

    http.Response response = await http.post(
        Uri.parse(EndPoints.get_bank_accounts),
        body: {"kitchen_id": userBean.data!.id, "token": "123456789"});
    if (response.statusCode == 200) {
      BankAccountsModel bankAccountsModel =
          BankAccountsModel.fromJson(json.decode(response.body));

      return bankAccountsModel;
    } else {
      throw Exception("Something went wrong");
    }
  }
}
