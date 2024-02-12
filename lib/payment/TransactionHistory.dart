import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kitchen/payment/PaymentScreen.dart';
import 'package:provider/provider.dart';

import '../model/Bank Account Data/GetPayment.dart';
import '../model/Bank Account Data/bankAccountsModel.dart';
import '../model/BeanGetOrderDetails.dart';
import '../model/KitchenData/BeanLogin.dart';
import '../network/ApiProvider.dart';
import '../network/PaymentRepo/PaymentModel.dart';
import '../utils/Constants.dart';
import '../utils/HttpException.dart';
import '../utils/Utils.dart';

class TransactionHistory extends StatefulWidget {
  final List<Transaction> prospects;

  const TransactionHistory({Key? key, required this.prospects})
      : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory>
    with AutomaticKeepAliveClientMixin<TransactionHistory> {
  Future<GetPayment?>? future;
  final scrollController = ScrollController();

  var accountName = TextEditingController();
  var bank = TextEditingController();
  var ifscCode = TextEditingController();
  var accountNumber = TextEditingController();
  var amount = TextEditingController();
  BankAccountsModel? bankAccounts;
  BeanLogin? userBean;

  //List<Pagination> paginationData = [];
  int currentPage = 0;
  int maxPages = 0;
  var descriptionController = TextEditingController();
  var searchController = TextEditingController();
  GetOrderDetailsData? orderData;
  var currentBalance = '';
  var orderId = '';
  var orderItemId = '';
  bool isLoading = true;
  bool isViewLoading = false;
  int paymentIndex = 0;
  int page = 1;
  int positionPercent = 0;
  bool isShow=false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() async {
      int positionPercent = (scrollController.position.pixels *
              100 /
              scrollController.position.maxScrollExtent)
          .round();
      positionPercent = positionPercent;
      if (currentPage < maxPages && !isLoading && positionPercent == 100) {
        // maxPages = paymentModel.payment!.data.pagination.totalPage;
        // setState(() {
        addTransactions();
      } else {
        // scrollController = null;
      }
    });
    Future.delayed(Duration.zero, () {
      addTransactions();
    });
  }

  void addTransactions() {
    final paymentModel =
        Provider.of<TransactionHistoryModel>(context, listen: false);

    isLoading = true;

    paymentModel.transactionHistory("${currentPage + 1}", "").then(
        (paymentData) {
      if (paymentData != null) {
        setState(() {
          currentPage = int.parse(paymentData.data.pagination.currentPage);
          maxPages = paymentData.data.pagination.totalPage;
          data.addAll(paymentData.data.transaction);
        });
      }
      isLoading = false;
    }, onError: (error) {
      // setState(() {
      //   isError = true;
      // });
    });
  }

  List<Transaction> data = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          // Padding(
          //     padding: EdgeInsets.only(left: 12, right: 12, top: 12),
          //     child: Row(
          //       children: [
          //         Text(
          //           "Search :",
          //           style: TextStyle(fontFamily: AppConstant.fontRegular),
          //         ),
          //         SizedBox(
          //           width: 12,
          //         ),
          //         // Container(
          //         //   width: MediaQuery.of(context).size.width * 0.75,
          //         //   decoration: BoxDecoration(
          //         //     border: Border.all(width: 1.0, color: Colors.black),
          //         //     shape: BoxShape.rectangle,
          //         //     borderRadius: BorderRadius.circular(6),
          //         //   ),
          //         //   height: 40,
          //         //   child: TextField(
          //         //     controller: searchController,
          //         //     cursorColor: Colors.black,
          //         //     onTap: () {
          //         //       showSearch(
          //         //         context: context,
          //         //         delegate: SearchData(),
          //         //       );
          //         //     },
          //         //   ),
          //         // ),
          //       ],
          //     )),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: ListView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.only(bottom: 104),
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: data.length + (currentPage < maxPages ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < data.length) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 110,
                                    //color: Colors.red,
                                    child: Text(
                                      "${data[index].customerName.toString()}",
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: AppConstant.fontRegular),
                                    ),
                                  ),
                                  Text(
                                    AppConstant.rupee +
                                        data[index].amount.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: AppConstant.fontBold),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isViewLoading = true;
                                      });
                                      geteOrderDetails(
                                          context, orderId, orderItemId);
                                      showAlertDialog(
                                          context,
                                          data[index].orderId,
                                          data[index].orderItemsId);
                                    },
                                    child: Card(
                                      elevation: 10,
                                      shadowColor: AppConstant.appColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        //set border radius more than 50% of height and width to make circle
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 35,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          /*boxShadow: [
                                                                    BoxShadow(
                                                                //color: Colors.grey,//AppConstant.appColor,
                                                                      //color: Colors.black.withOpacity(0.5),
                                                                      offset: Offset(0.5, 1.0),
                                                                      //(x,y)
                                                                      blurRadius: 1.0,
                                                                    ),
                                                                  ],*/
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: AppConstant.appColor),
                                        ),
                                        child: Text(
                                          "VIEW",
                                          style: TextStyle(
                                              color: AppConstant.appColor,
                                              fontFamily:
                                                  AppConstant.fontRegular,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  /*ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isViewLoading = true;
                                      });
                                      geteOrderDetails(
                                          context, orderId, orderItemId);
                                      showAlertDialog(
                                          context,
                                          data[index].orderId,
                                          data[index].orderItemsId);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                    ),
                                    child: Text(
                                      "View",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: AppConstant.fontBold),
                                    ),
                                  ),*/
                                  /*SizedBox(
                                    width: 2,
                                  ),*/
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              data[index].paymentStatus ==
                                                      "Pending"
                                                  ? AppConstant.appColor
                                                      .withOpacity(0.9)
                                                  : Colors.green),
                                    ),
                                    child: Text(
                                      data[index].paymentStatus,
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontRegular,
                                          color: data[index].paymentStatus ==
                                                  "Pending"
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                  ),
                                  /* SizedBox(
                                    width: 12,
                                  ),*/
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${data[index].orderNumber}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: AppConstant.fontBold),
                                  ),
                                  Text(
                                    "${data[index].deliveredDateTime}",//orderDate
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: AppConstant.fontBold),
                                  ),
                                  Text(
                                    "${data[index].orderType}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: AppConstant.fontBold),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey.shade400,
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      })))
        ],
      ),
    );
  }

  showAlertDialog(
      BuildContext context, String orderId, String orderItemId) async {
    GetOrderDetailsData? orderDetails;
    orderDetails = await geteOrderDetails(context, orderId, orderItemId);
    orderDetails != null
        ? showDialog<void>(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return /*StatefulBuilder(builder: (context, setStat) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height /
                              (orderDetails!.itemsDetail!.length >= 3
                                  ? (orderDetails.itemsDetail!.length >= 4
                                  ? (orderDetails.itemsDetail!.length >= 5
                                  ? 1.2
                                  : 1.3)
                                  : 1.5)
                                  : (orderDetails.itemsDetail!.length == 2
                                  ? 1.6
                                  : 1.8)),
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 20.0, right: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "Order Number:",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 14,
                                            fontFamily: AppConstant.fontRegular,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      "${orderDetails.orderNumber}",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                          fontFamily: AppConstant.fontRegular,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "Order Date:",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: AppConstant.fontRegular),
                                      ),
                                    ),
                                    Text(
                                      "${orderDetails.orderDate}",
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontRegular),
                                      maxLines: 1,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "Customer Name:",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: AppConstant.fontRegular),
                                      ),
                                    ),
                                    Text(
                                      "${orderDetails.customerName}",
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontRegular),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                  height: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(.25),
                                            blurRadius: 30),
                                      ],
                                      border: Border.all(
                                        color: Color.fromARGB(255, 208, 207, 206),
                                      ),
                                      color: Colors.white),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        itemCount:
                                        orderDetails.itemsDetail?.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  "${orderDetails!.itemsDetail?[index].quantity} x ${orderDetails.itemsDetail?[index].itemName}"),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      // Text("Special Instructions : ${data.orderItems}"),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                  height: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(.25),
                                            blurRadius: 30),
                                      ],
                                      border: Border.all(
                                        color: Color.fromARGB(255, 208, 207, 206),
                                      ),
                                      color: Colors.white),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Special Instructions : ${orderDetails.specialInstruction ?? "N/A"}"),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Discount : ${orderDetails.discount}",
                                          maxLines: 1,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Subscriptio : ${orderDetails.package}",
                                          maxLines: 1,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Packaging Charges : ${orderDetails.packagingCharge}",
                                          maxLines: 1,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Total : ${orderDetails.total}",
                                          maxLines: 1,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Visibility(
                                          visible:orderDetails.amount=="0.00" ?false:true,
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Total : ${orderDetails.total}",
                                                  maxLines: 1,
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      fontFamily: AppConstant.fontRegular,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                                Visibility(
                                                  visible: isShow?false:true,
                                                  child: SizedBox(
                                                    height: 10,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    isShow = !isShow;
                                                    setStat(() {});
                                                  },
                                                  child:Row(
                                                    children: [
                                                      Visibility(
                                                        visible: isShow==true?true:false,
                                                        child: Container(
                                                          //width: MediaQuery.of(context).size.width,
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 8, vertical: 8),
                                                          margin: const EdgeInsets.symmetric(
                                                              horizontal: 8, vertical: 8),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.grey,
                                                                  blurRadius: 6,
                                                                  offset: Offset(
                                                                      4, 4),
                                                                ),
                                                              ],
                                                              border: Border.all(
                                                                  color: Colors.red),
                                                              color: Colors.white),
                                                          child: Text(
                                                            "Reason: ${orderDetails. reason}",
                                                            maxLines: 1,
                                                            textAlign: TextAlign.end,
                                                            style: TextStyle( color: Colors.red,
                                                                fontFamily: AppConstant.fontRegular,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ),
                                                      SvgPicture.asset("assets/images/quatin_mark.svg"),
                                                      Text(
                                                        "  Addition : ${orderDetails.amount}",
                                                        maxLines: 1,
                                                        textAlign: TextAlign.end,
                                                        style: TextStyle(
                                                            fontFamily: AppConstant.fontRegular,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),),
                                                Visibility(
                                                  visible: isShow?false:true,
                                                  child: SizedBox(
                                                    height: 10,
                                                  ),
                                                ),
                                                Text(
                                                  "Net Amount : ${orderDetails.netAmount}",
                                                  maxLines: 1,
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      fontFamily: AppConstant.fontRegular,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },);*/StatefulBuilder(builder: (context, setStat) {
                return Scaffold(
                    body: Container(
                      padding:
                      const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.cancel))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Order Number:",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontFamily: AppConstant.fontRegular,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${orderDetails!.orderNumber}",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: AppConstant.fontRegular,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Order Date:",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: AppConstant.fontRegular),
                                  ),
                                ),
                                Text(
                                  "${orderDetails.orderDate}",
                                  style:
                                  TextStyle(fontFamily: AppConstant.fontRegular),
                                  maxLines: 1,
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Customer Name:",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: AppConstant.fontRegular),
                                  ),
                                ),
                                Text(
                                  "${orderDetails.customerName}",
                                  style:
                                  TextStyle(fontFamily: AppConstant.fontRegular),
                                  maxLines: 1,
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(.25),
                                        blurRadius: 30),
                                  ],
                                  border: Border.all(
                                    color: Color.fromARGB(255, 208, 207, 206),
                                  ),
                                  color: Colors.white),
                              child: Column(
                                children: [
                                  ListView.builder(
                                    itemCount: orderDetails.itemsDetail?.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${orderDetails!.itemsDetail?[index]?.quantity} x ${orderDetails.itemsDetail?[index].itemName}",
                                            style: TextStyle(
                                                fontFamily: AppConstant.fontRegular),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  // Text("Special Instructions : ${data.orderItems}"),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(.25),
                                        blurRadius: 30),
                                  ],
                                  border: Border.all(
                                    color: Color.fromARGB(255, 208, 207, 206),
                                  ),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Special Instructions : ${orderDetails.specialInstruction ?? "N/A"}",
                                    style: TextStyle(
                                        fontFamily: AppConstant.fontRegular),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Discount : ${orderDetails.discount}",
                                      maxLines: 1,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontRegular,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Subscription : ${orderDetails.package}",
                                      maxLines: 1,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontBold,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Packing Charges : ${orderDetails.packagingCharge}",
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontBold,
                                          fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Total : ${orderDetails.total}",
                                      maxLines: 1,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontRegular,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                     Visibility(
                                              visible: isShow?false:true,
                                              child: SizedBox(
                                                height: 10,
                                              ),
                                            ),
                                    Visibility(
                                      visible:orderDetails.amount=="0.00" ?false:true,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [

                                            InkWell(
                                              onTap: (){
                                                isShow = !isShow;
                                                setStat(() {});
                                              },
                                              child:Row(
                                                children: [
                                                  Visibility(
                                                    visible: isShow==true?true:false,
                                                    child: Container(
                                                      width: 180,
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 8, vertical: 8),
                                                      margin: const EdgeInsets.symmetric(
                                                          horizontal: 8, vertical: 8),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey,
                                                              blurRadius: 6,
                                                              offset: Offset(
                                                                  4, 4),
                                                            ),
                                                          ],
                                                          border: Border.all(
                                                              color: Colors.red),
                                                          color: Colors.white),
                                                      child: Text(
                                                        "Reason: ${orderDetails. reason}",
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle( color: Colors.red,
                                                            fontFamily: AppConstant.fontRegular,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ),
                                                  SvgPicture.asset("assets/images/quatin_mark.svg"),
                                                  Text(
                                                    " ${orderDetails.category} : ${orderDetails.amount}",/*Addition*/
                                                    maxLines: 1,
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        fontFamily: AppConstant.fontRegular,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),),
                                            Visibility(
                                              visible: isShow?false:true,
                                              child: SizedBox(
                                                height: 10,
                                              ),
                                            ),
                                            Text(
                                              "Net Amount : ${orderDetails.netAmount}",
                                              maxLines: 1,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontFamily: AppConstant.fontRegular,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                          ],
                        ),
                      ),
                    ));
              },);
            },
          )
        : Container();
  }

  Future<GetOrderDetailsData?> geteOrderDetails(
      BuildContext context, String orderId, String orderItemId) async {
    try {
      var userBean = await Utils.getUser();
      FormData from = FormData.fromMap({
        "kitchen_id": userBean.data!.id,
        "token": "123456789",
        "order_id": orderId,
        "order_item_id": orderItemId,
      });

      GetOrderDetailsData? bean = await ApiProvider()
          .getOrderDetails(orderId: orderId, orderItemId: orderItemId);

      setState(() {
        orderData = bean;
        isViewLoading = false;
      });
      return bean;
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {}
    return null;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class SearchData extends SearchDelegate {
  BankAccountsModel? bankAccounts;

  BeanLogin? userBean;

  List<Pagination> paginationData = [];
  int currentPage = 1;
  int maxPages = 1;
  var descriptionController = TextEditingController();
  var searchController = TextEditingController();
  GetOrderDetailsData? orderData;
  var currentBalance = '';
  var orderId = '';
  var orderItemId = '';
  bool isLoading = true;
  bool isViewLoading = false;
  int paymentIndex = 0;
  int page = 1;
  Future? future;
  final scrollController = ScrollController();

  @override
  List<Widget>? buildActions(BuildContext context) {
    query;
    return null;
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(),
          ),
        );
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  void initState(BuildContext context) {
    final paymentModel =
        Provider.of<TransactionHistoryModel>(context, listen: false);
    scrollController.addListener(() async {
      int positionPercent = (scrollController.position.pixels *
              100 /
              scrollController.position.maxScrollExtent)
          .round();
      positionPercent = positionPercent;
      if (currentPage < maxPages && !isLoading && positionPercent == 100) {
        // isLoading = true;
        await paymentModel.transactionHistory("${currentPage + 1}", "");
      } else {
        // scrollController = null;
      }
    });
    Future.delayed(Duration.zero, () {
      maxPages = paymentModel.payment!.data.pagination.totalPage;
      future = paymentModel.transactionHistory(
          "${currentPage < maxPages ? currentPage : currentPage + 1}", query);
    });

    // super.initState();
    // Future.delayed(Duration.zero, () {
    //   //geteOrderDetails(context, orderId, orderItemId);
    // });
  }

  @override
  Widget buildResults(BuildContext context) {
    final paymentModel =
        Provider.of<TransactionHistoryModel>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<GetPayment?>(
              future: paymentModel.transactionHistory(
                  "${currentPage < maxPages ? currentPage : currentPage + 1}",
                  query),
              builder: (BuildContext context, snapshot) {
                return snapshot.connectionState == ConnectionState.done &&
                        snapshot.data != null
                    ? ListView.builder(
                        padding: EdgeInsets.only(bottom: 100),
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: currentPage <
                                snapshot.data!.data.pagination.totalPage
                            ? snapshot.data!.data.transaction.length
                            : snapshot.data!.data.transaction.length + 1,
                        itemBuilder: (context, index) {
                          if (index < snapshot.data!.data.transaction.length) {
                            return Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          snapshot.data!.data.transaction[index]
                                              .customerName
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily:
                                                  AppConstant.fontRegular),
                                        ),
                                        Text(
                                          AppConstant.rupee +
                                              snapshot.data!.data
                                                  .transaction[index].amount
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: AppConstant.fontBold),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            isViewLoading = true;

                                            geteOrderDetails(
                                                context, orderId, orderItemId);
                                            showAlertDialog(
                                                context,
                                                snapshot.data!.data
                                                    .transaction[index].orderId,
                                                snapshot
                                                    .data!
                                                    .data
                                                    .transaction[index]
                                                    .orderItemsId);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                          ),
                                          child: Text(
                                            "View",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    AppConstant.fontBold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    snapshot
                                                                .data!
                                                                .data
                                                                .transaction[
                                                                    index]
                                                                .paymentStatus ==
                                                            "Pending"
                                                        ? AppConstant.appColor
                                                            .withOpacity(0.9)
                                                        : Colors.green),
                                          ),
                                          child: Text(
                                            snapshot
                                                .data!
                                                .data
                                                .transaction[index]
                                                .paymentStatus,
                                            style: TextStyle(
                                                fontFamily:
                                                    AppConstant.fontRegular,
                                                color: snapshot
                                                            .data!
                                                            .data
                                                            .transaction[index]
                                                            .paymentStatus ==
                                                        "Pending"
                                                    ? Colors.black
                                                    : Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "${snapshot.data!.data.transaction[index].orderNumber}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: AppConstant.fontBold),
                                        ),
                                        Text(
                                          "${snapshot.data!.data.transaction[index].orderDate}",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: AppConstant.fontBold),
                                        ),
                                        Text(
                                          "${snapshot.data!.data.transaction[index].orderType}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: AppConstant.fontBold),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.grey.shade400,
                                    ),
                                  ],
                                )

                                // (index + 1 == data.length)
                                //     ? AppConstant().navBarHt()
                                //
                                //
                                //   : Container()
                              ],
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        })
                    : Center(
                        child: Text(
                        "LOADING",
                        style: TextStyle(fontFamily: AppConstant.fontBold),
                      ));
              }),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text("Search for Transactions"),
    );
  }

  showAlertDialog(
      BuildContext context, String orderId, String orderItemId) async {
    GetOrderDetailsData? orderDetails;
    orderDetails = await geteOrderDetails(context, orderId, orderItemId);
    orderDetails != null
        ? showDialog<void>(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height /
                            (orderDetails!.itemsDetail!.length >= 3
                                ? (orderDetails.itemsDetail!.length >= 4
                                    ? (orderDetails.itemsDetail!.length >= 5
                                        ? 1.2
                                        : 1.3)
                                    : 1.5)
                                : (orderDetails.itemsDetail!.length == 2
                                    ? 1.6
                                    : 1.8)),
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 20.0, right: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Order Number:",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    "${orderDetails.orderNumber}",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10,
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Order Date:",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  Text(
                                    "${orderDetails.orderDate}",
                                    maxLines: 1,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10,
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Customer Name:",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  Text(
                                    "${orderDetails.customerName}",
                                    maxLines: 1,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10,
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(.25),
                                          blurRadius: 30),
                                    ],
                                    border: Border.all(
                                      color: Color.fromARGB(255, 208, 207, 206),
                                    ),
                                    color: Colors.white),
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      itemCount:
                                          orderDetails.itemsDetail?.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                "${orderDetails!.itemsDetail?[index].quantity} x ${orderDetails.itemsDetail?[index].itemName}"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    // Text("Special Instructions : ${data.orderItems}"),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(.25),
                                          blurRadius: 30),
                                    ],
                                    border: Border.all(
                                      color: Color.fromARGB(255, 208, 207, 206),
                                    ),
                                    color: Colors.white),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Special Instructions : ${orderDetails.specialInstruction ?? "N/A"}"),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Discount : ${orderDetails.discount}",
                                        maxLines: 1,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Package : ${orderDetails.package}",
                                        maxLines: 1,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Total : ${orderDetails.total}",
                                        maxLines: 1,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        : Container();
  }

  Future<GetOrderDetailsData?> geteOrderDetails(
      BuildContext context, String orderId, String orderItemId) async {
    try {
      var userBean = await Utils.getUser();
      FormData from = FormData.fromMap({
        "kitchen_id": userBean.data!.id,
        "token": "123456789",
        "order_id": orderId,
        "order_item_id": orderItemId,
      });

      GetOrderDetailsData? bean = await ApiProvider()
          .getOrderDetails(orderId: orderId, orderItemId: orderItemId);

      orderData = bean;
      isViewLoading = false;

      return bean;
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {}
    return null;
  }
}
