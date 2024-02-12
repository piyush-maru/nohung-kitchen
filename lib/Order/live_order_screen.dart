import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:kitchen/Order/OrderScreen.dart';
import 'package:kitchen/model/BeanGetOrderDetails.dart';
import 'package:kitchen/model/BeanOrderAccepted.dart';
import 'package:kitchen/model/BeanOrderRejected.dart';
import 'package:kitchen/model/KitchenData/BeanLogin.dart';
import 'package:kitchen/model/ReadyToPickupOrder.dart';
import 'package:kitchen/model/live_order_model.dart';
import 'package:kitchen/network/ApiProvider.dart';
import 'package:kitchen/res.dart';
import 'package:kitchen/src/presentation/screens/DashboardScreen.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:kitchen/utils/Utils.dart';
import 'package:kitchen/utils/constant/ui_constants.dart';
import 'package:provider/provider.dart';
import '../network/OrderRepo/live_order_model.dart';

class LiveOrders extends StatefulWidget {
  final bool? fromDashboard;

  const LiveOrders({
    Key? key,
    this.fromDashboard = false,
  }) : super(key: key);

  @override
  State<LiveOrders> createState() => _LiveOrdersState();
}

class _LiveOrdersState extends State<LiveOrders> {
  bool isChecked = false;
  var _isSounIndianMeal = false;
  bool isSwitched = false;
  bool isSlided = false;
  bool isShow=false;

  final Color customColor = Color.fromRGBO(255, 251, 214, 1.0);
  final Color customColor1 = Color.fromRGBO(228, 252, 255, 1);
  final Color customColor2 = Color.fromRGBO(219, 255, 227, 1);
  final Color customColor3 = Color.fromRGBO(255, 251, 214, 1);
  final Color textNumber = Color.fromRGBO(47, 52, 67, 0.5);
  final Color redButton = Color.fromRGBO(234, 0, 0, 0.7);
  final Color greenButton = Color.fromRGBO(2, 180, 24, 0.7);
  final Color switchColor = Color.fromRGBO(2, 180, 24, 1);


