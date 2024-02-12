import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/Order/RequestScreen.dart';
import 'package:kitchen/model/notificationsModel.dart';
import 'package:kitchen/utils/Constants.dart';
import 'package:provider/provider.dart';

import '../../../network/NotificationRepo.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late int _totalNotifications;
  late final FirebaseMessaging _messaging;

  @override
  void initState() {
    super.initState();

    _totalNotifications = 0;
  }

  @override
  Widget build(BuildContext context) {
    final notifyModel = Provider.of<NotifyModel>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: AppConstant.appColor,
          title: Text(
            'Notifications',
            style: TextStyle(fontFamily: AppConstant.fontRegular),
          ),
        ),
        body: FutureBuilder<NotificationModel>(
            future: notifyModel.getNotifications(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null
                  ? ListView.builder(
                      padding: EdgeInsets.only(
                        bottom: 100,
                        left: 12,
                        right: 12,
                        top: 12,
                      ),
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.data.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestScreen(
                                  fromDashboard:
                                      true, /*currentTablSelected: false,*/
                                ),
                              ),
                            );
                          },
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      child: Image.network(
                                        snapshot.data!.data[index].senderImage,
                                        fit: BoxFit.fill,
                                      )),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.data[index].message
                                            .toString(),
                                        softWrap: true,
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 12,
                                            fontFamily: AppConstant.fontRegular,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        snapshot.data!.data[index].time,
                                        style: TextStyle(
                                            fontFamily: AppConstant.fontRegular,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ]),
                                SizedBox(
                                  height: 6,
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                              ]),
                        );
                      })
                  : Center(
                      child: Text(
                      "No Notifications",
                      style: TextStyle(fontFamily: AppConstant.fontRegular),
                    ));
            }));
  }
}

class NotificationFirst extends StatefulWidget {
  final bool? fromDashboard;
  const NotificationFirst({
    Key? key,
    this.fromDashboard = false,
  }) : super(key: key);

  @override
  State<NotificationFirst> createState() => _NotificationFirstState();
}

class _NotificationFirstState extends State<NotificationFirst> {
  late int _totalNotifications;
  late final FirebaseMessaging _messaging;

  @override
  void initState() {
    super.initState();
    _totalNotifications = 0;
  }

  @override
  Widget build(BuildContext context) {
    final notifyModel = Provider.of<NotifyModel>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appColor,
          title: Text(
            'Notifications',
            style: TextStyle(fontFamily: AppConstant.fontRegular),
          ),
        ),
        body: FutureBuilder<NotificationModel>(
            future: notifyModel.getNotifications(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null
                  ? ListView.builder(
                      padding: EdgeInsets.only(
                        bottom: 100,
                        left: 12,
                        right: 12,
                        top: 12,
                      ),
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.data.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestScreen(
                                  fromDashboard:
                                      true, /*currentTablSelected: false,*/
                                ),
                              ),
                            );
                          },
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      child: Image.network(
                                        snapshot.data!.data[index].senderImage,
                                        fit: BoxFit.fill,
                                      )),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.data[index].message
                                            .toString(),
                                        softWrap: true,
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 12,
                                            fontFamily: AppConstant.fontRegular,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        snapshot.data!.data[index].time,
                                        style: TextStyle(
                                            fontFamily: AppConstant.fontRegular,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ]),
                                SizedBox(
                                  height: 6,
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                              ]),
                        );
                      })
                  : Center(
                      child: Text(
                      "No Notifications",
                      style: TextStyle(fontFamily: AppConstant.fontRegular),
                    ));
            }));
  }
}

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: new BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$totalNotifications',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
