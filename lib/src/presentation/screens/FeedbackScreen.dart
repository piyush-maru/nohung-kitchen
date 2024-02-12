import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kitchen/model/GetFeedback.dart';
import 'package:kitchen/src/presentation/screens/DashboardScreen.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../../network/Feedback_model/Feedback_model.dart';
import '../../../network/OrderRepo/order_request_model.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  Timer? timer;
  @override
  void initState() {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final feedbackModel = Provider.of<FeedBackModel>(context, listen: false);
    return Scaffold(
        backgroundColor: AppConstant.appColor,
        appBar: AppBar(
          backgroundColor: AppConstant.appColor,
          leading: BackButton(
            color: Colors.white,
          ),
          title: Text(
            "Feedback/Reviews",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: AppConstant.fontBold),
          ),
          elevation: 0,
        ),
        body: /*Consumer<FeedBackModel>(builder: (context, feedbackModel, child) {
          return*/
            Container(
          // margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(14),
              topLeft: Radius.circular(14),
            ),
          ),
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: FutureBuilder<GetFeedback?>(
                  future: feedbackModel.getFeedback(),
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                /*Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Overall Rating",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: AppConstant.fontBold,
                                          fontSize: 19),
                                    ),
                                  ),
                                ),*/
                                Center(
                                    child: Padding(
                                  child: Text(
                                    snapshot.data!.data!.totalrating
                                        .toString() /*snapshot.data!.data.totalrating*/,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: AppConstant.fontBold,
                                        fontSize: 20),
                                  ),
                                  padding: EdgeInsets.only(top: 16),
                                )),
                                Center(
                                  child: RatingBarIndicator(
                                    rating: double.parse(snapshot
                                        .data!.data!.totalrating
                                        .toString()),
                                    // rating: rating,
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 14, top: 10),
                                    child: Text(
                                      "Based on " +
                                          snapshot.data!.data!.totalreview
                                              .toString() +
                                          " review",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontFamily: AppConstant.fontRegular),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 35,
                                ),
                                /*Row(
                                children: [
                                  Text("Excellent", style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: AppConstant.fontRegular)),
                                  LinearPercentIndicator(
                                    width: 200.0,
                                    lineHeight: 6.0,
                                    // percent: (excellent / review),
                                    percent: double.parse(snapshot.data!.data.excellent) / 100,
                                    backgroundColor: Colors.grey.shade300,
                                    progressColor: Color(0xff7EDABF),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text("Good", style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: AppConstant.fontRegular)),
                                  LinearPercentIndicator(
                                    width: 200.0,
                                    lineHeight: 6.0,
                                    percent: int.parse(snapshot.data!.data.veryGood) / 100,
                                    backgroundColor: Colors.grey.shade300,
                                    progressColor: Color(0xffFDD303),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text("Average", style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: AppConstant.fontRegular)),
                                  LinearPercentIndicator(
                                    width: 200.0,
                                    lineHeight: 6.0,
                                    percent: int.parse(snapshot.data!.data.good) / 6,
                                    backgroundColor: Colors.grey.shade300,
                                    progressColor: Color(0xffBEE8FF),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text("Fair", style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: AppConstant.fontRegular)),
                                  LinearPercentIndicator(
                                    width: 200.0,
                                    lineHeight: 6.0,
                                    percent: int.parse(snapshot.data!.data.fair) / 6,
                                    backgroundColor: Colors.grey.shade300,
                                    progressColor: Color(0xffBEE8FF),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text("Poor", style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: AppConstant.fontRegular)),
                                  LinearPercentIndicator(
                                    width: 200.0,
                                    lineHeight: 6.0,
                                    //percent: (poor / review),
                                    percent: int.parse(snapshot.data!.data.poor) / 6,
                                    backgroundColor: Colors.grey.shade300,
                                    progressColor: Color(0xffFCA896),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),*/

                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        snapshot.data!.data!.feedback!.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: snapshot
                                                              .data!
                                                              .data!
                                                              .feedback![index]
                                                              .customerPhoto ==
                                                          null
                                                      ? Image(
                                                          image: AssetImage(
                                                            "assets/images/icon_profile.jpg",
                                                          ),
                                                          fit: BoxFit.fill,
                                                          height: 20,
                                                          width: 20,
                                                        )
                                                      : Image.network(
                                                          snapshot
                                                              .data!
                                                              .data!
                                                              .feedback![index]
                                                              .customerPhoto!,
                                                          height: 40,
                                                          width: 40,
                                                        )),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Text(
                                                snapshot
                                                            .data!
                                                            .data!
                                                            .feedback![index]
                                                            .customerName ==
                                                        null
                                                    ? " "
                                                    : "${snapshot.data!.data!.feedback![index].customerName}",
                                                style: TextStyle(
                                                    overflow: TextOverflow.fade,
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontFamily:
                                                        AppConstant.fontBold),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Spacer(),
                                              Text(
                                                "(Order ID: ${snapshot.data!.data!.feedback![index].orderNumber.toString()})",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontFamily:
                                                        AppConstant.fontBold),
                                                softWrap: false,
                                              ),
                                            ]),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: 50, right: 6),
                                                child: Row(children: [
                                                  RatingBarIndicator(
                                                    rating: double.parse(
                                                        snapshot
                                                            .data!
                                                            .data!
                                                            .feedback![index]
                                                            .rating
                                                            .toString()),
                                                    itemCount: 5,
                                                    itemSize: 20.0,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    snapshot
                                                        .data!
                                                        .data!
                                                        .feedback![index]
                                                        .createdtime
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 14,
                                                        fontFamily: AppConstant
                                                            .fontRegular),
                                                  )
                                                ])),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 50),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                  ReadMoreText(
                                                    "${snapshot.data!.data!.feedback![index].message}",
                                                  trimLines: 2,
                                                  colorClickableText: Colors.pink,
                                                  trimMode: TrimMode.Line,
                                                  trimCollapsedText: 'Show more',
                                                  trimExpandedText: '',
                                                 // lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                  moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                ),
                                                      /*Text(
                                                        "${snapshot.data!.data!.feedback![index].message}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        softWrap: false,
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              AppConstant
                                                                  .fontRegular,
                                                        ),
                                                      ),*/
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 0,
                                                                    top: 8),
                                                            child: Text(
                                                              "Food Quality",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      AppConstant
                                                                          .fontBold),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 6,
                                                                    top: 6),
                                                            child: Icon(
                                                              snapshot
                                                                          .data!
                                                                          .data!
                                                                          .feedback![
                                                                              index]
                                                                          .foodquality ==
                                                                      '1'
                                                                  ? Icons
                                                                      .thumb_up
                                                                  : Icons
                                                                      .thumb_down,
                                                              color: snapshot
                                                                          .data!
                                                                          .data!
                                                                          .feedback![
                                                                              index]
                                                                          .foodquality ==
                                                                      '1'
                                                                  ? Colors
                                                                      .blue[200]
                                                                  : Colors.red
                                                                      .withOpacity(
                                                                          0.60),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    top: 8),
                                                            child: Text(
                                                              "Taste",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      AppConstant
                                                                          .fontBold),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 6,
                                                                    top: 6),
                                                            child: Icon(
                                                              snapshot
                                                                          .data!
                                                                          .data!
                                                                          .feedback![
                                                                              index]
                                                                          .taste ==
                                                                      '1'
                                                                  ? Icons
                                                                      .thumb_up
                                                                  : Icons
                                                                      .thumb_down,
                                                              color: snapshot
                                                                          .data!
                                                                          .data!
                                                                          .feedback![
                                                                              index]
                                                                          .taste ==
                                                                      '1'
                                                                  ? Colors
                                                                      .blue[200]
                                                                  : Colors.red
                                                                      .withOpacity(
                                                                          0.60),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    top: 8),
                                                            child: Text(
                                                              "Quantity",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      AppConstant
                                                                          .fontBold),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 6,
                                                                    top: 6),
                                                            child: Icon(
                                                              snapshot
                                                                          .data!
                                                                          .data!
                                                                          .feedback![
                                                                              index]
                                                                          .quantity ==
                                                                      '1'
                                                                  ? Icons
                                                                      .thumb_up
                                                                  : Icons
                                                                      .thumb_down,
                                                              color: snapshot
                                                                          .data!
                                                                          .data!
                                                                          .feedback![
                                                                              index]
                                                                          .quantity ==
                                                                      '1'
                                                                  ? Colors
                                                                      .blue[200]
                                                                  : Colors.red
                                                                      .withOpacity(
                                                                          0.60),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ])),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Divider(
                                              height: 1,
                                              color: Colors.black,
                                            ),
                                            SizedBox(
                                              height: 6,
                                            )
                                          ]);
                                    }),
                              SizedBox(
                                height: 65,
                              ),
                                /*Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: Text(
                                                          snapshot.data!.data!.feedback![index].customerName == null ? " " : snapshot.data!.data!.feedback![index].customerName.toString(),
                                                          style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.050, fontFamily: AppConstant.fontBold),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.10,
                                                      ),
                                                      FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: Text(
                                                          "(Order ID: ${snapshot.data!.data!.feedback![index].orderId.toString()})",
                                                          style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.050, fontFamily: AppConstant.fontBold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: MediaQuery.of(context).size.height * 0.01,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: RatingBarIndicator(
                                                          rating: double.parse(snapshot.data!.data!.feedback![index].rating.toString()),
                                                          itemCount: 5,
                                                          itemSize: 20.0,
                                                          physics: BouncingScrollPhysics(),
                                                          itemBuilder: (context, _) => Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.08,
                                                      ),
                                                      FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: Text(
                                                          snapshot.data!.data!.feedback![index].createdtime.toString(),
                                                          style: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: AppConstant.fontRegular),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: MediaQuery.of(context).size.height * 0.01,
                                                  ),*/
                              ])
                        : Center(
                            child: Text(
                              "No Review Found",
                              style: TextStyle(
                                  fontFamily: AppConstant.fontRegular),
                            ),
                          );
                  }),
            ),
          ),
        ));
  }
}