  static const Color bShade = Color(0xFFFFFBD9);
  static const Color lShade = Color(0xFFDBFFE3);
  static const Color dShade = Color(0xFFE4FCFF);
  List<Orders>? data = [];
  Future<LiveOrderModel1>? future;
  Timer? timer;
  List liveOrderData = [];
  String packageType = "all";
  var textValue = 'Switch is OFF';
  int sIndex = 0;
  var userId;
  List<String> mySlide = [
    "all",
    "breakfast",
    "lunch",
    "dinner",
    "preorder",
  ];
  List<Color> customColors = [
    Color.fromRGBO(250, 250, 250, 50),
    Color.fromRGBO(255, 251, 214, 1.0),
    Color.fromRGBO(228, 252, 255, 1),
    Color.fromRGBO(219, 255, 227, 1),
    Colors.white /*fromRGBO(255, 251, 214, 1)*/,
  ];
  static const Color bFade = Color(0xFFFFFDE5);
  static const Color lFade = Color(0xFFEEFDFF);//#eefdff//(#eafdff//0xFFEAFDFF)
  static const Color dFade = Color(0xFFEAFFEE);//#eaffee


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LiveOrderModel =
        Provider.of<LiveOrderController>(context, listen: false);
    return Scaffold(
      appBar: (widget.fromDashboard!)
          ? AppBar(
              backgroundColor: AppConstant.appColor,
              title: Text(
                "Order Requests",
                style: TextStyle(fontFamily: AppConstant.fontRegular),
              ),
            )
          : AppBar(
              toolbarHeight: 0.0,
              backgroundColor: Colors.white,
            ),
      backgroundColor: Colors.white,
      body: FutureBuilder<LiveOrderModel1>(
          future: LiveOrderModel.live(/*packageType*/),
          builder: (context, snapshot) {

 if(snapshot.hasError){
  return Text(snapshot.error.toString());
 }
          else{
   return Column(
     children: [
       Padding(
         padding: const EdgeInsets.only(
             top: 8, bottom: 8.0, right: 12.0, left: 12.0),
         child: Container(
           height: 52,
           // color: Colors.red,
           child: ListView.builder(
             scrollDirection: Axis.horizontal,
             itemCount: mySlide.length,
             itemBuilder: (context, index) {
               final text = mySlide![index];
               final capitalizedText = toBeginningOfSentenceCase(text);
               return sIndex == index
                   ? InkWell(
                 onTap: () {
                   setState(() {
                     sIndex = index;
                     packageType = mySlide[index];
                   });
                 },
                 child: Padding(
                   padding: const EdgeInsets.only(
                       left: 8.0,
                       top: 8.0,
                       bottom: 8.0,
                       right: 8.0),
                   child: Container(
                     alignment: Alignment.center,
                     height: 35,
                     decoration: BoxDecoration(
                       boxShadow: [
                         BoxShadow(
                           color: Colors.grey,
                           blurRadius: 3.0,
                           offset: Offset(0, 4),
                         )
                       ],
                       color: AppConstant.appColor,
                       borderRadius: BorderRadius.circular(6),
                     ),
                     child: Padding(
                       padding: const EdgeInsets.only(
                           left: 6.0, right: 6.0),
                       child: Row(
                         crossAxisAlignment:
                         CrossAxisAlignment.center,
                         mainAxisAlignment:
                         MainAxisAlignment.spaceBetween,
                         children: [
                           Text(
                             capitalizedText!,
                             style: TextStyle(
                                 decorationColor: Colors.blue,
                                 fontWeight: FontWeight.w400,
                                 color: Colors.white,
                                 fontSize: 15,
                                 fontFamily:
                                 AppConstant.fontRegular),
                           ),
                           SizedBox(width: 4),
                           Container(
                             height: 20,
                             width: 20,
                             decoration: BoxDecoration(
                               color: customColors[index],
                             ),
                           )
                         ],
                       ),
                     ),
                   ),
                 ),
               )
                   : InkWell(
                 onTap: () {
                   setState(() {
                     sIndex = index;
                     packageType = mySlide[index];
                     LiveOrderModel.live(/*packageType*/);
                   });
                 },
                 child: Padding(
                   padding: const EdgeInsets.only(
                       left: 6.0, right: 6.0),
                   child: Row(
                     crossAxisAlignment:
                     CrossAxisAlignment.center,
                     mainAxisAlignment:
                     MainAxisAlignment.spaceBetween,
                     children: [
                       Text(
                         capitalizedText!,
                         style: TextStyle(
                             decoration:
                             TextDecoration.underline,
                             decorationColor: Colors.blue,
                             fontWeight: FontWeight.w400,
                             color: Colors.blueAccent,
                             fontSize: 15,
                             fontFamily:
                             AppConstant.fontRegular),
                       ),
                       SizedBox(width: 4),
                       Container(
                         height: 20,
                         width: 20,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                                 blurRadius: 8,
                                 color:
                                 Colors.grey /*.shade300*/)
                           ],
                           color: customColors[index],
                         ),
                       )
                     ],
                   ),
                 ),
               );
             },
           ),
         ),
       ),
       snapshot.hasData
           ? Expanded(
         child:
         sIndex==0?
         snapshot.data?.data?.orders!.length != 0 ||  snapshot.data?.data?.breakfastOrders!.length != 0 || snapshot.data?.data?.lunchOrders!.length != 0 || snapshot.data?.data?.dinnerOrders!.length != 0
             ?SingleChildScrollView(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               snapshot.data?.data?.breakfastOrders!.length==0?SizedBox():  Padding(
                 padding: const EdgeInsets.only(bottom: 6.0,right: 12,left: 12),
                 child: Row(
                   mainAxisAlignment:snapshot.data?.data?.breakfastOrders!.length==0? MainAxisAlignment.end:MainAxisAlignment.spaceBetween,
                   //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     poppinsText(
                           maxLines: 1,
                           txt: "Breakfast(${snapshot.data?.data?.breakfastOrders!.length})",
                           fontSize: 16,
                           color: Color.fromRGBO(0, 0, 0, 1),
                           textAlign:
                           TextAlign
                               .center,
                           weight:
                           FontWeight
                               .w600),
                      poppinsText(
                          maxLines: 1,
                          txt: snapshot.data?.data?.currentDate!,
                          fontSize: 16,
                          color: Color.fromRGBO(0, 0, 0, 1),
                          textAlign:
                          TextAlign
                              .center,
                          weight:
                          FontWeight
                              .w600),
                   ],
                 ),
               ),
               ListView.builder(
                 itemCount: snapshot.data?.data?.breakfastOrders!.length,
                 physics: NeverScrollableScrollPhysics(),
                 shrinkWrap: true,
                 itemBuilder: (context, index) {
                   return /*(snapshot.data?.data?.breakfastOrders![index].orderType == "trial" && snapshot.data?.data?.breakfastOrders![index].status == "9") || (snapshot.data?.data?.breakfastOrders![index].orderType == "trial" && snapshot.data?.data?.breakfastOrders![index].status == "2") ||*/
                       (snapshot.data?.data?.breakfastOrders![index].orderType == "package" && snapshot.data?.data?.breakfastOrders![index].itemStatus == "7") || (snapshot.data?.data?.breakfastOrders![index].orderType == "package" && snapshot.data?.data?.breakfastOrders![index].status == "2"/*snapshot.data?.data?.breakfastOrders![index].itemStatus == "10"*/)
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ],
                           //color: bShade.withOpacity(0.85),
                           color: bFade,
                          /* color:
                           snapshot.data?.data?.breakfastOrders![index].orderType == "trial"
                               ? Colors.white
                               :snapshot.data?.data?.breakfastOrders![index].mealFor == "Breakfast"
                               ? bShade//customColor3
                               : snapshot.data?.data?.breakfastOrders![index].mealFor == "Lunch"
                               ? lShade//customColor1
                               : snapshot.data?.data?.breakfastOrders![index].mealFor == "Dinner"
                               ? dShade//customColor2
                               : Colors.white,*/
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.breakfastOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.breakfastOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.breakfastOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.breakfastOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.breakfastOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.breakfastOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.breakfastOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               snapshot.data?.data?.breakfastOrders![index].specialInstruction==""?SizedBox():
                               Row(
                                 //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text(
                                     "Instruction : ",
                                     style: TextStyle(
                                         color: Colors.grey,
                                         fontSize: 13,
                                         fontWeight: FontWeight.bold),
                                   ),
                                   Container(
                                     //color: Colors.black,
                                     width: 230,
                                     child: Text(
                                       "${snapshot.data?.data?.breakfastOrders![index].specialInstruction}",
                                       maxLines: 2,
                                       style: TextStyle(
                                           color: Colors.red,
                                           fontSize: 13,
                                           fontWeight: FontWeight.bold),
                                     ),
                                   ),
                                 ],
                               ),SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {

                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: SvgPicture.asset("assets/images/rejected1.svg",height: 200,fit: BoxFit.cover,),//assets/images/cancelled1.svg
                       ),
                     ],
                   )
                       : snapshot.data?.data?.breakfastOrders![index].orderType == "package" && snapshot.data?.data?.breakfastOrders![index].itemStatus == "8"
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ],
                           color: bFade,
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.breakfastOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.breakfastOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.breakfastOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.breakfastOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.breakfastOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.breakfastOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.breakfastOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: SvgPicture.asset("assets/images/postponed1.svg",height: 200,fit: BoxFit.cover,),
                       ),
                     ],
                   )
                       : (snapshot.data?.data?.breakfastOrders![index].orderType == "trial" && snapshot.data?.data?.breakfastOrders![index].status == "7") || snapshot.data?.data?.breakfastOrders![index].orderType == "package" && snapshot.data?.data?.breakfastOrders![index].itemStatus == "4"
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ],
                           color: bFade,
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.breakfastOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.breakfastOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.breakfastOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.breakfastOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.breakfastOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.breakfastOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.breakfastOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: Image.asset(
                           "assets/images/cancelled.png",height: 200,fit: BoxFit.cover,
                         ),//SvgPicture.asset("assets/images/postponed1.svg",height: 200,fit: BoxFit.cover,),
                       ),
                     ],
                   )
                       :InkWell(
                         onTap: () {
                           showAlertDialog(
                               context,
                               "${snapshot.data?.data?.breakfastOrders![index].orderId!.toString()}",
                               "${snapshot.data?.data?.breakfastOrders![index].orderitemsId!.toString()}",
                               "${snapshot.data?.data?.breakfastOrders![index].orderNumber!.toString()}",
                               "${snapshot.data?.data?.breakfastOrders![index].pickupTime!.toString()}",
                               "${snapshot.data?.data?.breakfastOrders![index].orderNumber!.toString()}",
                               "${snapshot.data?.data?.breakfastOrders![index].orderTypes == "old" ? "old" : "new"}",
                               "${snapshot.data?.data?.breakfastOrders![index].orderType!}",
                               "${snapshot.data?.data?.breakfastOrders![index].deliveryDate!}",
                               "${snapshot.data?.data?.breakfastOrders![index].status!}",
                               "${snapshot.data?.data?.breakfastOrders![index].itemStatus!}",
                               true);
                         },
                         child: Container(
                     margin: EdgeInsets.only(
                           bottom: 14,
                           top: 4,
                           left: 12.0,
                           right: 12.0),
                     alignment: Alignment.center,
                     // height: 205,
                     width: double.infinity,
                     decoration: BoxDecoration(
                         boxShadow: [
                           BoxShadow(
                             color:
                             Colors.grey, // Shadow color
                             blurRadius:
                             8.0, // Spread of the shadow
                             offset: Offset(
                                 4, 4), // Offset of the shadow
                           ),
                         ],
                         color: snapshot.data?.data?.breakfastOrders![index].mealFor == "Breakfast"
                             ? customColor3
                             : snapshot.data?.data?.breakfastOrders![index].mealFor == "Lunch"
                             ? customColor1
                             : snapshot.data?.data?.breakfastOrders![index].mealFor == "Dinner"
                             ? customColor2
                             : Colors.white,
                         borderRadius:
                         BorderRadius.circular(6),
                     ),
                     child: Padding(
                         padding: const EdgeInsets.only(
                             left: 12.0, right: 12.0, top: 12),
                         child: Column(
                           crossAxisAlignment:
                           CrossAxisAlignment.start,
                           children: [
                             Row(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               mainAxisAlignment:
                               MainAxisAlignment.start,
                               children: [
                                 snapshot
                                     .data
                                     ?.data
                                     ?.breakfastOrders![index]
                                     .customerDetail!
                                     .customerImage ==
                                     ''
                                     ? Container(
                                   height: 50,
                                   width: 50,
                                   decoration:
                                   BoxDecoration(
                                       shape: BoxShape
                                           .circle,
                                       color: Colors
                                           .blue),
                                 )
                                     : Container(
                                   width: 50,
                                   height: 50,
                                   child: CircleAvatar(
                                     radius: 45,
                                     backgroundImage:
                                     NetworkImage(
                                       '${snapshot.data?.data?.breakfastOrders![index].customerDetail!.customerImage}',
                                     ),
                                   ),
                                 ),
                                 SizedBox(width: 10),
                                 Expanded(
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment
                                         .spaceBetween,
                                     crossAxisAlignment:
                                     CrossAxisAlignment
                                         .start,
                                     children: [
                                       Column(
                                           crossAxisAlignment:
                                           CrossAxisAlignment
                                               .start,
                                           mainAxisAlignment:
                                           MainAxisAlignment
                                               .center,
                                           children: [
                                             poppinsText(
                                                 maxLines: 1,
                                                 txt: snapshot
                                                     .data
                                                     ?.data
                                                     ?.breakfastOrders![
                                                 index]
                                                     .customerDetail!
                                                     .customerName,
                                                 fontSize: 14,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w600),
                                             poppinsText(
                                                 maxLines: 1,
                                                 txt: snapshot
                                                     .data
                                                     ?.data
                                                     ?.breakfastOrders![
                                                 index]
                                                     .orderNumber,
                                                 fontSize: 12,
                                                 color:
                                                 textNumber,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ]),
                                       poppinsText(
                                           txt: snapshot
                                               .data
                                               ?.data
                                               ?.breakfastOrders![index]
                                               .mealFor,
                                           maxLines: 1,
                                           fontSize: 14,
                                           color: Colors.red,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w600),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 14),
                             Row(
                               children: [
                                 SizedBox(width: 14),
                                 Container(
                                   height: 25,
                                   width: 25,
                                   decoration: BoxDecoration(
                                       image: DecorationImage(
                                           image: AssetImage(
                                               "assets/images/live_order.png")),
                                       shape: BoxShape.circle,
                                       color: Colors.blue),
                                 ),
                                 SizedBox(width: 8),
                                 Container(
                                   alignment:
                                   Alignment.centerLeft,
                                   //color: Colors.red,
                                   width:
                                   MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.72,
                                   child: poppinsText(
                                       maxLines: 5,
                                       txt: snapshot
                                           .data
                                           ?.data
                                           ?.breakfastOrders![index]
                                           .itemName,
                                       fontSize: 12,
                                       textAlign:
                                       TextAlign.start,
                                       weight:
                                       FontWeight.w600),
                                 ),
                               ],
                             ),
                             SizedBox(height: 10),
                             poppinsText(
                                 maxLines: 1,
                                 txt: "Pickup Time: ${snapshot.data?.data?.breakfastOrders![index].pickupTime.toString()}",
                                 fontSize: 14,
                                 color: Colors.red,
                                 textAlign: TextAlign.center,
                                 weight: FontWeight.w600),
                             SizedBox(height: 4),
                             snapshot.data?.data?.breakfastOrders![index].specialInstruction==""?SizedBox():
                             Row(
                               //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(
                                   "Instruction : ",
                                   style: TextStyle(
                                       color: Colors.grey,
                                       fontSize: 13,
                                       fontWeight: FontWeight.bold),
                                 ),
                                 Container(
                                   //color: Colors.black,
                                   width: 230,
                                   child: Text(
                                     "${snapshot.data?.data?.breakfastOrders![index].specialInstruction}",
                                     maxLines: 2,
                                     style: TextStyle(
                                         color: Colors.red,
                                         fontSize: 13,
                                         fontWeight: FontWeight.bold),
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 4),
                             Row(
                               mainAxisAlignment:
                               MainAxisAlignment.start,
                               children: [
                                 Visibility(
                                   visible: snapshot.data?.data?.breakfastOrders![index].orderType == "trial" && snapshot.data?.data?.breakfastOrders![index].status == "0"
                                       || snapshot.data?.data?.breakfastOrders![index].orderType == "package" && snapshot.data?.data?.breakfastOrders![index].itemStatus == "5"
                                       || snapshot.data?.data?.breakfastOrders![index].orderType == "package" && snapshot.data?.data?.breakfastOrders![index].status == "0"
                                       ? true
                                       : false,
                                   child: Row(
                                     children: [
                                       InkWell(
                                         onTap: () {
                                           rejectDialog(
                                               orderNumber:
                                               "${snapshot.data?.data?.breakfastOrders![index].orderNumber!.toString()}",
                                               orderID: snapshot
                                                   .data
                                                   ?.data
                                                   ?.breakfastOrders![
                                               index]
                                                   .orderTypes! ==
                                                   "old"
                                                   ? snapshot
                                                   .data
                                                   ?.data
                                                   ?.breakfastOrders![
                                               index]
                                                   .orderitemsId
                                                   : snapshot
                                                   .data
                                                   ?.data
                                                   ?.breakfastOrders![
                                               index]
                                                   .orderId,
                                               subscriptionType: snapshot
                                                   .data
                                                   ?.data
                                                   ?.breakfastOrders![
                                               index]
                                                   .orderTypes ==
                                                   'old'
                                                   ? 'old'
                                                   : 'new',
                                               isFromDetails:
                                               false);
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 70,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 blurRadius:
                                                 10.0,
                                                 offset:
                                                 Offset(
                                                     0, 4),
                                               ),
                                             ],
                                             color: redButton,
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "Reject",
                                                 fontSize: 14,
                                                 color: Colors.white,
                                                 textAlign: TextAlign.center,
                                                 weight: FontWeight.w400
                                             ),
                                           ),
                                         ),
                                       ),
                                       SizedBox(
                                         width: 16,
                                       ),
                                       InkWell(
                                         onTap: () {
                                           acceptDialog(
                                               orderNumber:
                                               "${snapshot.data?.data?.breakfastOrders![index].orderNumber!.toString()}",
                                               orderID: snapshot
                                                   .data
                                                   ?.data
                                                   ?.breakfastOrders![
                                               index]
                                                   .orderTypes! ==
                                                   "old"
                                                   ? snapshot
                                                   .data
                                                   ?.data
                                                   ?.breakfastOrders![
                                               index]
                                                   .orderitemsId
                                                   : snapshot
                                                   .data
                                                   ?.data
                                                   ?.breakfastOrders![
                                               index]
                                                   .orderId,
                                               subscriptionType: snapshot
                                                   .data
                                                   ?.data
                                                   ?.breakfastOrders![
                                               index]
                                                   .orderTypes ==
                                                   'old'
                                                   ? 'old'
                                                   : 'new',
                                               isFromDetails:
                                               false,
                                             instructions: snapshot.data?.data?.breakfastOrders![index].specialInstruction);
                                           print(
                                               "-------------------------------=>${snapshot.data?.data?.breakfastOrders![index].orderTypes}");
                                           print(
                                               "-------------------------------1=>${snapshot.data?.data?.breakfastOrders![index].orderType}");
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 80,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 // Shadow color
                                                 blurRadius:
                                                 10.0,
                                                 // Spread of the shadow
                                                 offset: Offset(
                                                     0,
                                                     4), // Offset of the shadow
                                               ),
                                             ],
                                             color:
                                             greenButton,
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "Accept",
                                                 fontSize: 14,
                                                 color: Colors
                                                     .white,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                                 Visibility(
                                   visible: snapshot.data?.data?.breakfastOrders![index].orderType == "trial" && snapshot.data?.data?.breakfastOrders![index].status == "1"
                                       || snapshot.data?.data?.breakfastOrders![index].orderType == "package" && snapshot.data?.data?.breakfastOrders![index].itemStatus == "6"
                                       ? true
                                       : false,
                                   child: Row(
                                     children: [
                                       poppinsText(
                                           maxLines: 2,
                                           txt:
                                           "Ready to Pick-up",
                                           fontSize: 13,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                       SizedBox(width: 4),
                                       Transform.scale(
                                           scale: 1.5,
                                           child: Switch(
                                             onChanged:
                                                 (value) {
                                               if (isSwitched ==
                                                   false) {
                                                 setState(() {
                                                   isSwitched =
                                                   true;
                                                   isSlided =
                                                   true;

                                                   statusChangeDilog(
                                                     "${snapshot.data?.data?.breakfastOrders![index].status.toString()}",
                                                     "${snapshot.data?.data?.breakfastOrders![index].orderitemsId == "" ? snapshot.data?.data?.breakfastOrders![index].orderId : snapshot.data?.data?.orders![index].orderitemsId.toString()}",
                                                   );
                                                   textValue =
                                                   'Switch Button is ON';
                                                   isSwitched =
                                                   false;
                                                 });
                                               } else {
                                                 setState(() {
                                                   textValue =
                                                   'Switch Button is OFF';
                                                 });
                                               }
                                             },
                                             value: isSwitched,
                                             activeColor:
                                             AppConstant
                                                 .appColor,
                                             activeTrackColor:
                                             AppConstant
                                                 .appColorLite,
                                             inactiveThumbColor:
                                             Colors
                                                 .white70,
                                             inactiveTrackColor:
                                             Colors.green,
                                           ))
                                     ],
                                   ),
                                 ),
                                 Visibility(
                                   visible: snapshot.data?.data?.breakfastOrders![index].orderType == "trial" && snapshot.data?.data?.breakfastOrders![index].status == "3"
                                       || snapshot.data?.data?.breakfastOrders![index].orderType == "package" && snapshot.data?.data?.breakfastOrders![index].itemStatus == "0"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 165,
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.black,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Row(
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .center,
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .center,
                                       children: [
                                         poppinsText(
                                             maxLines: 1,
                                             txt:
                                             "Ready to pickup",
                                             fontSize: 13,
                                             color:
                                             Colors.white,
                                             textAlign:
                                             TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w500),
                                         SizedBox(width: 2),
                                         Icon(Icons.check,
                                             color:
                                             Colors.white,
                                             size: 16,
                                             weight: 30,
                                             opticalSize: 20),
                                       ],
                                     ),
                                   ),
                                 ),
                                 Visibility(
                                   visible: (snapshot.data?.data?.breakfastOrders![index].orderType == "trial" && (snapshot.data?.data?.breakfastOrders![index].status == "9" || snapshot.data?.data?.breakfastOrders![index].status == "2")) ||
                                       snapshot.data?.data?.breakfastOrders![index].orderType == "package" &&snapshot.data?.data?.breakfastOrders![index].itemStatus == "7" ||snapshot.data?.data?.breakfastOrders![index].itemStatus == "10"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 100, //165
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.red,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Center(
                                       child: poppinsText(
                                           maxLines: 1,
                                           txt: "Rejected",
                                           fontSize: 13,
                                           color: Colors.white,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                     ),
                                   ),
                                 ),
                                 Visibility(
                                   visible: (snapshot.data?.data?.breakfastOrders![index].orderType == "trial" && (snapshot.data?.data?.breakfastOrders![index].status == "6" )) ||
                                       snapshot.data?.data?.breakfastOrders![index].orderType == "package" && snapshot.data?.data?.breakfastOrders![index].itemStatus == "3"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 100, //165
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.green,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Center(
                                       child: poppinsText(
                                           maxLines: 1,
                                           txt: "Delivered",
                                           fontSize: 13,
                                           color: Colors.white,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                     ),
                                   ),
                                 ),
                                 Expanded(
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment.end,
                                     mainAxisSize:
                                     MainAxisSize.max,
                                     children: [
                                       InkWell(
                                         onTap: () async{
                                           showAlertDialog(
                                               context,
                                               "${snapshot.data?.data?.breakfastOrders![index].orderId!.toString()}",
                                               "${snapshot.data?.data?.breakfastOrders![index].orderitemsId!.toString()}",
                                               "${snapshot.data?.data?.breakfastOrders![index].orderNumber!.toString()}",
                                               "${snapshot.data?.data?.breakfastOrders![index].pickupTime!.toString()}",
                                               "${snapshot.data?.data?.breakfastOrders![index].orderNumber!.toString()}",
                                               "${snapshot.data?.data?.breakfastOrders![index].orderTypes == "old" ? "old" : "new"}",
                                               "${snapshot.data?.data?.breakfastOrders![index].orderType!}",
                                               "${snapshot.data?.data?.breakfastOrders![index].deliveryDate!}",
                                               "${snapshot.data?.data?.breakfastOrders![index].status!}",
                                               "${snapshot.data?.data?.breakfastOrders![index].itemStatus!}",
                                               true);
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 100,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 // Shadow color
                                                 blurRadius:
                                                 3.0,
                                                 // Spread of the shadow
                                                 offset: Offset(
                                                     0,
                                                     4), // Offset of the shadow
                                               ),
                                             ],
                                             color:
                                             Colors.white,
                                             border: Border.all(
                                                 color: AppConstant
                                                     .appColor,
                                                 width: 1.5),
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "View order",
                                                 fontSize: 14,
                                                 color: AppConstant
                                                     .appColor,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 10),
                           ],
                         ),
                     ),
                   ),
                       );
                 },
               ),
               snapshot.data?.data?.breakfastOrders!.length==0?SizedBox(): Padding(
                 padding:
                 const EdgeInsets.symmetric(horizontal: 8.0),
                 child: Container(
                   width: double.infinity,
                   height: 3,
                   decoration: BoxDecoration(
                       color:
                       Color.fromRGBO(4, 69, 146, 1), //AppConstant.appColor,
                       borderRadius: BorderRadius.circular(4)),
                 ),
               ),
               snapshot.data?.data?.lunchOrders!.length==0?SizedBox():
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(bottom: 6.0,left: 12,top: 12),
                     child: poppinsText(
                         maxLines: 1,
                         txt: "Lunch(${snapshot.data?.data?.lunchOrders!.length})",
                         fontSize: 16,
                         color: Color.fromRGBO(0, 0, 0, 1),
                         textAlign:
                         TextAlign
                             .center,
                         weight:
                         FontWeight
                             .w600),

                   ),
                   snapshot.data?.data?.breakfastOrders!.length!=0?SizedBox(): Padding(
                     padding: const EdgeInsets.only(bottom: 6.0,right: 12,top: 12),
                     child: poppinsText(
                         maxLines: 1,
                         txt: snapshot.data?.data?.currentDate!,
                         fontSize: 16,
                         color: Color.fromRGBO(0, 0, 0, 1),
                         textAlign:
                         TextAlign
                             .center,
                         weight:
                         FontWeight
                             .w600),
                   ),
                 ],
               ),
               ListView.builder(
                 itemCount: snapshot.data?.data?.lunchOrders!.length,
                 physics: NeverScrollableScrollPhysics(),
                 shrinkWrap: true,
                 itemBuilder: (context, index) {
                   return (snapshot.data?.data?.lunchOrders![index].orderType == "trial" && snapshot.data?.data?.lunchOrders![index].status == "9") || (snapshot.data?.data?.lunchOrders![index].orderType == "trial" && snapshot.data?.data?.lunchOrders![index].status == "2") ||
                       (snapshot.data?.data?.lunchOrders![index].orderType == "package" && snapshot.data?.data?.lunchOrders![index].itemStatus == "7") || (snapshot.data?.data?.lunchOrders![index].orderType == "package" && snapshot.data?.data?.lunchOrders![index].itemStatus == "10")
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ],
                           color: lFade,//customColor1.withOpacity(0.85),
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.lunchOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.lunchOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.lunchOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.lunchOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.lunchOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.lunchOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.lunchOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: SvgPicture.asset("assets/images/rejected1.svg",height: 200,fit: BoxFit.cover,),
                       ),
                     ],
                   )
                       : snapshot.data?.data?.lunchOrders![index].orderType == "package" && snapshot.data?.data?.lunchOrders![index].itemStatus == "8"
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ],
                           color: lFade,
                          /* color:
                           snapshot.data?.data?.lunchOrders![index].orderType == "trial"
                               ? Colors.white
                               :snapshot.data?.data?.lunchOrders![index].mealFor == "Breakfast"
                               ? bShade//customColor3
                               : snapshot.data?.data?.lunchOrders![index].mealFor == "Lunch"
                               ? lShade//customColor1
                               : snapshot.data?.data?.lunchOrders![index].mealFor == "Dinner"
                               ? dShade//customColor2
                               : Colors.white,*/
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.lunchOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.lunchOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.lunchOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.lunchOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.lunchOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.lunchOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.lunchOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: SvgPicture.asset("assets/images/postponed1.svg",height: 200,fit: BoxFit.cover,),
                       ),
                     ],
                   )
                       : (snapshot.data?.data?.lunchOrders![index].orderType == "trial" && snapshot.data?.data?.lunchOrders![index].status == "7") || snapshot.data?.data?.lunchOrders![index].orderType == "package" && snapshot.data?.data?.lunchOrders![index].itemStatus == "4"
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ],
                           color: lFade,

                          // color: snapshot.data?.data?.lunchOrders![index].mealFor == "Breakfast"
                          //     ? customColor3
                          //     : snapshot.data?.data?.lunchOrders![index].mealFor == "Lunch"
                          //     ? customColor1
                          //     : snapshot.data?.data?.lunchOrders![index].mealFor == "Dinner"
                          //     ? customColor2
                          //     : Colors.white,
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.lunchOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.lunchOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.lunchOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.lunchOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.lunchOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.lunchOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.lunchOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: Image.asset(
                             "assets/images/cancelled.png",height: 200,fit: BoxFit.cover,
                         ),//SvgPicture.asset("assets/images/postponed1.svg",height: 200,fit: BoxFit.cover,),
                       ),
                     ],
                   )
                       :InkWell(
                     onTap: () {
                       showAlertDialog(
                           context,
                           "${snapshot.data?.data?.lunchOrders![index].orderId!.toString()}",
                           "${snapshot.data?.data?.lunchOrders![index].orderitemsId!.toString()}",
                           "${snapshot.data?.data?.lunchOrders![index].orderNumber!.toString()}",
                           "${snapshot.data?.data?.lunchOrders![index].pickupTime!.toString()}",
                           "${snapshot.data?.data?.lunchOrders![index].orderNumber!.toString()}",
                           "${snapshot.data?.data?.lunchOrders![index].orderTypes == "old" ? "old" : "new"}",
                           "${snapshot.data?.data?.lunchOrders![index].orderType!}",
                           "${snapshot.data?.data?.lunchOrders![index].deliveryDate!}",
                           "${snapshot.data?.data?.lunchOrders![index].status!}",
                           "${snapshot.data?.data?.lunchOrders![index].itemStatus!}",
                           true);
                     },
                         child: Container(
                     margin: EdgeInsets.only(
                           bottom: 14,
                           top: 4,
                           left: 12.0,
                           right: 12.0),
                     alignment: Alignment.center,
                     // height: 205,
                     width: double.infinity,
                     decoration: BoxDecoration(
                         boxShadow: [
                           BoxShadow(
                             color:
                             Colors.grey, // Shadow color
                             blurRadius:
                             8.0, // Spread of the shadow
                             offset: Offset(
                                 4, 4), // Offset of the shadow
                           ),
                         ],
                         color: customColor1,
                         borderRadius:
                         BorderRadius.circular(6),
                     ),
                     child: Padding(
                         padding: const EdgeInsets.only(
                             left: 12.0, right: 12.0, top: 12),
                         child: Column(
                           crossAxisAlignment:
                           CrossAxisAlignment.start,
                           children: [
                             Row(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               mainAxisAlignment:
                               MainAxisAlignment.start,
                               children: [
                                 snapshot
                                     .data
                                     ?.data
                                     ?.lunchOrders![index]
                                     .customerDetail!
                                     .customerImage ==
                                     ''
                                     ? Container(
                                   height: 50,
                                   width: 50,
                                   decoration:
                                   BoxDecoration(
                                       shape: BoxShape
                                           .circle,
                                       color: Colors
                                           .blue),
                                 )
                                     : Container(
                                   width: 50,
                                   height: 50,
                                   child: CircleAvatar(
                                     radius: 45,
                                     backgroundImage:
                                     NetworkImage(
                                       '${snapshot.data?.data?.lunchOrders![index].customerDetail!.customerImage}',
                                     ),
                                   ),
                                 ),
                                 SizedBox(width: 10),
                                 Expanded(
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment
                                         .spaceBetween,
                                     crossAxisAlignment:
                                     CrossAxisAlignment
                                         .start,
                                     children: [
                                       Column(
                                           crossAxisAlignment:
                                           CrossAxisAlignment
                                               .start,
                                           mainAxisAlignment:
                                           MainAxisAlignment
                                               .center,
                                           children: [
                                             poppinsText(
                                                 maxLines: 1,
                                                 txt: snapshot
                                                     .data
                                                     ?.data
                                                     ?.lunchOrders![
                                                 index]
                                                     .customerDetail!
                                                     .customerName,
                                                 fontSize: 14,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w600),
                                             poppinsText(
                                                 maxLines: 1,
                                                 txt: snapshot.data?.data?.lunchOrders![index].orderNumber,
                                                 fontSize: 12,
                                                 color:
                                                 textNumber,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ]),
                                       poppinsText(
                                           txt: snapshot
                                               .data
                                               ?.data
                                               ?.lunchOrders![index]
                                               .mealFor,
                                           maxLines: 1,
                                           fontSize: 14,
                                           color: Colors.red,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w600),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 14),
                             Row(
                               children: [
                                 SizedBox(width: 14),
                                 Container(
                                   height: 25,
                                   width: 25,
                                   decoration: BoxDecoration(
                                       image: DecorationImage(
                                           image: AssetImage(
                                               "assets/images/live_order.png")),
                                       shape: BoxShape.circle,
                                       color: Colors.blue),
                                 ),
                                 SizedBox(width: 8),
                                 Container(
                                   alignment:
                                   Alignment.centerLeft,
                                   //color: Colors.red,
                                   width:
                                   MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.72,
                                   child: poppinsText(
                                       maxLines: 5,
                                       txt: snapshot
                                           .data
                                           ?.data
                                           ?.lunchOrders![index]
                                           .itemName,
                                       fontSize: 12,
                                       textAlign:
                                       TextAlign.start,
                                       weight:
                                       FontWeight.w600),
                                 ),
                               ],
                             ),
                             SizedBox(height: 10),
                             poppinsText(
                                 maxLines: 1,
                                 txt: "Pickup Time: ${snapshot.data?.data?.lunchOrders![index].pickupTime.toString()}",
                                 fontSize: 14,
                                 color: Colors.red,
                                 textAlign: TextAlign.center,
                                 weight: FontWeight.w600),
                             SizedBox(height: 4),
                             snapshot.data?.data?.lunchOrders![index].specialInstruction==""?SizedBox():
                             Row(
                               //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(
                                   "Instruction : ",
                                   style: TextStyle(
                                       color: Colors.grey,
                                       fontSize: 13,
                                       fontWeight: FontWeight.bold),
                                 ),
                                 Container(
                                   //color: Colors.black,
                                   width: 230,
                                   child: Text(
                                     "${snapshot.data?.data?.lunchOrders![index].specialInstruction}",
                                     maxLines: 2,
                                     style: TextStyle(
                                         color: Colors.red,
                                         fontSize: 13,
                                         fontWeight: FontWeight.bold),
                                   ),
                                 ),
                               ],
                             ),SizedBox(height: 4),
                             SizedBox(height: 10),
                             Row(
                               mainAxisAlignment:
                               MainAxisAlignment.start,
                               children: [
                                 Visibility(
                                   visible: snapshot.data?.data?.lunchOrders![index].orderType == "trial" && snapshot.data?.data?.lunchOrders![index].status == "0"
                                       || snapshot.data?.data?.lunchOrders![index].orderType == "package" && snapshot.data?.data?.lunchOrders![index].itemStatus == "5"
                                       || snapshot.data?.data?.lunchOrders![index].orderType == "package" && snapshot.data?.data?.lunchOrders![index].status == "0"
                                       ? true
                                       : false,
                                   child: Row(
                                     children: [
                                       InkWell(
                                         onTap: () {
                                           rejectDialog(
                                               orderNumber:
                                               "${snapshot.data?.data?.lunchOrders![index].orderNumber!.toString()}",
                                               orderID: snapshot
                                                   .data
                                                   ?.data
                                                   ?.lunchOrders![
                                               index]
                                                   .orderTypes! ==
                                                   "old"
                                                   ? snapshot
                                                   .data
                                                   ?.data
                                                   ?.lunchOrders![
                                               index]
                                                   .orderitemsId
                                                   : snapshot
                                                   .data
                                                   ?.data
                                                   ?.lunchOrders![
                                               index]
                                                   .orderId,
                                               subscriptionType: snapshot
                                                   .data
                                                   ?.data
                                                   ?.lunchOrders![
                                               index]
                                                   .orderTypes ==
                                                   'old'
                                                   ? 'old'
                                                   : 'new',
                                               isFromDetails:
                                               false);
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 70,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 blurRadius:
                                                 10.0,
                                                 offset:
                                                 Offset(
                                                     0, 4),
                                               ),
                                             ],
                                             color: redButton,
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "Reject",
                                                 fontSize: 14,
                                                 color: Colors
                                                     .white,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                       SizedBox(
                                         width: 16,
                                       ),
                                       InkWell(
                                         onTap: () {
                                           acceptDialog(
                                               orderNumber:
                                               "${snapshot.data?.data?.lunchOrders![index].orderNumber!.toString()}",
                                               orderID: snapshot
                                                   .data
                                                   ?.data
                                                   ?.lunchOrders![
                                               index]
                                                   .orderTypes! ==
                                                   "old"
                                                   ? snapshot
                                                   .data
                                                   ?.data
                                                   ?.lunchOrders![
                                               index]
                                                   .orderitemsId
                                                   : snapshot
                                                   .data
                                                   ?.data
                                                   ?.lunchOrders![
                                               index]
                                                   .orderId,
                                               subscriptionType: snapshot
                                                   .data
                                                   ?.data
                                                   ?.lunchOrders![
                                               index]
                                                   .orderTypes ==
                                                   'old'
                                                   ? 'old'
                                                   : 'new',
                                               isFromDetails:
                                               false,
                                               instructions: snapshot.data?.data?.lunchOrders![index].specialInstruction);
                                           print(
                                               "-------------------------------=>${snapshot.data?.data?.lunchOrders![index].orderTypes}");
                                           print(
                                               "-------------------------------1=>${snapshot.data?.data?.lunchOrders![index].orderType}");
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 80,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 // Shadow color
                                                 blurRadius:
                                                 10.0,
                                                 // Spread of the shadow
                                                 offset: Offset(
                                                     0,
                                                     4), // Offset of the shadow
                                               ),
                                             ],
                                             color:
                                             greenButton,
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "Accept",
                                                 fontSize: 14,
                                                 color: Colors
                                                     .white,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                                 Visibility(
                                   visible: snapshot.data?.data?.lunchOrders![index].orderType == "trial" && snapshot.data?.data?.lunchOrders![index].status == "1"
                                       || snapshot.data?.data?.lunchOrders![index].orderType == "package" && snapshot.data?.data?.lunchOrders![index].itemStatus == "6"
                                       ? true
                                       : false,
                                   child: Row(
                                     children: [
                                       poppinsText(
                                           maxLines: 2,
                                           txt:
                                           "Ready to Pick-up",
                                           fontSize: 13,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                       SizedBox(width: 4),
                                       Transform.scale(
                                           scale: 1.5,
                                           child: Switch(
                                             onChanged:
                                                 (value) {
                                               if (isSwitched ==
                                                   false) {
                                                 setState(() {
                                                   isSwitched =
                                                   true;
                                                   isSlided =
                                                   true;

                                                   statusChangeDilog(
                                                     "${snapshot.data?.data?.lunchOrders![index].status.toString()}",
                                                     "${snapshot.data?.data?.lunchOrders![index].orderitemsId == "" ? snapshot.data?.data?.lunchOrders![index].orderId : snapshot.data?.data?.lunchOrders![index].orderitemsId.toString()}",
                                                   );
                                                   textValue =
                                                   'Switch Button is ON';
                                                   isSwitched =
                                                   false;
                                                 });
                                               } else {
                                                 setState(() {
                                                   textValue =
                                                   'Switch Button is OFF';
                                                 });
                                               }
                                             },
                                             value: isSwitched,
                                             activeColor:
                                             AppConstant
                                                 .appColor,
                                             activeTrackColor:
                                             AppConstant
                                                 .appColorLite,
                                             inactiveThumbColor:
                                             Colors
                                                 .white70,
                                             inactiveTrackColor:
                                             Colors.green,
                                           ))
                                     ],
                                   ),
                                 ),
                                 Visibility(
                                   visible: snapshot
                                       .data
                                       ?.data
                                       ?.lunchOrders![
                                   index]
                                       .orderType ==
                                       "trial" &&
                                       snapshot
                                           .data
                                           ?.data
                                           ?.lunchOrders![
                                       index]
                                           .status ==
                                           "3" ||
                                       snapshot
                                           .data
                                           ?.data
                                           ?.lunchOrders![
                                       index]
                                           .orderType ==
                                           "package" &&
                                           snapshot
                                               .data
                                               ?.data
                                               ?.lunchOrders![
                                           index]
                                               .itemStatus ==
                                               "0"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 165,
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.black,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Row(
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .center,
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .center,
                                       children: [
                                         poppinsText(
                                             maxLines: 1,
                                             txt:
                                             "Ready to pickup",
                                             fontSize: 13,
                                             color:
                                             Colors.white,
                                             textAlign:
                                             TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w500),
                                         SizedBox(width: 2),
                                         Icon(Icons.check,
                                             color:
                                             Colors.white,
                                             size: 16,
                                             weight: 30,
                                             opticalSize: 20),
                                       ],
                                     ),
                                   ),
                                 ),
                                 Visibility(
                                   visible: (snapshot.data?.data?.lunchOrders![index].orderType == "trial" && (snapshot.data?.data?.lunchOrders![index].status == "9" || snapshot.data?.data?.lunchOrders![index].status == "2")) ||
                                       snapshot.data?.data?.lunchOrders![index].orderType == "package" &&snapshot.data?.data?.lunchOrders![index].itemStatus == "7" ||snapshot.data?.data?.lunchOrders![index].itemStatus == "10"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 100, //165
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.red,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Center(
                                       child: poppinsText(
                                           maxLines: 1,
                                           txt: "Rejected",
                                           fontSize: 13,
                                           color: Colors.white,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                     ),
                                   ),
                                 ),
                                 Visibility(
                                   visible: (snapshot.data?.data?.lunchOrders![index].orderType == "trial" && (snapshot.data?.data?.lunchOrders![index].status == "6" )) ||
                                       snapshot.data?.data?.lunchOrders![index].orderType == "package" && snapshot.data?.data?.lunchOrders![index].itemStatus == "3"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 100, //165
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.green,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Center(
                                       child: poppinsText(
                                           maxLines: 1,
                                           txt: "Delivered",
                                           fontSize: 13,
                                           color: Colors.white,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                     ),
                                   ),
                                 ),
                                 Expanded(
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment.end,
                                     mainAxisSize:
                                     MainAxisSize.max,
                                     children: [
                                       InkWell(
                                         onTap: () async{
                                           showAlertDialog(
                                               context,
                                               "${snapshot.data?.data?.lunchOrders![index].orderId!.toString()}",
                                               "${snapshot.data?.data?.lunchOrders![index].orderitemsId!.toString()}",
                                               "${snapshot.data?.data?.lunchOrders![index].orderNumber!.toString()}",
                                               "${snapshot.data?.data?.lunchOrders![index].pickupTime!.toString()}",
                                               "${snapshot.data?.data?.lunchOrders![index].orderNumber!.toString()}",
                                               "${snapshot.data?.data?.lunchOrders![index].orderTypes == "old" ? "old" : "new"}",
                                               "${snapshot.data?.data?.lunchOrders![index].orderType!}",
                                               "${snapshot.data?.data?.lunchOrders![index].deliveryDate!}",
                                               "${snapshot.data?.data?.lunchOrders![index].status!}",
                                               "${snapshot.data?.data?.lunchOrders![index].itemStatus!}",
                                               true);
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 100,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 // Shadow color
                                                 blurRadius:
                                                 3.0,
                                                 // Spread of the shadow
                                                 offset: Offset(
                                                     0,
                                                     4), // Offset of the shadow
                                               ),
                                             ],
                                             color:
                                             Colors.white,
                                             border: Border.all(
                                                 color: AppConstant
                                                     .appColor,
                                                 width: 1.5),
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "View order",
                                                 fontSize: 14,
                                                 color: AppConstant
                                                     .appColor,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 10),
                           ],
                         ),
                     ),
                   ),
                       );
                 },
               ),
               snapshot.data?.data?.dinnerOrders!.length==0?SizedBox():
               Padding(
                 padding:
                 const EdgeInsets.symmetric(horizontal: 8.0),
                 child: Container(
                   width: double.infinity,
                   height: 3,
                   decoration: BoxDecoration(
                       color:
                       Color.fromRGBO(4, 69, 146, 1), //AppConstant.appColor,
                       borderRadius: BorderRadius.circular(4)),
                 ),
               ),
               snapshot.data?.data?.dinnerOrders!.length==0?SizedBox():
               Row(
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(bottom: 6.0,left: 12,top: 12),
                     child: poppinsText(
                         maxLines: 1,
                         txt: "Dinner(${snapshot.data?.data?.dinnerOrders!.length})",
                         fontSize: 16,
                         color: Color.fromRGBO(0, 0, 0, 1),
                         textAlign: TextAlign.center,
                         weight: FontWeight.w600
                     ),
                   ),
                   snapshot.data?.data?.breakfastOrders!.length!=0 || snapshot.data?.data?.lunchOrders!.length!=0?SizedBox(): Padding(
                     padding: const EdgeInsets.only(bottom: 6.0,right: 12,top: 12),
                     child: poppinsText(
                         maxLines: 1,
                         txt: snapshot.data?.data?.currentDate!,
                         fontSize: 16,
                         color: Color.fromRGBO(0, 0, 0, 1),
                         textAlign:
                         TextAlign
                             .center,
                         weight:
                         FontWeight
                             .w600),
                   ),
                 ],
               ),
               ListView.builder(
                 itemCount: snapshot.data?.data?.dinnerOrders!.length,
                 physics: NeverScrollableScrollPhysics(),
                 shrinkWrap: true,
                 itemBuilder: (context, index) {
                   return (snapshot.data?.data?.dinnerOrders![index].orderType == "trial" && snapshot.data?.data?.dinnerOrders![index].status == "9") || (snapshot.data?.data?.dinnerOrders![index].orderType == "trial" && snapshot.data?.data?.dinnerOrders![index].status == "2") ||
                       (snapshot.data?.data?.dinnerOrders![index].orderType == "package" && snapshot.data?.data?.dinnerOrders![index].itemStatus == "7") || (snapshot.data?.data?.dinnerOrders![index].orderType == "package" && snapshot.data?.data?.dinnerOrders![index].itemStatus == "10")
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ],
                           color: dFade,
                           /* color:
                           snapshot.data?.data?.dinnerOrders![index].orderType == "trial"
                               ? Colors.white
                               :snapshot.data?.data?.dinnerOrders![index].mealFor == "Breakfast"
                               ? bShade//customColor3
                               : snapshot.data?.data?.dinnerOrders![index].mealFor == "Lunch"
                               ? lShade//customColor1
                               : snapshot.data?.data?.dinnerOrders![index].mealFor == "Dinner"
                               ? dShade//customColor2
                               : Colors.white,*/
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.dinnerOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.dinnerOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.dinnerOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.dinnerOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.dinnerOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.dinnerOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.dinnerOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               snapshot.data?.data?.dinnerOrders![index].specialInstruction==""?SizedBox():
                               Row(
                                 //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text(
                                     "Instruction : ",
                                     style: TextStyle(
                                         color: Colors.grey,
                                         fontSize: 13,
                                         fontWeight: FontWeight.bold),
                                   ),
                                   Container(
                                     //color: Colors.black,
                                     width: 230,
                                     child: Text(
                                       "${snapshot.data?.data?.dinnerOrders![index].specialInstruction}",
                                       maxLines: 2,
                                       style: TextStyle(
                                           color: Colors.red,
                                           fontSize: 13,
                                           fontWeight: FontWeight.bold),
                                     ),
                                   ),
                                 ],
                               ),SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: SvgPicture.asset("assets/images/rejected1.svg",height: 200,fit: BoxFit.cover,),
                       ),
                     ],
                   )
                       : snapshot.data?.data?.dinnerOrders![index].orderType == "package" && snapshot.data?.data?.dinnerOrders![index].itemStatus == "8"
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ], color: dFade,
                           /* color: snapshot.data?.data?.dinnerOrders![index].mealFor == "Breakfast"
                               ? customColor3
                               : snapshot.data?.data?.dinnerOrders![index].mealFor == "Lunch"
                               ? customColor1
                               : snapshot.data?.data?.dinnerOrders![index].mealFor == "Dinner"
                               ? customColor2
                               : Colors.white,*/

                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.dinnerOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.dinnerOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.dinnerOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.dinnerOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.dinnerOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.dinnerOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.dinnerOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: SvgPicture.asset("assets/images/postponed1.svg",height: 200,fit: BoxFit.cover,),
                       ),
                     ],
                   )
                       :(snapshot.data?.data?.dinnerOrders![index].orderType == "trial" && snapshot.data?.data?.dinnerOrders![index].status == "7") || snapshot.data?.data?.dinnerOrders![index].orderType == "package" && snapshot.data?.data?.dinnerOrders![index].itemStatus == "4"
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ],color: dFade,
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.dinnerOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.dinnerOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.dinnerOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.dinnerOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.dinnerOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.dinnerOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.dinnerOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: Image.asset(
                           "assets/images/cancelled.png",height: 200,fit: BoxFit.cover,
                         ),//SvgPicture.asset("assets/images/postponed1.svg",height: 200,fit: BoxFit.cover,),
                       ),
                     ],
                   )
                       : InkWell(
                     onTap: () {
                       showAlertDialog(
                           context,
                           "${snapshot.data?.data?.dinnerOrders![index].orderId!.toString()}",
                           "${snapshot.data?.data?.dinnerOrders![index].orderitemsId!.toString()}",
                           "${snapshot.data?.data?.dinnerOrders![index].orderNumber!.toString()}",
                           "${snapshot.data?.data?.dinnerOrders![index].pickupTime!.toString()}",
                           "${snapshot.data?.data?.dinnerOrders![index].orderNumber!.toString()}",
                           "${snapshot.data?.data?.dinnerOrders![index].orderTypes == "old" ? "old" : "new"}",
                           "${snapshot.data?.data?.dinnerOrders![index].orderType!}",
                           "${snapshot.data?.data?.dinnerOrders![index].deliveryDate!}",
                           "${snapshot.data?.data?.dinnerOrders![index].status!}",
                           "${snapshot.data?.data?.dinnerOrders![index].itemStatus!}",
                           true);
                     },
                         child: Container(
                     margin: EdgeInsets.only(
                           bottom: 14,
                           top: 4,
                           left: 12.0,
                           right: 12.0),
                     alignment: Alignment.center,
                     width: double.infinity,
                     decoration: BoxDecoration(
                         boxShadow: [
                           BoxShadow(
                             color:
                             Colors.grey,
                             blurRadius:
                             8.0,
                             offset: Offset(
                                 4, 4), // Offset of the shadow
                           ),
                         ],
                         color: /*snapshot.data?.data?.dinnerOrders![index].mealFor == "Breakfast"
                             ? customColor3
                             : snapshot.data?.data?.dinnerOrders![index].mealFor == "Lunch"
                             ? customColor1
                             : snapshot.data?.data?.dinnerOrders![index].mealFor == "Dinner"
                             ?*/ customColor2,
                             //: Colors.white,
                         borderRadius:
                         BorderRadius.circular(6),
                     ),
                     child: Padding(
                         padding: const EdgeInsets.only(
                             left: 12.0, right: 12.0, top: 12),
                         child: Column(
                           crossAxisAlignment:
                           CrossAxisAlignment.start,
                           children: [
                             Row(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               mainAxisAlignment:
                               MainAxisAlignment.start,
                               children: [
                                 snapshot
                                     .data
                                     ?.data
                                     ?.dinnerOrders![index]
                                     .customerDetail!
                                     .customerImage ==
                                     ''
                                     ? Container(
                                   height: 50,
                                   width: 50,
                                   decoration:
                                   BoxDecoration(
                                       shape: BoxShape
                                           .circle,
                                       color: Colors
                                           .blue),
                                 )
                                     : Container(
                                   width: 50,
                                   height: 50,
                                   child: CircleAvatar(
                                     radius: 45,
                                     backgroundImage:
                                     NetworkImage(
                                       '${snapshot.data?.data?.dinnerOrders![index].customerDetail!.customerImage}',
                                     ),
                                   ),
                                 ),
                                 SizedBox(width: 10),
                                 Expanded(
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment
                                         .spaceBetween,
                                     crossAxisAlignment:
                                     CrossAxisAlignment
                                         .start,
                                     children: [
                                       Column(
                                           crossAxisAlignment:
                                           CrossAxisAlignment
                                               .start,
                                           mainAxisAlignment:
                                           MainAxisAlignment
                                               .center,
                                           children: [
                                             poppinsText(
                                                 maxLines: 1,
                                                 txt: snapshot
                                                     .data
                                                     ?.data
                                                     ?.dinnerOrders![
                                                 index]
                                                     .customerDetail!
                                                     .customerName,
                                                 fontSize: 14,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w600),
                                             poppinsText(
                                                 maxLines: 1,
                                                 txt: snapshot
                                                     .data
                                                     ?.data
                                                     ?.dinnerOrders![
                                                 index]
                                                     .orderNumber,
                                                 fontSize: 12,
                                                 color:
                                                 textNumber,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ]),
                                       poppinsText(
                                           txt: snapshot
                                               .data
                                               ?.data
                                               ?.dinnerOrders![index]
                                               .mealFor,
                                           maxLines: 1,
                                           fontSize: 14,
                                           color: Colors.red,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w600),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 14),
                             Row(
                               children: [
                                 SizedBox(width: 14),
                                 Container(
                                   height: 25,
                                   width: 25,
                                   decoration: BoxDecoration(
                                       image: DecorationImage(
                                           image: AssetImage(
                                               "assets/images/live_order.png")),
                                       shape: BoxShape.circle,
                                       color: Colors.blue),
                                 ),
                                 SizedBox(width: 8),
                                 Container(
                                   alignment:
                                   Alignment.centerLeft,
                                   //color: Colors.red,
                                   width:
                                   MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.72,
                                   child: poppinsText(
                                       maxLines: 5,
                                       txt: snapshot
                                           .data
                                           ?.data
                                           ?.dinnerOrders![index]
                                           .itemName,
                                       fontSize: 12,
                                       textAlign:
                                       TextAlign.start,
                                       weight:
                                       FontWeight.w600),
                                 ),
                               ],
                             ),
                             SizedBox(height: 10),
                             poppinsText(
                                 maxLines: 1,
                                 txt: "Pickup Time: ${snapshot.data?.data?.dinnerOrders![index].pickupTime.toString()}",
                                 fontSize: 14,
                                 color: Colors.red,
                                 textAlign: TextAlign.center,
                                 weight: FontWeight.w600),
                             SizedBox(height: 4),
                             snapshot.data?.data?.dinnerOrders![index].specialInstruction==""?SizedBox():
                             Row(
                               //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(
                                   "Instruction : ",
                                   style: TextStyle(
                                       color: Colors.grey,
                                       fontSize: 13,
                                       fontWeight: FontWeight.bold),
                                 ),
                                 Container(
                                   //color: Colors.black,
                                   width: 230,
                                   child: Text(
                                     "${snapshot.data?.data?.dinnerOrders![index].specialInstruction}",
                                     maxLines: 2,
                                     style: TextStyle(
                                         color: Colors.red,
                                         fontSize: 13,
                                         fontWeight: FontWeight.bold),
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 10),
                             Row(
                               mainAxisAlignment:
                               MainAxisAlignment.start,
                               children: [
                                 Visibility(
                                   visible: snapshot.data?.data?.dinnerOrders![index].orderType == "trial" && snapshot.data?.data?.dinnerOrders![index].status == "0"
                                       || snapshot.data?.data?.dinnerOrders![index].orderType == "package" && snapshot.data?.data?.dinnerOrders![index].itemStatus == "5"
                                       || snapshot.data?.data?.dinnerOrders![index].orderType == "package" && snapshot.data?.data?.dinnerOrders![index].status == "0"
                                       ? true
                                       : false,
                                   child: Row(
                                     children: [
                                       InkWell(
                                         onTap: () {
                                           rejectDialog(
                                               orderNumber:
                                               "${snapshot.data?.data?.dinnerOrders![index].orderNumber!.toString()}",
                                               orderID: snapshot
                                                   .data
                                                   ?.data
                                                   ?.dinnerOrders![
                                               index]
                                                   .orderTypes! ==
                                                   "old"
                                                   ? snapshot
                                                   .data
                                                   ?.data
                                                   ?.dinnerOrders![
                                               index]
                                                   .orderitemsId
                                                   : snapshot
                                                   .data
                                                   ?.data
                                                   ?.dinnerOrders![
                                               index]
                                                   .orderId,
                                               subscriptionType: snapshot
                                                   .data
                                                   ?.data
                                                   ?.dinnerOrders![
                                               index]
                                                   .orderTypes ==
                                                   'old'
                                                   ? 'old'
                                                   : 'new',
                                               isFromDetails:
                                               false);
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 70,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 blurRadius:
                                                 10.0,
                                                 offset:
                                                 Offset(
                                                     0, 4),
                                               ),
                                             ],
                                             color: redButton,
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "Reject",
                                                 fontSize: 14,
                                                 color: Colors
                                                     .white,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                       SizedBox(
                                         width: 16,
                                       ),
                                       InkWell(
                                         onTap: () {
                                           acceptDialog(
                                               orderNumber:
                                               "${snapshot.data?.data?.dinnerOrders![index].orderNumber!.toString()}",
                                               orderID: snapshot
                                                   .data
                                                   ?.data
                                                   ?.dinnerOrders![
                                               index]
                                                   .orderTypes! ==
                                                   "old"
                                                   ? snapshot
                                                   .data
                                                   ?.data
                                                   ?.dinnerOrders![
                                               index]
                                                   .orderitemsId
                                                   : snapshot
                                                   .data
                                                   ?.data
                                                   ?.dinnerOrders![
                                               index]
                                                   .orderId,
                                               subscriptionType: snapshot
                                                   .data
                                                   ?.data
                                                   ?.dinnerOrders![
                                               index]
                                                   .orderTypes ==
                                                   'old'
                                                   ? 'old'
                                                   : 'new',
                                               isFromDetails:
                                               false,
                                               instructions: snapshot.data?.data?.dinnerOrders![index].specialInstruction);
                                           print(
                                               "-------------------------------=>${snapshot.data?.data?.dinnerOrders![index].orderTypes}");
                                           print(
                                               "-------------------------------1=>${snapshot.data?.data?.dinnerOrders![index].orderType}");
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 80,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 // Shadow color
                                                 blurRadius:
                                                 10.0,
                                                 // Spread of the shadow
                                                 offset: Offset(
                                                     0,
                                                     4), // Offset of the shadow
                                               ),
                                             ],
                                             color:
                                             greenButton,
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "Accept",
                                                 fontSize: 14,
                                                 color: Colors
                                                     .white,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                                 Visibility(
                                   visible: snapshot.data?.data?.dinnerOrders![index].orderType == "trial" && snapshot.data?.data?.dinnerOrders![index].status == "1"
                                       || snapshot.data?.data?.dinnerOrders![index].orderType == "package" && snapshot.data?.data?.dinnerOrders![index].itemStatus == "6"
                                       ? true
                                       : false,
                                   child: Row(
                                     children: [
                                       poppinsText(
                                           maxLines: 2,
                                           txt:
                                           "Ready to Pick-up",
                                           fontSize: 13,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                       SizedBox(width: 4),
                                       Transform.scale(
                                           scale: 1.5,
                                           child: Switch(
                                             onChanged:
                                                 (value) {
                                               if (isSwitched ==
                                                   false) {
                                                 setState(() {
                                                   isSwitched =
                                                   true;
                                                   isSlided =
                                                   true;

                                                   statusChangeDilog(
                                                     "${snapshot.data?.data?.dinnerOrders![index].status.toString()}",
                                                     "${snapshot.data?.data?.dinnerOrders![index].orderitemsId == "" ? snapshot.data?.data?.dinnerOrders![index].orderId : snapshot.data?.data?.dinnerOrders![index].orderitemsId.toString()}",
                                                   );
                                                   textValue =
                                                   'Switch Button is ON';
                                                   isSwitched =
                                                   false;
                                                 });
                                               } else {
                                                 setState(() {
                                                   textValue =
                                                   'Switch Button is OFF';
                                                 });
                                               }
                                             },
                                             value: isSwitched,
                                             activeColor:
                                             AppConstant
                                                 .appColor,
                                             activeTrackColor:
                                             AppConstant
                                                 .appColorLite,
                                             inactiveThumbColor:
                                             Colors
                                                 .white70,
                                             inactiveTrackColor:
                                             Colors.green,
                                           ))
                                     ],
                                   ),
                                 ),
                                 Visibility(
                                   visible: snapshot
                                       .data
                                       ?.data
                                       ?.dinnerOrders![
                                   index]
                                       .orderType ==
                                       "trial" &&
                                       snapshot
                                           .data
                                           ?.data
                                           ?.dinnerOrders![
                                       index]
                                           .status ==
                                           "3" ||
                                       snapshot
                                           .data
                                           ?.data
                                           ?.dinnerOrders![
                                       index]
                                           .orderType ==
                                           "package" &&
                                           snapshot
                                               .data
                                               ?.data
                                               ?.dinnerOrders![
                                           index]
                                               .itemStatus ==
                                               "0"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 165,
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.black,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Row(
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .center,
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .center,
                                       children: [
                                         poppinsText(
                                             maxLines: 1,
                                             txt:
                                             "Ready to pickup",
                                             fontSize: 13,
                                             color:
                                             Colors.white,
                                             textAlign:
                                             TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w500),
                                         SizedBox(width: 2),
                                         Icon(Icons.check,
                                             color:
                                             Colors.white,
                                             size: 16,
                                             weight: 30,
                                             opticalSize: 20),
                                       ],
                                     ),
                                   ),
                                 ),
                                 Visibility(
                                   visible: (snapshot.data?.data?.dinnerOrders![index].orderType == "trial" && (snapshot.data?.data?.dinnerOrders![index].status == "9" || snapshot.data?.data?.dinnerOrders![index].status == "2")) ||
                                       snapshot.data?.data?.dinnerOrders![index].orderType == "package" &&snapshot.data?.data?.dinnerOrders![index].itemStatus == "7" ||snapshot.data?.data?.dinnerOrders![index].itemStatus == "10"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 100, //165
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.red,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Center(
                                       child: poppinsText(
                                           maxLines: 1,
                                           txt: "Rejected",
                                           fontSize: 13,
                                           color: Colors.white,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                     ),
                                   ),
                                 ),
                                 Visibility(
                                   visible: (snapshot.data?.data?.dinnerOrders![index].orderType == "trial" && (snapshot.data?.data?.dinnerOrders![index].status == "6" )) ||
                                       snapshot.data?.data?.dinnerOrders![index].orderType == "package" && snapshot.data?.data?.dinnerOrders![index].itemStatus == "3"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 100, //165
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.green,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Center(
                                       child: poppinsText(
                                           maxLines: 1,
                                           txt: "Delivered",
                                           fontSize: 13,
                                           color: Colors.white,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                     ),
                                   ),
                                 ),
                                 Expanded(
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment.end,
                                     mainAxisSize:
                                     MainAxisSize.max,
                                     children: [
                                       InkWell(
                                         onTap: () async{
                                           showAlertDialog(
                                               context,
                                               "${snapshot.data?.data?.dinnerOrders![index].orderId!.toString()}",
                                               "${snapshot.data?.data?.dinnerOrders![index].orderitemsId!.toString()}",
                                               "${snapshot.data?.data?.dinnerOrders![index].orderNumber!.toString()}",
                                               "${snapshot.data?.data?.dinnerOrders![index].pickupTime!.toString()}",
                                               "${snapshot.data?.data?.dinnerOrders![index].orderNumber!.toString()}",
                                               "${snapshot.data?.data?.dinnerOrders![index].orderTypes == "old" ? "old" : "new"}",
                                               "${snapshot.data?.data?.dinnerOrders![index].orderType!}",
                                               "${snapshot.data?.data?.dinnerOrders![index].deliveryDate!}",
                                               "${snapshot.data?.data?.dinnerOrders![index].status!}",
                                               "${snapshot.data?.data?.dinnerOrders![index].itemStatus!}",
                                               true);
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 100,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 // Shadow color
                                                 blurRadius:
                                                 3.0,
                                                 // Spread of the shadow
                                                 offset: Offset(
                                                     0,
                                                     4), // Offset of the shadow
                                               ),
                                             ],
                                             color:
                                             Colors.white,
                                             border: Border.all(
                                                 color: AppConstant
                                                     .appColor,
                                                 width: 1.5),
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "View order",
                                                 fontSize: 14,
                                                 color: AppConstant
                                                     .appColor,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 10),
                           ],
                         ),
                     ),
                   ),
                       );
                 },
               ),
               SizedBox(height: 60),
             ],
           ),
         )
             :Column(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             Padding(
               padding: const EdgeInsets.only(top: 100.0),
               child: SvgPicture.asset("assets/images/noLiveOrder.svg"),
             ),
             poppinsText(
                 maxLines: 5,
                 txt: "There are no Orders",
                 fontSize: 16,
                 textAlign:
                 TextAlign.start,
                 weight:
                 FontWeight.w600),
           ],
         )
             : sIndex==1?
         snapshot.data?.data?.breakfastOrders!.length != 0
             ?SingleChildScrollView(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               ListView.builder(
                 itemCount: snapshot.data?.data?.breakfastOrders!.length,
                 physics: NeverScrollableScrollPhysics(),
                 shrinkWrap: true,
                 itemBuilder: (context, index) {
                   return  (snapshot.data?.data?.breakfastOrders![index].orderType == "package" && snapshot.data?.data?.breakfastOrders![index].itemStatus == "7") || (snapshot.data?.data?.breakfastOrders![index].orderType == "package" && snapshot.data?.data?.breakfastOrders![index].status == "2"/*snapshot.data?.data?.breakfastOrders![index].itemStatus == "10"*/)
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ],
                           color:bFade,
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.breakfastOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.breakfastOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.breakfastOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.breakfastOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.breakfastOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.breakfastOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.breakfastOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: SvgPicture.asset("assets/images/rejected1.svg",height: 200,fit: BoxFit.cover,),//assets/images/cancelled1.svg
                       ),
                     ],
                   )
                       : snapshot.data?.data?.breakfastOrders![index].orderType == "package" && snapshot.data?.data?.breakfastOrders![index].itemStatus == "8"
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ],
                           color: bFade,
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.breakfastOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.breakfastOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.breakfastOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.breakfastOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.breakfastOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.breakfastOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.breakfastOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: SvgPicture.asset("assets/images/postponed1.svg",height: 200,fit: BoxFit.cover,),
                       ),
                     ],
                   )
                       : (snapshot.data?.data?.breakfastOrders![index].orderType == "trial" && snapshot.data?.data?.breakfastOrders![index].status == "7") || snapshot.data?.data?.breakfastOrders![index].orderType == "package" && snapshot.data?.data?.breakfastOrders![index].itemStatus == "4"
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ],
                           color: bFade,
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.breakfastOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.breakfastOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.breakfastOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.breakfastOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.breakfastOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.breakfastOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.breakfastOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: Image.asset(
                           "assets/images/cancelled.png",height: 200,fit: BoxFit.cover,
                         ),
                       ),
                     ],
                   )
                       :InkWell(
                     onTap: () {
                       showAlertDialog(
                           context,
                           "${snapshot.data?.data?.breakfastOrders![index].orderId!.toString()}",
                           "${snapshot.data?.data?.breakfastOrders![index].orderitemsId!.toString()}",
                           "${snapshot.data?.data?.breakfastOrders![index].orderNumber!.toString()}",
                           "${snapshot.data?.data?.breakfastOrders![index].pickupTime!.toString()}",
                           "${snapshot.data?.data?.breakfastOrders![index].orderNumber!.toString()}",
                           "${snapshot.data?.data?.breakfastOrders![index].orderTypes == "old" ? "old" : "new"}",
                           "${snapshot.data?.data?.breakfastOrders![index].orderType!}",
                           "${snapshot.data?.data?.breakfastOrders![index].deliveryDate!}",
                           "${snapshot.data?.data?.breakfastOrders![index].status!}",
                           "${snapshot.data?.data?.breakfastOrders![index].itemStatus!}",
                           true);
                     },
                         child: Container(
                     margin: EdgeInsets.only(
                           bottom: 14,
                           top: 4,
                           left: 12.0,
                           right: 12.0),
                     alignment: Alignment.center,
                     // height: 205,
                     width: double.infinity,
                     decoration: BoxDecoration(
                         boxShadow: [
                           BoxShadow(
                             color:
                             Colors.grey,
                             blurRadius:
                             8.0,
                             offset: Offset(
                                 4, 4),
                           ),
                         ],
                         color:  customColor3,
                         borderRadius:
                         BorderRadius.circular(6),
                     ),
                     child: Padding(
                         padding: const EdgeInsets.only(
                             left: 12.0, right: 12.0, top: 12),
                         child: Column(
                           crossAxisAlignment:
                           CrossAxisAlignment.start,
                           children: [
                             Row(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               mainAxisAlignment:
                               MainAxisAlignment.start,
                               children: [
                                 snapshot
                                     .data
                                     ?.data
                                     ?.breakfastOrders![index]
                                     .customerDetail!
                                     .customerImage ==
                                     ''
                                     ? Container(
                                   height: 50,
                                   width: 50,
                                   decoration:
                                   BoxDecoration(
                                       shape: BoxShape
                                           .circle,
                                       color: Colors
                                           .blue),
                                 )
                                     : Container(
                                   width: 50,
                                   height: 50,
                                   child: CircleAvatar(
                                     radius: 45,
                                     backgroundImage:
                                     NetworkImage(
                                       '${snapshot.data?.data?.breakfastOrders![index].customerDetail!.customerImage}',
                                     ),
                                   ),
                                 ),
                                 SizedBox(width: 10),
                                 Expanded(
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment
                                         .spaceBetween,
                                     crossAxisAlignment:
                                     CrossAxisAlignment
                                         .start,
                                     children: [
                                       Column(
                                           crossAxisAlignment:
                                           CrossAxisAlignment
                                               .start,
                                           mainAxisAlignment:
                                           MainAxisAlignment
                                               .center,
                                           children: [
                                             poppinsText(
                                                 maxLines: 1,
                                                 txt: snapshot
                                                     .data
                                                     ?.data
                                                     ?.breakfastOrders![
                                                 index]
                                                     .customerDetail!
                                                     .customerName,
                                                 fontSize: 14,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w600),
                                             poppinsText(
                                                 maxLines: 1,
                                                 txt: snapshot
                                                     .data
                                                     ?.data
                                                     ?.breakfastOrders![
                                                 index]
                                                     .orderNumber,
                                                 fontSize: 12,
                                                 color:
                                                 textNumber,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ]),
                                       poppinsText(
                                           txt: snapshot
                                               .data
                                               ?.data
                                               ?.breakfastOrders![index]
                                               .mealFor,
                                           maxLines: 1,
                                           fontSize: 14,
                                           color: Colors.red,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w600),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 14),
                             Row(
                               children: [
                                 SizedBox(width: 14),
                                 Container(
                                   height: 25,
                                   width: 25,
                                   decoration: BoxDecoration(
                                       image: DecorationImage(
                                           image: AssetImage(
                                               "assets/images/live_order.png")),
                                       shape: BoxShape.circle,
                                       color: Colors.blue),
                                 ),
                                 SizedBox(width: 8),
                                 Container(
                                   alignment:
                                   Alignment.centerLeft,
                                   //color: Colors.red,
                                   width:
                                   MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.72,
                                   child: poppinsText(
                                       maxLines: 5,
                                       txt: snapshot
                                           .data
                                           ?.data
                                           ?.breakfastOrders![index]
                                           .itemName,
                                       fontSize: 12,
                                       textAlign:
                                       TextAlign.start,
                                       weight:
                                       FontWeight.w600),
                                 ),
                               ],
                             ),
                             SizedBox(height: 10),
                             poppinsText(
                                 maxLines: 1,
                                 txt: "Pickup Time: ${snapshot.data?.data?.breakfastOrders![index].pickupTime.toString()}",
                                 fontSize: 14,
                                 color: Colors.red,
                                 textAlign: TextAlign.center,
                                 weight: FontWeight.w600),
                             SizedBox(height: 4),
                             Row(
                               mainAxisAlignment:
                               MainAxisAlignment.start,
                               children: [
                                 Visibility(
                                   visible: snapshot.data?.data?.breakfastOrders![index].orderType == "trial" && snapshot.data?.data?.breakfastOrders![index].status == "0"
                                       || snapshot.data?.data?.breakfastOrders![index].orderType == "package" && snapshot.data?.data?.breakfastOrders![index].itemStatus == "5"
                                       || snapshot.data?.data?.breakfastOrders![index].orderType == "package" && snapshot.data?.data?.breakfastOrders![index].status == "0"
                                       ? true
                                       : false,
                                   child: Row(
                                     children: [
                                       InkWell(
                                         onTap: () {
                                           rejectDialog(
                                               orderNumber:
                                               "${snapshot.data?.data?.breakfastOrders![index].orderNumber!.toString()}",
                                               orderID: snapshot
                                                   .data
                                                   ?.data
                                                   ?.breakfastOrders![
                                               index]
                                                   .orderTypes! ==
                                                   "old"
                                                   ? snapshot
                                                   .data
                                                   ?.data
                                                   ?.breakfastOrders![
                                               index]
                                                   .orderitemsId
                                                   : snapshot
                                                   .data
                                                   ?.data
                                                   ?.breakfastOrders![
                                               index]
                                                   .orderId,
                                               subscriptionType: snapshot
                                                   .data
                                                   ?.data
                                                   ?.breakfastOrders![
                                               index]
                                                   .orderTypes ==
                                                   'old'
                                                   ? 'old'
                                                   : 'new',
                                               isFromDetails:
                                               false);
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 70,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 blurRadius:
                                                 10.0,
                                                 offset:
                                                 Offset(
                                                     0, 4),
                                               ),
                                             ],
                                             color: redButton,
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "Reject",
                                                 fontSize: 14,
                                                 color: Colors
                                                     .white,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                       SizedBox(
                                         width: 16,
                                       ),
                                       InkWell(
                                         onTap: () {
                                           acceptDialog(
                                               orderNumber:
                                               "${snapshot.data?.data?.breakfastOrders![index].orderNumber!.toString()}",
                                               orderID: snapshot
                                                   .data
                                                   ?.data
                                                   ?.breakfastOrders![
                                               index]
                                                   .orderTypes! ==
                                                   "old"
                                                   ? snapshot
                                                   .data
                                                   ?.data
                                                   ?.breakfastOrders![
                                               index]
                                                   .orderitemsId
                                                   : snapshot
                                                   .data
                                                   ?.data
                                                   ?.breakfastOrders![
                                               index]
                                                   .orderId,
                                               subscriptionType: snapshot
                                                   .data
                                                   ?.data
                                                   ?.breakfastOrders![
                                               index]
                                                   .orderTypes ==
                                                   'old'
                                                   ? 'old'
                                                   : 'new',
                                               isFromDetails:
                                               false,
                                               instructions: snapshot.data?.data?.breakfastOrders![index].specialInstruction);
                                           print(
                                               "-------------------------------=>${snapshot.data?.data?.breakfastOrders![index].orderTypes}");
                                           print(
                                               "-------------------------------1=>${snapshot.data?.data?.breakfastOrders![index].orderType}");
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 80,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 // Shadow color
                                                 blurRadius:
                                                 10.0,
                                                 // Spread of the shadow
                                                 offset: Offset(
                                                     0,
                                                     4), // Offset of the shadow
                                               ),
                                             ],
                                             color:
                                             greenButton,
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "Accept",
                                                 fontSize: 14,
                                                 color: Colors
                                                     .white,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                                 Visibility(
                                   visible: snapshot.data?.data?.breakfastOrders![index].orderType == "trial" && snapshot.data?.data?.breakfastOrders![index].status == "1"
                                       || snapshot.data?.data?.breakfastOrders![index].orderType == "package" && snapshot.data?.data?.breakfastOrders![index].itemStatus == "6"
                                       ? true
                                       : false,
                                   child: Row(
                                     children: [
                                       poppinsText(
                                           maxLines: 2,
                                           txt:
                                           "Ready to Pick-up",
                                           fontSize: 13,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                       SizedBox(width: 4),
                                       Transform.scale(
                                           scale: 1.5,
                                           child: Switch(
                                             onChanged:
                                                 (value) {
                                               if (isSwitched ==
                                                   false) {
                                                 setState(() {
                                                   isSwitched =
                                                   true;
                                                   isSlided =
                                                   true;

                                                   statusChangeDilog(
                                                     "${snapshot.data?.data?.breakfastOrders![index].status.toString()}",
                                                     "${snapshot.data?.data?.breakfastOrders![index].orderitemsId == "" ? snapshot.data?.data?.breakfastOrders![index].orderId : snapshot.data?.data?.orders![index].orderitemsId.toString()}",
                                                   );
                                                   textValue =
                                                   'Switch Button is ON';
                                                   isSwitched =
                                                   false;
                                                 });
                                               } else {
                                                 setState(() {
                                                   textValue =
                                                   'Switch Button is OFF';
                                                 });
                                               }
                                             },
                                             value: isSwitched,
                                             activeColor:
                                             AppConstant
                                                 .appColor,
                                             activeTrackColor:
                                             AppConstant
                                                 .appColorLite,
                                             inactiveThumbColor:
                                             Colors
                                                 .white70,
                                             inactiveTrackColor:
                                             Colors.green,
                                           ))
                                     ],
                                   ),
                                 ),
                                 Visibility(
                                   visible: snapshot
                                       .data
                                       ?.data
                                       ?.breakfastOrders![
                                   index]
                                       .orderType ==
                                       "trial" &&
                                       snapshot
                                           .data
                                           ?.data
                                           ?.breakfastOrders![
                                       index]
                                           .status ==
                                           "3" ||
                                       snapshot
                                           .data
                                           ?.data
                                           ?.breakfastOrders![
                                       index]
                                           .orderType ==
                                           "package" &&
                                           snapshot
                                               .data
                                               ?.data
                                               ?.breakfastOrders![
                                           index]
                                               .itemStatus ==
                                               "0"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 165,
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.black,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Row(
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .center,
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .center,
                                       children: [
                                         poppinsText(
                                             maxLines: 1,
                                             txt:
                                             "Ready to pickup",
                                             fontSize: 13,
                                             color:
                                             Colors.white,
                                             textAlign:
                                             TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w500),
                                         SizedBox(width: 2),
                                         Icon(Icons.check,
                                             color:
                                             Colors.white,
                                             size: 16,
                                             weight: 30,
                                             opticalSize: 20),
                                       ],
                                     ),
                                   ),
                                 ),
                                 Visibility(
                                   visible: (snapshot.data?.data?.breakfastOrders![index].orderType == "trial" && (snapshot.data?.data?.breakfastOrders![index].status == "9" || snapshot.data?.data?.breakfastOrders![index].status == "2")) ||
                                       snapshot.data?.data?.breakfastOrders![index].orderType == "package" &&snapshot.data?.data?.breakfastOrders![index].itemStatus == "7" ||snapshot.data?.data?.breakfastOrders![index].itemStatus == "10"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 100, //165
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.red,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Center(
                                       child: poppinsText(
                                           maxLines: 1,
                                           txt: "Rejected",
                                           fontSize: 13,
                                           color: Colors.white,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                     ),
                                   ),
                                 ),
                                 Visibility(
                                   visible: (snapshot.data?.data?.breakfastOrders![index].orderType == "trial" && (snapshot.data?.data?.breakfastOrders![index].status == "6" )) ||
                                       snapshot.data?.data?.breakfastOrders![index].orderType == "package" && snapshot.data?.data?.breakfastOrders![index].itemStatus == "3"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 100, //165
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.green,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Center(
                                       child: poppinsText(
                                           maxLines: 1,
                                           txt: "Delivered",
                                           fontSize: 13,
                                           color: Colors.white,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                     ),
                                   ),
                                 ),
                                 Expanded(
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment.end,
                                     mainAxisSize:
                                     MainAxisSize.max,
                                     children: [
                                       InkWell(
                                         onTap: () async{
                                           showAlertDialog(
                                               context,
                                               "${snapshot.data?.data?.breakfastOrders![index].orderId!.toString()}",
                                               "${snapshot.data?.data?.breakfastOrders![index].orderitemsId!.toString()}",
                                               "${snapshot.data?.data?.breakfastOrders![index].orderNumber!.toString()}",
                                               "${snapshot.data?.data?.breakfastOrders![index].pickupTime!.toString()}",
                                               "${snapshot.data?.data?.breakfastOrders![index].orderNumber!.toString()}",
                                               "${snapshot.data?.data?.breakfastOrders![index].orderTypes == "old" ? "old" : "new"}",
                                               "${snapshot.data?.data?.breakfastOrders![index].orderType!}",
                                               "${snapshot.data?.data?.breakfastOrders![index].deliveryDate!}",
                                               "${snapshot.data?.data?.breakfastOrders![index].status!}",
                                               "${snapshot.data?.data?.breakfastOrders![index].itemStatus!}",
                                               true);
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 100,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 // Shadow color
                                                 blurRadius:
                                                 3.0,
                                                 // Spread of the shadow
                                                 offset: Offset(
                                                     0,
                                                     4), // Offset of the shadow
                                               ),
                                             ],
                                             color:
                                             Colors.white,
                                             border: Border.all(
                                                 color: AppConstant
                                                     .appColor,
                                                 width: 1.5),
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "View order",
                                                 fontSize: 14,
                                                 color: AppConstant
                                                     .appColor,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 10),
                           ],
                         ),
                     ),
                   ),
                       );
                 },
               ),
               SizedBox(height: 60),
             ],
           ),
         )
             :Column(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             Padding(
               padding: const EdgeInsets.only(top: 100.0),
               child: SvgPicture.asset("assets/images/noLiveOrder.svg"),
             ),
             poppinsText(
                 maxLines: 5,
                 txt: "There are no Orders",
                 fontSize: 16,
                 textAlign:
                 TextAlign.start,
                 weight:
                 FontWeight.w600),
           ],
         ):
         sIndex==2?
         snapshot.data?.data?.lunchOrders!.length != 0
             ?SingleChildScrollView(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               ListView.builder(
                 itemCount: snapshot.data?.data?.lunchOrders!.length,
                 physics: NeverScrollableScrollPhysics(),
                 shrinkWrap: true,
                 itemBuilder: (context, index) {
                   return (snapshot.data?.data?.lunchOrders![index].orderType == "trial" && snapshot.data?.data?.lunchOrders![index].status == "9") || (snapshot.data?.data?.lunchOrders![index].orderType == "trial" && snapshot.data?.data?.lunchOrders![index].status == "2") ||
                       (snapshot.data?.data?.lunchOrders![index].orderType == "package" && snapshot.data?.data?.lunchOrders![index].itemStatus == "7") || (snapshot.data?.data?.lunchOrders![index].orderType == "package" && snapshot.data?.data?.lunchOrders![index].itemStatus == "10")
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ],
                           color: lFade,
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.lunchOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.lunchOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.lunchOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.lunchOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.lunchOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.lunchOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.lunchOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: SvgPicture.asset("assets/images/rejected1.svg",height: 200,fit: BoxFit.cover,),
                       ),
                     ],
                   )
                       : snapshot.data?.data?.lunchOrders![index].orderType == "package" && snapshot.data?.data?.lunchOrders![index].itemStatus == "8"
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ],
                           color: lFade,
                           /* color:
                           snapshot.data?.data?.lunchOrders![index].orderType == "trial"
                               ? Colors.white
                               :snapshot.data?.data?.lunchOrders![index].mealFor == "Breakfast"
                               ? bShade//customColor3
                               : snapshot.data?.data?.lunchOrders![index].mealFor == "Lunch"
                               ? lShade//customColor1
                               : snapshot.data?.data?.lunchOrders![index].mealFor == "Dinner"
                               ? dShade//customColor2
                               : Colors.white,*/
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.lunchOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.lunchOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.lunchOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.lunchOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.lunchOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.lunchOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.lunchOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: SvgPicture.asset("assets/images/postponed1.svg",height: 200,fit: BoxFit.cover,),
                       ),
                     ],
                   )
                       : (snapshot.data?.data?.lunchOrders![index].orderType == "trial" && snapshot.data?.data?.lunchOrders![index].status == "7") || snapshot.data?.data?.lunchOrders![index].orderType == "package" && snapshot.data?.data?.lunchOrders![index].itemStatus == "4"
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ],
                           color: lFade,
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.lunchOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.lunchOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.lunchOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.lunchOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.lunchOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.lunchOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.lunchOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: Image.asset(
                           "assets/images/cancelled.png",height: 200,fit: BoxFit.cover,
                         ),//SvgPicture.asset("assets/images/postponed1.svg",height: 200,fit: BoxFit.cover,),
                       ),
                     ],
                   )
                       :InkWell(
                     onTap: () {
                       showAlertDialog(
                           context,
                           "${snapshot.data?.data?.lunchOrders![index].orderId!.toString()}",
                           "${snapshot.data?.data?.lunchOrders![index].orderitemsId!.toString()}",
                           "${snapshot.data?.data?.lunchOrders![index].orderNumber!.toString()}",
                           "${snapshot.data?.data?.lunchOrders![index].pickupTime!.toString()}",
                           "${snapshot.data?.data?.lunchOrders![index].orderNumber!.toString()}",
                           "${snapshot.data?.data?.lunchOrders![index].orderTypes == "old" ? "old" : "new"}",
                           "${snapshot.data?.data?.lunchOrders![index].orderType!}",
                           "${snapshot.data?.data?.lunchOrders![index].deliveryDate!}",
                           "${snapshot.data?.data?.lunchOrders![index].status!}",
                           "${snapshot.data?.data?.lunchOrders![index].itemStatus!}",
                           true);
                     },
                         child: Container(
                     margin: EdgeInsets.only(
                           bottom: 14,
                           top: 4,
                           left: 12.0,
                           right: 12.0),
                     alignment: Alignment.center,
                     // height: 205,
                     width: double.infinity,
                     decoration: BoxDecoration(
                         boxShadow: [
                           BoxShadow(
                             color:
                             Colors.grey, // Shadow color
                             blurRadius:
                             8.0, // Spread of the shadow
                             offset: Offset(
                                 4, 4), // Offset of the shadow
                           ),
                         ],
                         color:  customColor1,
                         borderRadius:
                         BorderRadius.circular(6),
                     ),
                     child: Padding(
                         padding: const EdgeInsets.only(
                             left: 12.0, right: 12.0, top: 12),
                         child: Column(
                           crossAxisAlignment:
                           CrossAxisAlignment.start,
                           children: [
                             Row(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               mainAxisAlignment:
                               MainAxisAlignment.start,
                               children: [
                                 snapshot
                                     .data
                                     ?.data
                                     ?.lunchOrders![index]
                                     .customerDetail!
                                     .customerImage ==
                                     ''
                                     ? Container(
                                   height: 50,
                                   width: 50,
                                   decoration:
                                   BoxDecoration(
                                       shape: BoxShape
                                           .circle,
                                       color: Colors
                                           .blue),
                                 )
                                     : Container(
                                   width: 50,
                                   height: 50,
                                   child: CircleAvatar(
                                     radius: 45,
                                     backgroundImage:
                                     NetworkImage(
                                       '${snapshot.data?.data?.lunchOrders![index].customerDetail!.customerImage}',
                                     ),
                                   ),
                                 ),
                                 SizedBox(width: 10),
                                 Expanded(
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment
                                         .spaceBetween,
                                     crossAxisAlignment:
                                     CrossAxisAlignment
                                         .start,
                                     children: [
                                       Column(
                                           crossAxisAlignment:
                                           CrossAxisAlignment
                                               .start,
                                           mainAxisAlignment:
                                           MainAxisAlignment
                                               .center,
                                           children: [
                                             poppinsText(
                                                 maxLines: 1,
                                                 txt: snapshot
                                                     .data
                                                     ?.data
                                                     ?.lunchOrders![
                                                 index]
                                                     .customerDetail!
                                                     .customerName,
                                                 fontSize: 14,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w600),
                                             poppinsText(
                                                 maxLines: 1,
                                                 txt: snapshot.data?.data?.lunchOrders![index].orderNumber,
                                                 fontSize: 12,
                                                 color:
                                                 textNumber,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ]),
                                       poppinsText(
                                           txt: snapshot
                                               .data
                                               ?.data
                                               ?.lunchOrders![index]
                                               .mealFor,
                                           maxLines: 1,
                                           fontSize: 14,
                                           color: Colors.red,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w600),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 14),
                             Row(
                               children: [
                                 SizedBox(width: 14),
                                 Container(
                                   height: 25,
                                   width: 25,
                                   decoration: BoxDecoration(
                                       image: DecorationImage(
                                           image: AssetImage(
                                               "assets/images/live_order.png")),
                                       shape: BoxShape.circle,
                                       color: Colors.blue),
                                 ),
                                 SizedBox(width: 8),
                                 Container(
                                   alignment:
                                   Alignment.centerLeft,
                                   //color: Colors.red,
                                   width:
                                   MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.72,
                                   child: poppinsText(
                                       maxLines: 5,
                                       txt: snapshot
                                           .data
                                           ?.data
                                           ?.lunchOrders![index]
                                           .itemName,
                                       fontSize: 12,
                                       textAlign:
                                       TextAlign.start,
                                       weight:
                                       FontWeight.w600),
                                 ),
                               ],
                             ),
                             SizedBox(height: 10),
                             poppinsText(
                                 maxLines: 1,
                                 txt: "Pickup Time: ${snapshot.data?.data?.lunchOrders![index].pickupTime.toString()}",
                                 fontSize: 14,
                                 color: Colors.red,
                                 textAlign: TextAlign.center,
                                 weight: FontWeight.w600),
                             SizedBox(height: 4),
                             snapshot.data?.data?.lunchOrders![index].specialInstruction==""?SizedBox():
                             Row(
                               //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(
                                   "Instruction : ",
                                   style: TextStyle(
                                       color: Colors.grey,
                                       fontSize: 13,
                                       fontWeight: FontWeight.bold),
                                 ),
                                 Container(
                                   //color: Colors.black,
                                   width: 230,
                                   child: Text(
                                     "${snapshot.data?.data?.lunchOrders![index].specialInstruction}",
                                     maxLines: 2,
                                     style: TextStyle(
                                         color: Colors.red,
                                         fontSize: 13,
                                         fontWeight: FontWeight.bold),
                                   ),
                                 ),
                               ],
                             ),SizedBox(height: 10),

                             Row(
                               mainAxisAlignment:
                               MainAxisAlignment.start,
                               children: [
                                 Visibility(
                                   visible: snapshot.data?.data?.lunchOrders![index].orderType == "trial" && snapshot.data?.data?.lunchOrders![index].status == "0"
                                       || snapshot.data?.data?.lunchOrders![index].orderType == "package" && snapshot.data?.data?.lunchOrders![index].itemStatus == "5"
                                       || snapshot.data?.data?.lunchOrders![index].orderType == "package" && snapshot.data?.data?.lunchOrders![index].status == "0"
                                       ? true
                                       : false,
                                   child: Row(
                                     children: [
                                       InkWell(
                                         onTap: () {
                                           rejectDialog(
                                               orderNumber:
                                               "${snapshot.data?.data?.lunchOrders![index].orderNumber!.toString()}",
                                               orderID: snapshot
                                                   .data
                                                   ?.data
                                                   ?.lunchOrders![
                                               index]
                                                   .orderTypes! ==
                                                   "old"
                                                   ? snapshot
                                                   .data
                                                   ?.data
                                                   ?.lunchOrders![
                                               index]
                                                   .orderitemsId
                                                   : snapshot
                                                   .data
                                                   ?.data
                                                   ?.lunchOrders![
                                               index]
                                                   .orderId,
                                               subscriptionType: snapshot
                                                   .data
                                                   ?.data
                                                   ?.lunchOrders![
                                               index]
                                                   .orderTypes ==
                                                   'old'
                                                   ? 'old'
                                                   : 'new',
                                               isFromDetails:
                                               false);
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 70,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 blurRadius:
                                                 10.0,
                                                 offset:
                                                 Offset(
                                                     0, 4),
                                               ),
                                             ],
                                             color: redButton,
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "Reject",
                                                 fontSize: 14,
                                                 color: Colors
                                                     .white,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                       SizedBox(
                                         width: 16,
                                       ),
                                       InkWell(
                                         onTap: () {
                                           acceptDialog(
                                               orderNumber:
                                               "${snapshot.data?.data?.lunchOrders![index].orderNumber!.toString()}",
                                               orderID: snapshot
                                                   .data
                                                   ?.data
                                                   ?.lunchOrders![
                                               index]
                                                   .orderTypes! ==
                                                   "old"
                                                   ? snapshot
                                                   .data
                                                   ?.data
                                                   ?.lunchOrders![
                                               index]
                                                   .orderitemsId
                                                   : snapshot
                                                   .data
                                                   ?.data
                                                   ?.lunchOrders![
                                               index]
                                                   .orderId,
                                               subscriptionType: snapshot
                                                   .data
                                                   ?.data
                                                   ?.lunchOrders![
                                               index]
                                                   .orderTypes ==
                                                   'old'
                                                   ? 'old'
                                                   : 'new',
                                               isFromDetails:
                                               false,
                                               instructions: snapshot.data?.data?.lunchOrders![index].specialInstruction);
                                           print(
                                               "-------------------------------=>${snapshot.data?.data?.lunchOrders![index].orderTypes}");
                                           print(
                                               "-------------------------------1=>${snapshot.data?.data?.lunchOrders![index].orderType}");
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 80,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 // Shadow color
                                                 blurRadius:
                                                 10.0,
                                                 // Spread of the shadow
                                                 offset: Offset(
                                                     0,
                                                     4), // Offset of the shadow
                                               ),
                                             ],
                                             color:
                                             greenButton,
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "Accept",
                                                 fontSize: 14,
                                                 color: Colors
                                                     .white,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                                 Visibility(
                                   visible: snapshot.data?.data?.lunchOrders![index].orderType == "trial" && snapshot.data?.data?.lunchOrders![index].status == "1"
                                       || snapshot.data?.data?.lunchOrders![index].orderType == "package" && snapshot.data?.data?.lunchOrders![index].itemStatus == "6"
                                       ? true
                                       : false,
                                   child: Row(
                                     children: [
                                       poppinsText(
                                           maxLines: 2,
                                           txt:
                                           "Ready to Pick-up",
                                           fontSize: 13,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                       SizedBox(width: 4),
                                       Transform.scale(
                                           scale: 1.5,
                                           child: Switch(
                                             onChanged:
                                                 (value) {
                                               if (isSwitched ==
                                                   false) {
                                                 setState(() {
                                                   isSwitched =
                                                   true;
                                                   isSlided =
                                                   true;

                                                   statusChangeDilog(
                                                     "${snapshot.data?.data?.lunchOrders![index].status.toString()}",
                                                     "${snapshot.data?.data?.lunchOrders![index].orderitemsId == "" ? snapshot.data?.data?.lunchOrders![index].orderId : snapshot.data?.data?.lunchOrders![index].orderitemsId.toString()}",
                                                   );
                                                   textValue =
                                                   'Switch Button is ON';
                                                   isSwitched =
                                                   false;
                                                 });
                                               } else {
                                                 setState(() {
                                                   textValue =
                                                   'Switch Button is OFF';
                                                 });
                                               }
                                             },
                                             value: isSwitched,
                                             activeColor:
                                             AppConstant
                                                 .appColor,
                                             activeTrackColor:
                                             AppConstant
                                                 .appColorLite,
                                             inactiveThumbColor:
                                             Colors
                                                 .white70,
                                             inactiveTrackColor:
                                             Colors.green,
                                           ))
                                     ],
                                   ),
                                 ),
                                 Visibility(
                                   visible: snapshot
                                       .data
                                       ?.data
                                       ?.lunchOrders![
                                   index]
                                       .orderType ==
                                       "trial" &&
                                       snapshot
                                           .data
                                           ?.data
                                           ?.lunchOrders![
                                       index]
                                           .status ==
                                           "3" ||
                                       snapshot
                                           .data
                                           ?.data
                                           ?.lunchOrders![
                                       index]
                                           .orderType ==
                                           "package" &&
                                           snapshot
                                               .data
                                               ?.data
                                               ?.lunchOrders![
                                           index]
                                               .itemStatus ==
                                               "0"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 165,
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.black,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Row(
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .center,
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .center,
                                       children: [
                                         poppinsText(
                                             maxLines: 1,
                                             txt:
                                             "Ready to pickup",
                                             fontSize: 13,
                                             color:
                                             Colors.white,
                                             textAlign:
                                             TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w500),
                                         SizedBox(width: 2),
                                         Icon(Icons.check,
                                             color:
                                             Colors.white,
                                             size: 16,
                                             weight: 30,
                                             opticalSize: 20),
                                       ],
                                     ),
                                   ),
                                 ),
                                 Visibility(
                                   visible: (snapshot.data?.data?.lunchOrders![index].orderType == "trial" && (snapshot.data?.data?.lunchOrders![index].status == "9" || snapshot.data?.data?.lunchOrders![index].status == "2")) ||
                                       snapshot.data?.data?.lunchOrders![index].orderType == "package" &&snapshot.data?.data?.lunchOrders![index].itemStatus == "7" ||snapshot.data?.data?.lunchOrders![index].itemStatus == "10"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 100, //165
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.red,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Center(
                                       child: poppinsText(
                                           maxLines: 1,
                                           txt: "Rejected",
                                           fontSize: 13,
                                           color: Colors.white,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                     ),
                                   ),
                                 ),
                                 Visibility(
                                   visible: (snapshot.data?.data?.lunchOrders![index].orderType == "trial" && (snapshot.data?.data?.lunchOrders![index].status == "6" )) ||
                                       snapshot.data?.data?.lunchOrders![index].orderType == "package" && snapshot.data?.data?.lunchOrders![index].itemStatus == "3"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 100, //165
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.green,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Center(
                                       child: poppinsText(
                                           maxLines: 1,
                                           txt: "Delivered",
                                           fontSize: 13,
                                           color: Colors.white,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                     ),
                                   ),
                                 ),
                                 Expanded(
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment.end,
                                     mainAxisSize:
                                     MainAxisSize.max,
                                     children: [
                                       InkWell(
                                         onTap: () async{
                                           showAlertDialog(
                                               context,
                                               "${snapshot.data?.data?.lunchOrders![index].orderId!.toString()}",
                                               "${snapshot.data?.data?.lunchOrders![index].orderitemsId!.toString()}",
                                               "${snapshot.data?.data?.lunchOrders![index].orderNumber!.toString()}",
                                               "${snapshot.data?.data?.lunchOrders![index].pickupTime!.toString()}",
                                               "${snapshot.data?.data?.lunchOrders![index].orderNumber!.toString()}",
                                               "${snapshot.data?.data?.lunchOrders![index].orderTypes == "old" ? "old" : "new"}",
                                               "${snapshot.data?.data?.lunchOrders![index].orderType!}",
                                               "${snapshot.data?.data?.lunchOrders![index].deliveryDate!}",
                                               "${snapshot.data?.data?.lunchOrders![index].status!}",
                                               "${snapshot.data?.data?.lunchOrders![index].itemStatus!}",
                                               true);
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 100,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 // Shadow color
                                                 blurRadius:
                                                 3.0,
                                                 // Spread of the shadow
                                                 offset: Offset(
                                                     0,
                                                     4), // Offset of the shadow
                                               ),
                                             ],
                                             color:
                                             Colors.white,
                                             border: Border.all(
                                                 color: AppConstant
                                                     .appColor,
                                                 width: 1.5),
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "View order",
                                                 fontSize: 14,
                                                 color: AppConstant
                                                     .appColor,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 10),
                           ],
                         ),
                     ),
                   ),
                       );
                 },
               ),
               SizedBox(height: 60),
             ],
           ),
         )
             :Column(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             Padding(
               padding: const EdgeInsets.only(top: 100.0),
               child: SvgPicture.asset("assets/images/noLiveOrder.svg"),
             ),
             poppinsText(
                 maxLines: 5,
                 txt: "There are no Orders",
                 fontSize: 16,
                 textAlign:
                 TextAlign.start,
                 weight:
                 FontWeight.w600),
           ],
         ):
         sIndex==3?
         snapshot.data?.data?.dinnerOrders!.length != 0
             ?SingleChildScrollView(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               ListView.builder(
                 itemCount: snapshot.data?.data?.dinnerOrders!.length,
                 physics: NeverScrollableScrollPhysics(),
                 shrinkWrap: true,
                 itemBuilder: (context, index) {
                   return (snapshot.data?.data?.dinnerOrders![index].orderType == "trial" && snapshot.data?.data?.dinnerOrders![index].status == "9") || (snapshot.data?.data?.dinnerOrders![index].orderType == "trial" && snapshot.data?.data?.dinnerOrders![index].status == "2") ||
                       (snapshot.data?.data?.dinnerOrders![index].orderType == "package" && snapshot.data?.data?.dinnerOrders![index].itemStatus == "7") || (snapshot.data?.data?.dinnerOrders![index].orderType == "package" && snapshot.data?.data?.dinnerOrders![index].itemStatus == "10")
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ], color:dFade,
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.dinnerOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.dinnerOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.dinnerOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.dinnerOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.dinnerOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.dinnerOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.dinnerOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               snapshot.data?.data?.dinnerOrders![index].specialInstruction==""?SizedBox():
                               Row(
                                 children: [
                                   Text(
                                     "Instruction : ",
                                     style: TextStyle(
                                         color: Colors.grey,
                                         fontSize: 13,
                                         fontWeight: FontWeight.bold),
                                   ),
                                   Container(
                                     //color: Colors.black,
                                     width: 230,
                                     child: Text(
                                       "${snapshot.data?.data?.dinnerOrders![index].specialInstruction}",
                                       maxLines: 2,
                                       style: TextStyle(
                                           color: Colors.red,
                                           fontSize: 13,
                                           fontWeight: FontWeight.bold),
                                     ),
                                   ),
                                 ],
                               ),SizedBox(height: 10),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: SvgPicture.asset("assets/images/rejected1.svg",height: 200,fit: BoxFit.cover,),
                       ),
                     ],
                   )
                       : snapshot.data?.data?.dinnerOrders![index].orderType == "package" && snapshot.data?.data?.dinnerOrders![index].itemStatus == "8"
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ],color:
                         dFade,
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.dinnerOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.dinnerOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.dinnerOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.dinnerOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.dinnerOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.dinnerOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.dinnerOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: SvgPicture.asset("assets/images/postponed1.svg",height: 200,fit: BoxFit.cover,),
                       ),
                     ],
                   )
                       :(snapshot.data?.data?.dinnerOrders![index].orderType == "trial" && snapshot.data?.data?.dinnerOrders![index].status == "7") || snapshot.data?.data?.dinnerOrders![index].orderType == "package" && snapshot.data?.data?.dinnerOrders![index].itemStatus == "4"
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey, // Shadow color
                               blurRadius:
                               8.0, // Spread of the shadow
                               offset: Offset(
                                   4, 4), // Offset of the shadow
                             ),
                           ],color:
                         dFade,
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.dinnerOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.dinnerOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.dinnerOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.dinnerOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.dinnerOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.dinnerOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.dinnerOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: Image.asset(
                           "assets/images/cancelled.png",height: 200,fit: BoxFit.cover,
                         ),//SvgPicture.asset("assets/images/postponed1.svg",height: 200,fit: BoxFit.cover,),
                       ),
                     ],
                   )
                       : InkWell(
                     onTap: () {
                       showAlertDialog(
                           context,
                           "${snapshot.data?.data?.dinnerOrders![index].orderId!.toString()}",
                           "${snapshot.data?.data?.dinnerOrders![index].orderitemsId!.toString()}",
                           "${snapshot.data?.data?.dinnerOrders![index].orderNumber!.toString()}",
                           "${snapshot.data?.data?.dinnerOrders![index].pickupTime!.toString()}",
                           "${snapshot.data?.data?.dinnerOrders![index].orderNumber!.toString()}",
                           "${snapshot.data?.data?.dinnerOrders![index].orderTypes == "old" ? "old" : "new"}",
                           "${snapshot.data?.data?.dinnerOrders![index].orderType!}",
                           "${snapshot.data?.data?.dinnerOrders![index].deliveryDate!}",
                           "${snapshot.data?.data?.dinnerOrders![index].status!}",
                           "${snapshot.data?.data?.dinnerOrders![index].itemStatus!}",
                           true);
                     },
                         child: Container(
                     margin: EdgeInsets.only(
                           bottom: 14,
                           top: 4,
                           left: 12.0,
                           right: 12.0),
                     alignment: Alignment.center,
                     // height: 205,
                     width: double.infinity,
                     decoration: BoxDecoration(
                         boxShadow: [
                           BoxShadow(
                             color:
                             Colors.grey, // Shadow color
                             blurRadius:
                             8.0, // Spread of the shadow
                             offset: Offset(
                                 4, 4), // Offset of the shadow
                           ),
                         ],
                         color:  customColor2,
                         borderRadius:
                         BorderRadius.circular(6),
                     ),
                     child: Padding(
                         padding: const EdgeInsets.only(
                             left: 12.0, right: 12.0, top: 12),
                         child: Column(
                           crossAxisAlignment:
                           CrossAxisAlignment.start,
                           children: [
                             Row(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               mainAxisAlignment:
                               MainAxisAlignment.start,
                               children: [
                                 snapshot
                                     .data
                                     ?.data
                                     ?.dinnerOrders![index]
                                     .customerDetail!
                                     .customerImage ==
                                     ''
                                     ? Container(
                                   height: 50,
                                   width: 50,
                                   decoration:
                                   BoxDecoration(
                                       shape: BoxShape
                                           .circle,
                                       color: Colors
                                           .blue),
                                 )
                                     : Container(
                                   width: 50,
                                   height: 50,
                                   child: CircleAvatar(
                                     radius: 45,
                                     backgroundImage:
                                     NetworkImage(
                                       '${snapshot.data?.data?.dinnerOrders![index].customerDetail!.customerImage}',
                                     ),
                                   ),
                                 ),
                                 SizedBox(width: 10),
                                 Expanded(
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment
                                         .spaceBetween,
                                     crossAxisAlignment:
                                     CrossAxisAlignment
                                         .start,
                                     children: [
                                       Column(
                                           crossAxisAlignment:
                                           CrossAxisAlignment
                                               .start,
                                           mainAxisAlignment:
                                           MainAxisAlignment
                                               .center,
                                           children: [
                                             poppinsText(
                                                 maxLines: 1,
                                                 txt: snapshot
                                                     .data
                                                     ?.data
                                                     ?.dinnerOrders![
                                                 index]
                                                     .customerDetail!
                                                     .customerName,
                                                 fontSize: 14,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w600),
                                             poppinsText(
                                                 maxLines: 1,
                                                 txt: snapshot
                                                     .data
                                                     ?.data
                                                     ?.dinnerOrders![
                                                 index]
                                                     .orderNumber,
                                                 fontSize: 12,
                                                 color:
                                                 textNumber,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ]),
                                       poppinsText(
                                           txt: snapshot
                                               .data
                                               ?.data
                                               ?.dinnerOrders![index]
                                               .mealFor,
                                           maxLines: 1,
                                           fontSize: 14,
                                           color: Colors.red,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w600),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 14),
                             Row(
                               children: [
                                 SizedBox(width: 14),
                                 Container(
                                   height: 25,
                                   width: 25,
                                   decoration: BoxDecoration(
                                       image: DecorationImage(
                                           image: AssetImage(
                                               "assets/images/live_order.png")),
                                       shape: BoxShape.circle,
                                       color: Colors.blue),
                                 ),
                                 SizedBox(width: 8),
                                 Container(
                                   alignment:
                                   Alignment.centerLeft,
                                   //color: Colors.red,
                                   width:
                                   MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.72,
                                   child: poppinsText(
                                       maxLines: 5,
                                       txt: snapshot
                                           .data
                                           ?.data
                                           ?.dinnerOrders![index]
                                           .itemName,
                                       fontSize: 12,
                                       textAlign:
                                       TextAlign.start,
                                       weight:
                                       FontWeight.w600),
                                 ),
                               ],
                             ),
                             SizedBox(height: 10),
                             poppinsText(
                                 maxLines: 1,
                                 txt: "Pickup Time: ${snapshot.data?.data?.dinnerOrders![index].pickupTime.toString()}",
                                 fontSize: 14,
                                 color: Colors.red,
                                 textAlign: TextAlign.center,
                                 weight: FontWeight.w600),
                             SizedBox(height: 4),
                             snapshot.data?.data?.dinnerOrders![index].specialInstruction==""?SizedBox():
                             Row(
                               //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(
                                   "Instruction : ",
                                   style: TextStyle(
                                       color: Colors.grey,
                                       fontSize: 13,
                                       fontWeight: FontWeight.bold),
                                 ),
                                 Container(
                                   //color: Colors.black,
                                   width: 230,
                                   child: Text(
                                     "${snapshot.data?.data?.dinnerOrders![index].specialInstruction}",
                                     maxLines: 2,
                                     style: TextStyle(
                                         color: Colors.red,
                                         fontSize: 13,
                                         fontWeight: FontWeight.bold),
                                   ),
                                 ),
                               ],
                             ),SizedBox(height: 10),
                             Row(
                               mainAxisAlignment:
                               MainAxisAlignment.start,
                               children: [
                                 Visibility(
                                   visible: snapshot.data?.data?.dinnerOrders![index].orderType == "trial" && snapshot.data?.data?.dinnerOrders![index].status == "0"
                                       || snapshot.data?.data?.dinnerOrders![index].orderType == "package" && snapshot.data?.data?.dinnerOrders![index].itemStatus == "5"
                                       || snapshot.data?.data?.dinnerOrders![index].orderType == "package" && snapshot.data?.data?.dinnerOrders![index].status == "0"
                                       ? true
                                       : false,
                                   child: Row(
                                     children: [
                                       InkWell(
                                         onTap: () {
                                           rejectDialog(
                                               orderNumber:
                                               "${snapshot.data?.data?.dinnerOrders![index].orderNumber!.toString()}",
                                               orderID: snapshot
                                                   .data
                                                   ?.data
                                                   ?.dinnerOrders![
                                               index]
                                                   .orderTypes! ==
                                                   "old"
                                                   ? snapshot
                                                   .data
                                                   ?.data
                                                   ?.dinnerOrders![
                                               index]
                                                   .orderitemsId
                                                   : snapshot
                                                   .data
                                                   ?.data
                                                   ?.dinnerOrders![
                                               index]
                                                   .orderId,
                                               subscriptionType: snapshot
                                                   .data
                                                   ?.data
                                                   ?.dinnerOrders![
                                               index]
                                                   .orderTypes ==
                                                   'old'
                                                   ? 'old'
                                                   : 'new',
                                               isFromDetails:
                                               false);
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 70,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 blurRadius:
                                                 10.0,
                                                 offset:
                                                 Offset(
                                                     0, 4),
                                               ),
                                             ],
                                             color: redButton,
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "Reject",
                                                 fontSize: 14,
                                                 color: Colors
                                                     .white,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                       SizedBox(
                                         width: 16,
                                       ),
                                       InkWell(
                                         onTap: () {
                                           acceptDialog(
                                               orderNumber:
                                               "${snapshot.data?.data?.dinnerOrders![index].orderNumber!.toString()}",
                                               orderID: snapshot
                                                   .data
                                                   ?.data
                                                   ?.dinnerOrders![
                                               index]
                                                   .orderTypes! ==
                                                   "old"
                                                   ? snapshot
                                                   .data
                                                   ?.data
                                                   ?.dinnerOrders![
                                               index]
                                                   .orderitemsId
                                                   : snapshot
                                                   .data
                                                   ?.data
                                                   ?.dinnerOrders![
                                               index]
                                                   .orderId,
                                               subscriptionType: snapshot
                                                   .data
                                                   ?.data
                                                   ?.dinnerOrders![
                                               index]
                                                   .orderTypes ==
                                                   'old'
                                                   ? 'old'
                                                   : 'new',
                                               isFromDetails:
                                               false,
                                               instructions: snapshot.data?.data?.dinnerOrders![index].specialInstruction);
                                           print(
                                               "-------------------------------=>${snapshot.data?.data?.dinnerOrders![index].orderTypes}");
                                           print(
                                               "-------------------------------1=>${snapshot.data?.data?.dinnerOrders![index].orderType}");
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 80,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 // Shadow color
                                                 blurRadius:
                                                 10.0,
                                                 // Spread of the shadow
                                                 offset: Offset(
                                                     0,
                                                     4), // Offset of the shadow
                                               ),
                                             ],
                                             color:
                                             greenButton,
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "Accept",
                                                 fontSize: 14,
                                                 color: Colors
                                                     .white,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                                 Visibility(
                                   visible: snapshot.data?.data?.dinnerOrders![index].orderType == "trial" && snapshot.data?.data?.dinnerOrders![index].status == "1"
                                       || snapshot.data?.data?.dinnerOrders![index].orderType == "package" && snapshot.data?.data?.dinnerOrders![index].itemStatus == "6"
                                       ? true
                                       : false,
                                   child: Row(
                                     children: [
                                       poppinsText(
                                           maxLines: 2,
                                           txt:
                                           "Ready to Pick-up",
                                           fontSize: 13,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                       SizedBox(width: 4),
                                       Transform.scale(
                                           scale: 1.5,
                                           child: Switch(
                                             onChanged:
                                                 (value) {
                                               if (isSwitched ==
                                                   false) {
                                                 setState(() {
                                                   isSwitched =
                                                   true;
                                                   isSlided =
                                                   true;

                                                   statusChangeDilog(
                                                     "${snapshot.data?.data?.dinnerOrders![index].status.toString()}",
                                                     "${snapshot.data?.data?.dinnerOrders![index].orderitemsId == "" ? snapshot.data?.data?.dinnerOrders![index].orderId : snapshot.data?.data?.dinnerOrders![index].orderitemsId.toString()}",
                                                   );
                                                   textValue =
                                                   'Switch Button is ON';
                                                   isSwitched =
                                                   false;
                                                 });
                                               } else {
                                                 setState(() {
                                                   textValue =
                                                   'Switch Button is OFF';
                                                 });
                                               }
                                             },
                                             value: isSwitched,
                                             activeColor:
                                             AppConstant
                                                 .appColor,
                                             activeTrackColor:
                                             AppConstant
                                                 .appColorLite,
                                             inactiveThumbColor:
                                             Colors
                                                 .white70,
                                             inactiveTrackColor:
                                             Colors.green,
                                           ))
                                     ],
                                   ),
                                 ),
                                 Visibility(
                                   visible: snapshot
                                       .data
                                       ?.data
                                       ?.dinnerOrders![
                                   index]
                                       .orderType ==
                                       "trial" &&
                                       snapshot
                                           .data
                                           ?.data
                                           ?.dinnerOrders![
                                       index]
                                           .status ==
                                           "3" ||
                                       snapshot
                                           .data
                                           ?.data
                                           ?.dinnerOrders![
                                       index]
                                           .orderType ==
                                           "package" &&
                                           snapshot
                                               .data
                                               ?.data
                                               ?.dinnerOrders![
                                           index]
                                               .itemStatus ==
                                               "0"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 165,
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.black,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Row(
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .center,
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .center,
                                       children: [
                                         poppinsText(
                                             maxLines: 1,
                                             txt:
                                             "Ready to pickup",
                                             fontSize: 13,
                                             color:
                                             Colors.white,
                                             textAlign:
                                             TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w500),
                                         SizedBox(width: 2),
                                         Icon(Icons.check,
                                             color:
                                             Colors.white,
                                             size: 16,
                                             weight: 30,
                                             opticalSize: 20),
                                       ],
                                     ),
                                   ),
                                 ),
                                 Visibility(
                                   visible: (snapshot.data?.data?.dinnerOrders![index].orderType == "trial" && (snapshot.data?.data?.dinnerOrders![index].status == "9" || snapshot.data?.data?.dinnerOrders![index].status == "2")) ||
                                       snapshot.data?.data?.dinnerOrders![index].orderType == "package" &&snapshot.data?.data?.dinnerOrders![index].itemStatus == "7" ||snapshot.data?.data?.dinnerOrders![index].itemStatus == "10"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 100, //165
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.red,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Center(
                                       child: poppinsText(
                                           maxLines: 1,
                                           txt: "Rejected",
                                           fontSize: 13,
                                           color: Colors.white,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                     ),
                                   ),
                                 ),
                                 Visibility(
                                   visible: (snapshot.data?.data?.dinnerOrders![index].orderType == "trial" && (snapshot.data?.data?.dinnerOrders![index].status == "6" )) ||
                                       snapshot.data?.data?.dinnerOrders![index].orderType == "package" && snapshot.data?.data?.dinnerOrders![index].itemStatus == "3"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 100, //165
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.green,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Center(
                                       child: poppinsText(
                                           maxLines: 1,
                                           txt: "Delivered",
                                           fontSize: 13,
                                           color: Colors.white,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                     ),
                                   ),
                                 ),
                                 Expanded(
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment.end,
                                     mainAxisSize:
                                     MainAxisSize.max,
                                     children: [
                                       InkWell(
                                         onTap: () async{
                                           showAlertDialog(
                                               context,
                                               "${snapshot.data?.data?.dinnerOrders![index].orderId!.toString()}",
                                               "${snapshot.data?.data?.dinnerOrders![index].orderitemsId!.toString()}",
                                               "${snapshot.data?.data?.dinnerOrders![index].orderNumber!.toString()}",
                                               "${snapshot.data?.data?.dinnerOrders![index].pickupTime!.toString()}",
                                               "${snapshot.data?.data?.dinnerOrders![index].orderNumber!.toString()}",
                                               "${snapshot.data?.data?.dinnerOrders![index].orderTypes == "old" ? "old" : "new"}",
                                               "${snapshot.data?.data?.dinnerOrders![index].orderType!}",
                                               "${snapshot.data?.data?.dinnerOrders![index].deliveryDate!}",
                                               "${snapshot.data?.data?.dinnerOrders![index].status!}",
                                               "${snapshot.data?.data?.dinnerOrders![index].itemStatus!}",
                                               true);
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 100,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 // Shadow color
                                                 blurRadius:
                                                 3.0,
                                                 // Spread of the shadow
                                                 offset: Offset(
                                                     0,
                                                     4), // Offset of the shadow
                                               ),
                                             ],
                                             color:
                                             Colors.white,
                                             border: Border.all(
                                                 color: AppConstant
                                                     .appColor,
                                                 width: 1.5),
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "View order",
                                                 fontSize: 14,
                                                 color: AppConstant
                                                     .appColor,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 10),
                           ],
                         ),
                     ),
                   ),
                       );
                 },
               ),
               SizedBox(height: 60),
             ],
           ),
         )
             :Column(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             Padding(
               padding: const EdgeInsets.only(top: 100.0),
               child: SvgPicture.asset("assets/images/noLiveOrder.svg"),
             ),
             poppinsText(
                 maxLines: 5,
                 txt: "There are no Orders",
                 fontSize: 16,
                 textAlign:
                 TextAlign.start,
                 weight:
                 FontWeight.w600),
           ],
         ):
         sIndex==4?
         snapshot.data?.data?.preOrders!.length != 0
             ?SingleChildScrollView(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               ListView.builder(
                 itemCount: snapshot.data?.data?.preOrders!.length,
                 physics: NeverScrollableScrollPhysics(),
                 shrinkWrap: true,
                 itemBuilder: (context, index) {
                   return (snapshot.data?.data?.preOrders![index].orderType == "trial" && snapshot.data?.data?.preOrders![index].status == "9") || (snapshot.data?.data?.preOrders![index].orderType == "trial" && snapshot.data?.data?.preOrders![index].status == "2")
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey,
                               blurRadius:
                               8.0,
                               offset: Offset(
                                   4, 4),
                             ),
                           ],
                           color:
                           Colors.white,
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.preOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.preOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.preOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.preOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.preOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.preOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.preOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: SvgPicture.asset("assets/images/rejected1.svg",height: 200,fit: BoxFit.cover,),
                       ),
                     ],
                   )
                       //: snapshot.data?.data?.preOrders![index].orderType == "package" && snapshot.data?.data?.preOrders![index].itemStatus == "8"
                       :  (snapshot.data?.data?.preOrders![index].orderType == "trial" && snapshot.data?.data?.preOrders![index].status == "7")
                       ?Stack(
                     children: [
                       Container(
                         margin: EdgeInsets.only(
                             bottom: 14,
                             top: 4,
                             left: 12.0,
                             right: 12.0),
                         alignment: Alignment.center,
                         // height: 205,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color:
                               Colors.grey.withOpacity(0.5),
                               blurRadius:
                               8.0,
                               offset: Offset(
                                   4, 4),
                             ),
                           ],
                           color: snapshot.data?.data?.preOrders![index].mealFor == "Breakfast"
                               ? customColor3
                               : snapshot.data?.data?.preOrders![index].mealFor == "Lunch"
                               ? customColor1
                               : snapshot.data?.data?.preOrders![index].mealFor == "Dinner"
                               ? customColor2
                               : Colors.white,
                           borderRadius:
                           BorderRadius.circular(6),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.only(
                               left: 12.0, right: 12.0, top: 10),
                           child: Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Row(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [
                                   snapshot
                                       .data
                                       ?.data
                                       ?.preOrders![index]
                                       .customerDetail!
                                       .customerImage ==
                                       ''
                                       ? Container(
                                     height: 50,
                                     width: 50,
                                     decoration:
                                     BoxDecoration(
                                         shape: BoxShape
                                             .circle,
                                         color: Colors
                                             .blue),
                                   )
                                       : Container(
                                     width: 50,
                                     height: 50,
                                     child: CircleAvatar(
                                       radius: 45,
                                       backgroundImage:
                                       NetworkImage(
                                         '${snapshot.data?.data?.preOrders![index].customerDetail!.customerImage}',
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .spaceBetween,
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .start,
                                       children: [
                                         Column(
                                             crossAxisAlignment:
                                             CrossAxisAlignment
                                                 .start,
                                             mainAxisAlignment:
                                             MainAxisAlignment
                                                 .center,
                                             children: [
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.preOrders![
                                                   index]
                                                       .customerDetail!
                                                       .customerName,
                                                   fontSize: 14,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w600),
                                               poppinsText(
                                                   maxLines: 1,
                                                   txt: snapshot
                                                       .data
                                                       ?.data
                                                       ?.preOrders![
                                                   index]
                                                       .orderNumber,
                                                   fontSize: 12,
                                                   color:
                                                   textNumber,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ]),
                                         poppinsText(
                                             txt: snapshot
                                                 .data
                                                 ?.data
                                                 ?.preOrders![index]
                                                 .mealFor,
                                             maxLines: 1,
                                             fontSize: 14,
                                             color: Colors.red,
                                             textAlign: TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w600),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 14),
                               Row(
                                 children: [
                                   SizedBox(width: 14),
                                   Container(
                                     height: 25,
                                     width: 25,
                                     decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage(
                                                 "assets/images/live_order.png")),
                                         shape: BoxShape.circle,
                                         color: Colors.blue),
                                   ),
                                   SizedBox(width: 8),
                                   Container(
                                     alignment:
                                     Alignment.centerLeft,
                                     width: MediaQuery.of(context).size.width * 0.72,
                                     child: poppinsText(
                                         maxLines: 1,
                                         txt: snapshot.data?.data?.preOrders![index].itemName,
                                         fontSize: 12,
                                         textAlign: TextAlign.start,
                                         weight: FontWeight.w600),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                               poppinsText(
                                   maxLines: 1,
                                   txt: "Pickup Time: ${snapshot.data?.data?.preOrders![index].pickupTime.toString()}",
                                   fontSize: 14,
                                   color: Colors.red,
                                   textAlign: TextAlign.center,
                                   weight: FontWeight.w600),
                               SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment:
                                 MainAxisAlignment.start,
                                 children: [

                                   Expanded(
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.end,
                                       mainAxisSize:
                                       MainAxisSize.max,
                                       children: [
                                         InkWell(
                                           onTap: () {
                                           },
                                           child: Container(
                                             alignment: Alignment
                                                 .center,
                                             height: 40,
                                             width: 100,
                                             decoration:
                                             BoxDecoration(
                                               boxShadow: [
                                                 BoxShadow(
                                                   color: Colors
                                                       .grey,
                                                   // Shadow color
                                                   blurRadius:
                                                   3.0,
                                                   // Spread of the shadow
                                                   offset: Offset(
                                                       0,
                                                       4), // Offset of the shadow
                                                 ),
                                               ],
                                               color:
                                               Colors.white,
                                               border: Border.all(
                                                   color: AppConstant
                                                       .appColor,
                                                   width: 1.5),
                                               borderRadius:
                                               BorderRadius
                                                   .circular(
                                                   10),
                                             ),
                                             child: Center(
                                               child: poppinsText(
                                                   maxLines: 1,
                                                   txt: "View order",
                                                   fontSize: 14,
                                                   color: AppConstant
                                                       .appColor,
                                                   textAlign:
                                                   TextAlign
                                                       .center,
                                                   weight:
                                                   FontWeight
                                                       .w400),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(height: 10),
                             ],
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(top: 0,left: 12,right: 12),
                         child: Image.asset(
                           "assets/images/cancelled.png",height: 200,fit: BoxFit.cover,
                         ),//SvgPicture.asset("assets/images/postponed1.svg",height: 200,fit: BoxFit.cover,),
                       ),
                     ],
                   )

                       : InkWell(
                     onTap: () {
                       showAlertDialog(
                           context,
                           "${snapshot.data?.data?.preOrders![index].orderId!.toString()}",
                           "${snapshot.data?.data?.preOrders![index].orderitemsId!.toString()}",
                           "${snapshot.data?.data?.preOrders![index].orderNumber!.toString()}",
                           "${snapshot.data?.data?.preOrders![index].pickupTime!.toString()}",
                           "${snapshot.data?.data?.preOrders![index].orderNumber!.toString()}",
                           "${snapshot.data?.data?.preOrders![index].orderTypes == "old" ? "old" : "new"}",
                           "${snapshot.data?.data?.preOrders![index].orderType!}",
                           "${snapshot.data?.data?.preOrders![index].deliveryDate!}",
                           "${snapshot.data?.data?.preOrders![index].status!}",
                           "${snapshot.data?.data?.preOrders![index].itemStatus!}",
                           true);
                     },
                         child: Container(
                     margin: EdgeInsets.only(
                           bottom: 14,
                           top: 4,
                           left: 12.0,
                           right: 12.0),
                     alignment: Alignment.center,
                     // height: 205,
                     width: double.infinity,
                     decoration: BoxDecoration(
                         boxShadow: [
                           BoxShadow(
                             color:
                             Colors.grey, // Shadow color
                             blurRadius:
                             8.0, // Spread of the shadow
                             offset: Offset(
                                 4, 4), // Offset of the shadow
                           ),
                         ],
                         color: Colors.white,
                         borderRadius:
                         BorderRadius.circular(6),
                     ),
                     child: Padding(
                         padding: const EdgeInsets.only(
                             left: 12.0, right: 12.0, top: 12),
                         child: Column(
                           crossAxisAlignment:
                           CrossAxisAlignment.start,
                           children: [
                             Row(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               mainAxisAlignment:
                               MainAxisAlignment.start,
                               children: [
                                 snapshot
                                     .data
                                     ?.data
                                     ?.preOrders![index]
                                     .customerDetail!
                                     .customerImage ==
                                     ''
                                     ? Container(
                                   height: 50,
                                   width: 50,
                                   decoration:
                                   BoxDecoration(
                                       shape: BoxShape
                                           .circle,
                                       color: Colors
                                           .blue),
                                 )
                                     : Container(
                                   width: 50,
                                   height: 50,
                                   child: CircleAvatar(
                                     radius: 45,
                                     backgroundImage:
                                     NetworkImage(
                                       '${snapshot.data?.data?.preOrders![index].customerDetail!.customerImage}',
                                     ),
                                   ),
                                 ),
                                 SizedBox(width: 10),
                                 Expanded(
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment
                                         .spaceBetween,
                                     crossAxisAlignment:
                                     CrossAxisAlignment
                                         .start,
                                     children: [
                                       Column(
                                           crossAxisAlignment:
                                           CrossAxisAlignment
                                               .start,
                                           mainAxisAlignment:
                                           MainAxisAlignment
                                               .center,
                                           children: [
                                             poppinsText(
                                                 maxLines: 1,
                                                 txt: snapshot
                                                     .data
                                                     ?.data
                                                     ?.preOrders![
                                                 index]
                                                     .customerDetail!
                                                     .customerName,
                                                 fontSize: 14,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w600),
                                             poppinsText(
                                                 maxLines: 1,
                                                 txt: snapshot
                                                     .data
                                                     ?.data
                                                     ?.preOrders![
                                                 index]
                                                     .orderNumber,
                                                 fontSize: 12,
                                                 color:
                                                 textNumber,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ]),
                                       poppinsText(
                                           txt: snapshot
                                               .data
                                               ?.data
                                               ?.preOrders![index]
                                               .mealFor,
                                           maxLines: 1,
                                           fontSize: 14,
                                           color: Colors.red,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w600),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 14),
                             Row(
                               children: [
                                 SizedBox(width: 14),
                                 Container(
                                   height: 25,
                                   width: 25,
                                   decoration: BoxDecoration(
                                       image: DecorationImage(
                                           image: AssetImage(
                                               "assets/images/live_order.png")),
                                       shape: BoxShape.circle,
                                       color: Colors.blue),
                                 ),
                                 SizedBox(width: 8),
                                 Container(
                                   alignment:
                                   Alignment.centerLeft,
                                   //color: Colors.red,
                                   width:
                                   MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.72,
                                   child: poppinsText(
                                       maxLines: 5,
                                       txt: snapshot
                                           .data
                                           ?.data
                                           ?.preOrders![index]
                                           .itemName,
                                       fontSize: 12,
                                       textAlign:
                                       TextAlign.start,
                                       weight:
                                       FontWeight.w600),
                                 ),
                               ],
                             ),
                             SizedBox(height: 10),
                             poppinsText(
                                 maxLines: 1,
                                 txt: "Pickup Time: ${snapshot.data?.data?.preOrders![index].pickupTime.toString()}",
                                 fontSize: 14,
                                 color: Colors.red,
                                 textAlign: TextAlign.center,
                                 weight: FontWeight.w600),
                             SizedBox(height: 4),
                             snapshot.data?.data?.preOrders![index].specialInstruction==""?SizedBox():
                             Row(
                               //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(
                                   "Instruction : ",
                                   style: TextStyle(
                                       color: Colors.grey,
                                       fontSize: 13,
                                       fontWeight: FontWeight.bold),
                                 ),
                                 Container(
                                   //color: Colors.black,
                                   width: 230,
                                   child: Text(
                                     "${snapshot.data?.data?.preOrders![index].specialInstruction}",
                                     maxLines: 2,
                                     style: TextStyle(
                                         color: Colors.red,
                                         fontSize: 13,
                                         fontWeight: FontWeight.bold),
                                   ),
                                 ),
                               ],
                             ),SizedBox(height: 10),
                             Row(
                               mainAxisAlignment:
                               MainAxisAlignment.start,
                               children: [
                                 Visibility(
                                   visible: snapshot.data?.data?.preOrders![index].orderType == "trial" && snapshot.data?.data?.preOrders![index].status == "0"
                                       || snapshot.data?.data?.preOrders![index].orderType == "package" && snapshot.data?.data?.preOrders![index].itemStatus == "5"
                                       || snapshot.data?.data?.preOrders![index].orderType == "package" && snapshot.data?.data?.preOrders![index].status == "0"
                                       ? true
                                       : false,
                                   child: Row(
                                     children: [
                                       InkWell(
                                         onTap: () {
                                           rejectDialog(
                                               orderNumber:
                                               "${snapshot.data?.data?.preOrders![index].orderNumber!.toString()}",
                                               orderID: snapshot
                                                   .data
                                                   ?.data
                                                   ?.preOrders![
                                               index]
                                                   .orderTypes! ==
                                                   "old"
                                                   ? snapshot
                                                   .data
                                                   ?.data
                                                   ?.preOrders![
                                               index]
                                                   .orderitemsId
                                                   : snapshot
                                                   .data
                                                   ?.data
                                                   ?.preOrders![
                                               index]
                                                   .orderId,
                                               subscriptionType: snapshot
                                                   .data
                                                   ?.data
                                                   ?.preOrders![
                                               index]
                                                   .orderTypes ==
                                                   'old'
                                                   ? 'old'
                                                   : 'new',
                                               isFromDetails:
                                               false);
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 70,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 blurRadius:
                                                 10.0,
                                                 offset:
                                                 Offset(
                                                     0, 4),
                                               ),
                                             ],
                                             color: redButton,
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "Reject",
                                                 fontSize: 14,
                                                 color: Colors
                                                     .white,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                       SizedBox(
                                         width: 16,
                                       ),
                                       InkWell(
                                         onTap: () {
                                           acceptDialog(
                                               orderNumber:
                                               "${snapshot.data?.data?.preOrders![index].orderNumber!.toString()}",
                                               orderID: snapshot
                                                   .data
                                                   ?.data
                                                   ?.preOrders![
                                               index]
                                                   .orderTypes! ==
                                                   "old"
                                                   ? snapshot
                                                   .data
                                                   ?.data
                                                   ?.preOrders![
                                               index]
                                                   .orderitemsId
                                                   : snapshot
                                                   .data
                                                   ?.data
                                                   ?.preOrders![
                                               index]
                                                   .orderId,
                                               subscriptionType: snapshot
                                                   .data
                                                   ?.data
                                                   ?.preOrders![
                                               index]
                                                   .orderTypes ==
                                                   'old'
                                                   ? 'old'
                                                   : 'new',
                                               isFromDetails:
                                               false,
                                               instructions: snapshot.data?.data?.preOrders![index].specialInstruction);
                                           print(
                                               "-------------------------------=>${snapshot.data?.data?.preOrders![index].orderTypes}");
                                           print(
                                               "-------------------------------1=>${snapshot.data?.data?.preOrders![index].orderType}");
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 80,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 // Shadow color
                                                 blurRadius:
                                                 10.0,
                                                 // Spread of the shadow
                                                 offset: Offset(
                                                     0,
                                                     4), // Offset of the shadow
                                               ),
                                             ],
                                             color:
                                             greenButton,
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "Accept",
                                                 fontSize: 14,
                                                 color: Colors
                                                     .white,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                                 Visibility(
                                   visible: snapshot.data?.data?.preOrders![index].orderType == "trial" && snapshot.data?.data?.preOrders![index].status == "1"
                                       || snapshot.data?.data?.preOrders![index].orderType == "package" && snapshot.data?.data?.preOrders![index].itemStatus == "6"
                                       ? true
                                       : false,
                                   child: Row(
                                     children: [
                                       poppinsText(
                                           maxLines: 2,
                                           txt:
                                           "Ready to Pick-up",
                                           fontSize: 13,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                       SizedBox(width: 4),
                                       Transform.scale(
                                           scale: 1.5,
                                           child: Switch(
                                             onChanged:
                                                 (value) {
                                               if (isSwitched ==
                                                   false) {
                                                 setState(() {
                                                   isSwitched =
                                                   true;
                                                   isSlided =
                                                   true;

                                                   statusChangeDilog(
                                                     "${snapshot.data?.data?.preOrders![index].status.toString()}",
                                                     "${snapshot.data?.data?.preOrders![index].orderitemsId == "" ? snapshot.data?.data?.preOrders![index].orderId : snapshot.data?.data?.preOrders![index].orderitemsId.toString()}",
                                                   );
                                                   textValue =
                                                   'Switch Button is ON';
                                                   isSwitched =
                                                   false;
                                                 });
                                               } else {
                                                 setState(() {
                                                   textValue =
                                                   'Switch Button is OFF';
                                                 });
                                               }
                                             },
                                             value: isSwitched,
                                             activeColor:
                                             AppConstant
                                                 .appColor,
                                             activeTrackColor:
                                             AppConstant
                                                 .appColorLite,
                                             inactiveThumbColor:
                                             Colors
                                                 .white70,
                                             inactiveTrackColor:
                                             Colors.green,
                                           ))
                                     ],
                                   ),
                                 ),
                                 Visibility(
                                   visible: snapshot
                                       .data
                                       ?.data
                                       ?.preOrders![
                                   index]
                                       .orderType ==
                                       "trial" &&
                                       snapshot
                                           .data
                                           ?.data
                                           ?.preOrders![
                                       index]
                                           .status ==
                                           "3" ||
                                       snapshot
                                           .data
                                           ?.data
                                           ?.preOrders![
                                       index]
                                           .orderType ==
                                           "package" &&
                                           snapshot
                                               .data
                                               ?.data
                                               ?.preOrders![
                                           index]
                                               .itemStatus ==
                                               "0"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 165,
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.black,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Row(
                                       crossAxisAlignment:
                                       CrossAxisAlignment
                                           .center,
                                       mainAxisAlignment:
                                       MainAxisAlignment
                                           .center,
                                       children: [
                                         poppinsText(
                                             maxLines: 1,
                                             txt:
                                             "Ready to pickup",
                                             fontSize: 13,
                                             color:
                                             Colors.white,
                                             textAlign:
                                             TextAlign
                                                 .center,
                                             weight: FontWeight
                                                 .w500),
                                         SizedBox(width: 2),
                                         Icon(Icons.check,
                                             color:
                                             Colors.white,
                                             size: 16,
                                             weight: 30,
                                             opticalSize: 20),
                                       ],
                                     ),
                                   ),
                                 ),
                                 Visibility(
                                   visible: (snapshot.data?.data?.preOrders![index].orderType == "trial" && (snapshot.data?.data?.preOrders![index].status == "9" || snapshot.data?.data?.preOrders![index].status == "2")) ||
                                       snapshot.data?.data?.preOrders![index].orderType == "package" &&snapshot.data?.data?.preOrders![index].itemStatus == "7" ||snapshot.data?.data?.preOrders![index].itemStatus == "10"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 100, //165
                                     decoration: BoxDecoration(
                                       boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],
                                       color: Colors.red,
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Center(
                                       child: poppinsText(
                                           maxLines: 1,
                                           txt: "Rejected",
                                           fontSize: 13,
                                           color: Colors.white,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                     ),
                                   ),
                                 ),
                                 Visibility(
                                   visible: (snapshot.data?.data?.preOrders![index].orderType == "trial" && (snapshot.data?.data?.preOrders![index].status == "6" )) ||
                                       snapshot.data?.data?.preOrders![index].orderType == "package" && snapshot.data?.data?.preOrders![index].itemStatus == "3"
                                       ? true
                                       : false,
                                   child: Container(
                                     height: 40,
                                     width: 100, //165
                                     decoration: BoxDecoration(
                                      /* boxShadow: [
                                         BoxShadow(
                                           color: Colors.grey,
                                           blurRadius: 3.0,
                                           offset: Offset(0,
                                               4), // Offset of the shadow
                                         ),
                                       ],*/
                                       color: Colors.green.withOpacity(0.9),
                                       borderRadius:
                                       BorderRadius
                                           .circular(20),
                                     ),
                                     child: Center(
                                       child: poppinsText(
                                           maxLines: 1,
                                           txt: "Delivered",
                                           fontSize: 13,
                                           color: Colors.white,
                                           textAlign: TextAlign
                                               .center,
                                           weight: FontWeight
                                               .w500),
                                     ),
                                   ),
                                 ),
                                 Expanded(
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment.end,
                                     mainAxisSize:
                                     MainAxisSize.max,
                                     children: [
                                       InkWell(
                                         onTap: () async{
                                           showAlertDialog(
                                               context,
                                               "${snapshot.data?.data?.preOrders![index].orderId!.toString()}",
                                               "${snapshot.data?.data?.preOrders![index].orderitemsId!.toString()}",
                                               "${snapshot.data?.data?.preOrders![index].orderNumber!.toString()}",
                                               "${snapshot.data?.data?.preOrders![index].pickupTime!.toString()}",
                                               "${snapshot.data?.data?.preOrders![index].orderNumber!.toString()}",
                                               "${snapshot.data?.data?.preOrders![index].orderTypes == "old" ? "old" : "new"}",
                                               "${snapshot.data?.data?.preOrders![index].orderType!}",
                                               "${snapshot.data?.data?.preOrders![index].deliveryDate!}",
                                               "${snapshot.data?.data?.preOrders![index].status!}",
                                               "${snapshot.data?.data?.preOrders![index].itemStatus!}",
                                               true);
                                         },
                                         child: Container(
                                           alignment: Alignment
                                               .center,
                                           height: 40,
                                           width: 100,
                                           decoration:
                                           BoxDecoration(
                                             boxShadow: [
                                               BoxShadow(
                                                 color: Colors
                                                     .grey,
                                                 // Shadow color
                                                 blurRadius:
                                                 3.0,
                                                 // Spread of the shadow
                                                 offset: Offset(
                                                     0,
                                                     4), // Offset of the shadow
                                               ),
                                             ],
                                             color:
                                             Colors.white,
                                             border: Border.all(
                                                 color: AppConstant
                                                     .appColor,
                                                 width: 1.5),
                                             borderRadius:
                                             BorderRadius
                                                 .circular(
                                                 10),
                                           ),
                                           child: Center(
                                             child: poppinsText(
                                                 maxLines: 1,
                                                 txt: "View order",
                                                 fontSize: 14,
                                                 color: AppConstant
                                                     .appColor,
                                                 textAlign:
                                                 TextAlign
                                                     .center,
                                                 weight:
                                                 FontWeight
                                                     .w400),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                             SizedBox(height: 10),
                           ],
                         ),
                     ),
                   ),
                       );
                 },
               ),
               SizedBox(height: 60),
             ],
           ),
         )
             :Column(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             Padding(
               padding: const EdgeInsets.only(top: 100.0),
               child: SvgPicture.asset("assets/images/noLiveOrder.svg"),
             ),
             poppinsText(
                 maxLines: 5,
                 txt: "There are no Orders",
                 fontSize: 16,
                 textAlign:
                 TextAlign.start,
                 weight:
                 FontWeight.w600),
           ],
         ):SizedBox()
       )
           : Center(
           child: CircularProgressIndicator(
               color: AppConstant.appColor))
     ],
   );
 }
          }),
    );
  }

  showAlertDialog(
    BuildContext context,
    String orderId,
    String orderItemsId,
    String subscriptionType,
    String pickupTime,
    String orderNumber,
    String orderTypes,
    String orderType,
    String diliveryDate,
    String status,
    String orderItemStatus,
    bool isUpcomingOrder,
  ) async {
    GetOrderDetailsData? orderDetails;
    orderDetails = await getOrderDetails(context, orderId, orderItemsId).then((value) {
      setState(() {
        //isViewLoading = false;
      });
      return value;
    });

    return orderDetails != null
        ? showDialog<void>(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              Future.delayed(Duration(seconds: 3), () {
                setState(() {});

              });
              return StatefulBuilder(builder: (context, setStat) {
                return Scaffold(
                  body: Container(
                    height: MediaQuery.of(context).size.height,
                    // * 0.75,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    padding:
                    EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      width: 2.0, color: Colors.orange),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Go Back",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.orange,
                                      fontFamily: AppConstant.fontRegular,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
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
                                      fontSize: 14,
                                      fontFamily: AppConstant.fontRegular,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Order Date:",
                                    style: TextStyle(
                                        fontFamily: AppConstant.fontRegular,
                                        color: Colors.black),
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
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Customer Name:",
                                    style: TextStyle(
                                        fontFamily: AppConstant.fontRegular,
                                        color: Colors.black),
                                  ),
                                ),
                                Text(
                                  "${orderDetails.customerName}",
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontRegular),
                                  maxLines: 1,
                                )
                              ],
                            ),
                            (isUpcomingOrder)
                                ? Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Delivery Date: ",
                                      style: TextStyle(
                                          fontFamily:
                                          AppConstant.fontRegular,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red),
                                    ),
                                    Text(
                                      "$diliveryDate",
                                      style: TextStyle(
                                          fontFamily:
                                          AppConstant.fontRegular,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red),
                                      maxLines: 1,
                                    )
                                  ],
                                )
                              ],
                            )
                                : Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                if (orderDetails.orderType != "package")
                                  SizedBox(height: 8),
                                if (orderDetails.orderType != "package")
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Delivery Date: ",
                                        style: TextStyle(
                                            fontFamily:
                                            AppConstant.fontRegular,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red),
                                      ),
                                      Text(
                                        "${orderDetails.order_now_delivery_date["date"]}",
                                        style: TextStyle(
                                            fontFamily:
                                            AppConstant.fontRegular,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red),
                                        maxLines: 1,
                                      )
                                    ],
                                  ),
                                if (orderDetails.orderType == "package")
                                  SizedBox(height: 8),
                                if (orderDetails.orderType == "package")
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Delivery From: ",
                                        style: TextStyle(
                                            fontFamily:
                                            AppConstant.fontRegular,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red),
                                      ),
                                      Text(
                                        "orderDetails.orderFrom",
                                        style: TextStyle(
                                            fontFamily:
                                            AppConstant.fontRegular,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red),
                                        maxLines: 1,
                                      )
                                    ],
                                  ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Pickup Time: ",
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontRegular,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red),
                                ),
                                Text(
                                  "$pickupTime",
                                  style: TextStyle(
                                      fontFamily: AppConstant.fontRegular,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red),
                                  maxLines: 1,
                                )
                              ],
                            ),
                            SizedBox(
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  orderDetails.itemsDetail!.isEmpty
                                      ? Text(
                                    orderDetails.packageName.toString(),
                                    style: TextStyle(
                                        fontFamily:
                                        AppConstant.fontRegular),
                                  )
                                      : Container(
                                    width: double.infinity,
                                    //color: Colors.blue,
                                    child: Column(
                                      children: [
                                        orderDetails.itemsDetail!.isEmpty
                                            ? Text(
                                          orderDetails.packageName
                                              .toString(),
                                          style: TextStyle(
                                              fontFamily:
                                              AppConstant
                                                  .fontRegular),
                                        )
                                            : ListView.builder(
                                          itemCount: orderDetails
                                              .itemsDetail!.length,
                                          shrinkWrap: true,
                                          scrollDirection:
                                          Axis.vertical,
                                          physics:
                                          NeverScrollableScrollPhysics(),
                                          //BouncingScrollPhysics(),
                                          itemBuilder:
                                              (context, index) {
                                            return Text(
                                              "${orderDetails!.itemsDetail?[index].quantity} x ${orderDetails.itemsDetail?[index].itemName}",
                                              style: TextStyle(
                                                  fontFamily:
                                                  AppConstant
                                                      .fontRegular),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
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
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   /* Text(
                                      "Special Instructions : ${orderDetails.specialInstruction ?? "N/A"}",
                                      style: TextStyle(
                                          fontFamily: AppConstant.fontRegular),
                                    ),
                                    SizedBox(
                                      width: 10,
                                      height: 10,
                                    ),*/
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.25),
                                                blurRadius: 30),
                                          ],
                                          border: Border.all(
                                            color: Color.fromARGB(
                                                255, 208, 207, 206),
                                          ),
                                          color: Colors.white),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Special Instructions : ",),
                                          Container(
                                            //color: Colors.blue,
                                            width: 130,
                                            child: Text(
                                                "${orderDetails.specialInstruction ?? "N/A"}",style: TextStyle(color: Colors.red),),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                      height: 10,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
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
                                            "Subscription : ${orderDetails.package}",
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
                                            "Packing Charges : ${orderDetails.packagingCharge}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily:
                                                AppConstant.fontBold),
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
                                             height: isShow?0:10,
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
                                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                                              "Reason : ${orderDetails. reason}",
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
                                                  SizedBox(
                                                    height: isShow?0:10,
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Order Status Update",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontFamily: AppConstant.fontBold),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Visibility(
                                    visible:
                                    orderType == "trial" && status == "0" ||
                                        orderType == "package" &&
                                            orderItemStatus == "5"
                                        ? true
                                        : false,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            await rejectDialog(
                                                orderNumber: orderNumber,
                                                orderID: orderTypes == "old"
                                                    ? orderItemsId
                                                    : orderId,
                                                subscriptionType: orderTypes,
                                                isFromDetails: false);
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 110,
                                            margin: EdgeInsets.only(
                                                left: 10, bottom: 10),
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 242, 106, 96),
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "REJECT",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily:
                                                    AppConstant.fontBold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            await acceptDialog(
                                                orderNumber: orderNumber,
                                                orderID: orderTypes == "old"
                                                    ? orderItemsId
                                                    : orderId,
                                                subscriptionType: orderTypes,
                                                isFromDetails: false,
                                                instructions: orderDetails?.specialInstruction);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 10, bottom: 10),
                                            height: 40,
                                            width: 110,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 118, 214, 121),
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "ACCEPT",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily:
                                                    AppConstant.fontBold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                    orderType == "trial" && status == "1" ||
                                        orderType == "package" &&
                                            orderItemStatus == "6"
                                        ? true
                                        : false,
                                    child: Row(
                                      children: [
                                        poppinsText(
                                            maxLines: 2,
                                            txt: "Ready to Pick-up",
                                            fontSize: 13,
                                            textAlign: TextAlign.center,
                                            weight: FontWeight.w500),
                                        SizedBox(width: 4),
                                        Transform.scale(
                                            scale: 1.5,
                                            child: Switch(
                                              onChanged: (value) async {
                                                if (isSwitched == false) {
                                                  setState(() async {
                                                    isSwitched = true;
                                                    isSlided = true;
                                                    Navigator.of(context).pop();
                                                    await statusChangeDilog(
                                                      "${status.toString()}",
                                                      //snapshot.data!.data![index]..status.toString(),
                                                      "${orderItemsId.toString()}",
                                                    );
                                                    //snapshot.data!.data[index].orderItemsId);
                                                    textValue =
                                                    'Switch Button is ON';
                                                    isSwitched = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    textValue =
                                                    'Switch Button is OFF';
                                                  });
                                                }
                                                setState(() {});
                                              },
                                              value: isSwitched,
                                              activeColor: AppConstant.appColor,
                                              activeTrackColor:
                                              AppConstant.appColorLite,
                                              inactiveThumbColor:
                                              Colors.white70,
                                              inactiveTrackColor: Colors.green,
                                            ))
                                        /*Switch(
                                                      activeColor: switchColor,
                                                      inactiveTrackColor:
                                                          Colors.grey,
                                                      thumbColor:
                                                          MaterialStateProperty
                                                              .all(
                                                                  Colors.white),
                                                      value: _isSounIndianMeal,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _isSounIndianMeal =
                                                              value;
                                                        });
                                                      },
                                                    ),*/
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                    orderType == "trial" && status == "3" ||
                                        orderType == "package" &&
                                            orderItemStatus == "0"
                                        ? true
                                        : false,
                                    child: Container(
                                      height: 40,
                                      width: 165,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 3.0,
                                            offset: Offset(
                                                0, 4), // Offset of the shadow
                                          ),
                                        ],
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          poppinsText(
                                              maxLines: 1,
                                              txt: "Ready to pickup",
                                              fontSize: 13,
                                              color: Colors.white,
                                              textAlign: TextAlign.center,
                                              weight: FontWeight.w500),
                                          SizedBox(width: 2),
                                          Icon(Icons.check,
                                              color: Colors.white,
                                              size: 16,
                                              weight: 30,
                                              opticalSize: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                    orderType == "trial" && status == "9" ||
                                        status == "2" ||
                                        orderType == "package" &&
                                            orderItemStatus == "7" ||
                                        orderItemStatus == "10"
                                        ? true
                                        : false,
                                    child: Container(
                                      height: 40,
                                      width: 100, //165
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 3.0,
                                            offset: Offset(
                                                0, 4), // Offset of the shadow
                                          ),
                                        ],
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: poppinsText(
                                            maxLines: 1,
                                            txt: "Rejected",
                                            fontSize: 13,
                                            color: Colors.white,
                                            textAlign: TextAlign.center,
                                            weight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                );
              },);
            },
          )
        : Container();
  }

  Future<BeanOrderAccepted?> orderAccepted(
      String orderId, String subscriptionType) async {
    BeanLogin userBean = await Utils.getUser();

    FormData from = FormData.fromMap({
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
      "order_id": orderId,
      "subscription_type": subscriptionType
    });
    BeanOrderAccepted? bean =
        await ApiProvider().orderAccept(orderId, subscriptionType);

    if (bean.status == true) {
      setState(() {
        // _pullRefresh();
      });
      Navigator.of(context, rootNavigator: true).pop();
      return bean;
    } else {
      throw Exception("Something went wrong");
    }
    return null;
  }

  Future<BeanOrderRejected?> orderRejected(
      String orderId, String subscriptionType) async {
    BeanLogin userBean = await Utils.getUser();
    FormData from = FormData.fromMap({
      "kitchen_id": userBean.data!.id,
      "token": "123456789",
      "order_id": orderId,
      "subscription_type": subscriptionType
    });
    BeanOrderRejected bean =
        await ApiProvider().orderReject(orderId, subscriptionType);
    if (bean.status == true) {
      Navigator.of(context, rootNavigator: true).pop();

      //stopRing();
      if (bean.status == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderScreen(true, 4),
          ),
        );

        return bean;
      } else {
        throw Exception("Something went wrong");
      }
    }
  }

  acceptDialog(
      {required String orderNumber,
      required orderID,
      required subscriptionType,
      required bool isFromDetails,
        required instructions}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Container(
            //height: 200,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //color:Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Image.asset(
                        Res.ic_cross_image,
                        fit: BoxFit.fill,
                        width: 12,
                        height: 12,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Image.asset(
                Res.ic_accept_dialog,
                fit: BoxFit.fill,
                //width: 16,
                height: 120,
              ),
              SizedBox(
                height: 24,
              ),
              instructions==""?SizedBox():
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 8),
                margin: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color:
                        Colors.black.withOpacity(.25),
                        blurRadius: 30),
                  ],
                  border: Border.all(
                    color: Color.fromARGB(
                        255, 208, 207, 206),
                  ),
                  color: Color.fromRGBO(255, 227, 202, 1.0),),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/note2.svg',),
                    Text(
                      " Instructions : ",
                      style: TextStyle( color: Color.fromRGBO(177, 0, 0, 1.0),
                          fontWeight: FontWeight.w600),

                    ),Container(
                      //color: Colors.red,
                      width: 130,
                      child: Padding(
                        padding: const EdgeInsets.only(top:  2.0),
                        child: Text(
                          "$instructions",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(96, 116, 125, 1.0),
                              fontWeight: FontWeight.w600),

                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                " Are you sure you want to accept\nthis order?",
                textAlign: TextAlign.center,
                style:
                TextStyle(
                    color: Color.fromRGBO(96, 116, 125, 1.0),
                    fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          'NO',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: AppConstant.fontRegular),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  InkWell(
                    onTap: () {
                      orderAccepted(orderID, subscriptionType).then((value) {
                        setState(() {
                          // _pullRefresh();
                        });
                        if (isFromDetails) {
                          Navigator.pop(context);
                          successfullyacceptDialog(orderNumber);
                        } else {
                          successfullyacceptDialog(orderNumber);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppConstant.appColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          'YES',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: AppConstant.fontRegular),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ]),
          ),
        );
      },
    );
  }

  rejectDialog(
      {required String orderNumber,
      required orderID,
      required subscriptionType,
      required bool isFromDetails}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Container(
            //height: 200,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //color:Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Image.asset(
                        Res.ic_cross_image,
                        fit: BoxFit.fill,
                        width: 12,
                        height: 12,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Image.asset(
                Res.ic_accept_dialog,
                fit: BoxFit.fill,
                //width: 16,
                height: 170,
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                " Are you sure you want \n to reject the order ??",
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontFamily: AppConstant.fontBold, fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          'NO',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: AppConstant.fontRegular),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  InkWell(
                    onTap: () {
                      orderRejected(orderID, subscriptionType).then((value) {
                        setState(() {
                          print('===-=-=-=-=-=-=-=-=-=->${value?.status}');
                        });
                        if (isFromDetails) {
                          Navigator.of(context).pop();
                          // Navigator.pop(context);
                          successfullyrejactDialog(orderNumber);
                        } else {
                          successfullyrejactDialog(orderNumber);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppConstant.appColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          'YES',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: AppConstant.fontRegular),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
            ]),
          ),
        );
      },
    );
  }

  successfullyacceptDialog(
    String orderNumber,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Container(
            //height: 200,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //color:Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Image.asset(
                        Res.ic_cross_image,
                        fit: BoxFit.fill,
                        width: 12,
                        height: 12,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Image.asset(
                Res.ic_successfully_accept,
                fit: BoxFit.fill,
                //width: 16,
                height: 170,
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                "Order Number : $orderNumber \nis successfully accepted",
                style: TextStyle(fontFamily: AppConstant.fontRegular),
              ),
              SizedBox(
                height: 24,
              ),
            ]),
          ),
        );
      },
    );
  }

  successfullyrejactDialog(
    String orderNumber,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(false);
        });
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Container(
            //height: 200,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //color:Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Image.asset(
                        Res.ic_cross_image,
                        fit: BoxFit.fill,
                        width: 12,
                        height: 12,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Image.asset(
                Res.ic_successfully_accept,
                fit: BoxFit.fill,
                //width: 16,
                height: 170,
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                "Order Number : $orderNumber \nis successfully rejected",
                style: TextStyle(fontFamily: AppConstant.fontRegular),
              ),
              SizedBox(
                height: 24,
              ),
            ]),
          ),
        );
      },
    );
  }

  statusChangeDilog(
    String status,
    String orderItemId,
  ) {
    final LiveOrderModel =
        Provider.of<LiveOrderController>(context, listen: false);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final activeModel =
            Provider.of<LiveOrderController>(context, listen: false);
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Container(
              //height: 200,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //color:Colors.red,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset(
                          Res.ic_cross_image,
                          fit: BoxFit.fill,
                          width: 12,
                          height: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Image.asset(
                  Res.ic_pick_up_image,
                  fit: BoxFit.fill,
                  //width: 16,
                  height: 130,
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  " Are you sure you want to \npick-up the order?",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontFamily: AppConstant.fontBold, fontSize: 18),
                ),
                SizedBox(
                  height: 14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'NO',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: AppConstant.fontRegular),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    InkWell(
                      onTap: () {
                        print(
                            "---------------------orderItemId>${orderItemId.toString()}");
                        Navigator.of(context).pop();
                        readyToPickUpOrder(context, orderItemId)
                            .then((value) async {
                          //setState(() {
                          LiveOrderModel.live(/*"all"*/);
                          setState;
                          //});
                        });
                        //Navigator.of(context).pop();
                        //Navigator.pop(context, true);
                        // Navigator.pop(context, true);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppConstant.appColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'YES',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: AppConstant.fontRegular),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
              ]),
            ),
          );
        });
      },
    ).then((_) => setState(() {}));
  }

  Future<ReadyToPickupOrder?> readyToPickUpOrder(
      BuildContext context, String orderItemsId) async {
    try {
      FormData from = FormData.fromMap({
        "kitchen_id": userId.toString(),
        "token": '123456789',
        "orderitems_id": orderItemsId,
      });

      ReadyToPickupOrder? bean =
          await ApiProvider().readyToPickupOrder(orderItemsId);
      final liveOrdersController =
          Provider.of<LiveOrderController>(context, listen: false);

      if (bean.status == true) {
        liveOrdersController.live(/*"all"*/).then((value) {
          setState(() {
            data = value.data!.orders;
          });
        });
        return bean;
      } else {
        throw Exception("Something went wrong");
      }
    } on HttpException catch (exception) {
      print(exception);
    } catch (exception) {}
    return null;
  }
}
