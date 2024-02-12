import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitchen/model/package_detail_model.dart';
import 'package:kitchen/network/package_detail_provider.dart';
import 'package:kitchen/utils/constant/ui_constants.dart';
import 'package:provider/provider.dart';
import '../utils/Constants.dart';

const kYellowColor = Color(0xFFFCC546);

class PackageDetailScreen extends StatefulWidget {
  final packageId;
  final userID;

  const PackageDetailScreen({Key? key, this.packageId, this.userID})
      : super(key: key);

  @override
  State<PackageDetailScreen> createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen>
    with TickerProviderStateMixin {
  Color divColor = Color.fromRGBO(47, 52, 67, 0.3 * 255);
  Color textColor = Color.fromRGBO(47, 52, 67, 0.3 * 255);
  List day = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  List price = ["1000", "2000", "3000", "4000", "5000", "6000", "7000"];
  List cat = [
    "2 paneer pasanda veg clear soup",
    "veg Sweet Corn Soup",
    "veg clear soup veg rice",
    "paneer pasanda veg rice",
    "paneer pasanda",
    "paneer pasanda veg rice",
    "veg Sweet Corn Soup"
  ];
  late TabController _tabController;
  bool isWeekly = false;
  bool isMonthly = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final PackageDetail =
        Provider.of<PackageDetailProvider>(context, listen: false);
    return Scaffold(
      body: FutureBuilder<PackageDetailsModel?>(
        future: PackageDetail.packageDetail(
            user_id: widget.userID, package_id: widget.packageId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint("Erroe 44");
            print(snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            final data = snapshot.data!.data?.packageDetail?.first;
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (snapshot.data!.data!.mealtype == "0")
                              SvgPicture.asset(
                                'assets/images/leaf.svg',
                                width: 30,
                              ),
                            if (snapshot.data!.data!.mealtype == "1")
                              SvgPicture.asset(
                                'assets/images/chicken.svg',
                                width: 30,
                              ),
                            if (snapshot.data!.data!.mealtype == "2")
                              SvgPicture.asset(
                                'assets/images/both.svg',
                                width: 30,
                              ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              snapshot.data!.data!.packagename.toString(),
                              style: AppTextStyles.semiBoldText,
                            ),
                          ],
                        ),
                        InkResponse(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            "assets/images/cancelx.svg",
                            height: 27,
                            width: 27,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      color: divColor,
                      thickness: 1.5,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 35,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(4, 3),
                                blurRadius: 3.0,
                                color: Colors.black12),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                        child: TabBar(
                          onTap: (value) {
                            isMonthly=!isMonthly;
                            setState(() {});
                          },
                          controller: _tabController,
                          physics: const BouncingScrollPhysics(),
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: kYellowColor,
                          ),
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.black,
                          labelStyle: AppTextStyles.normalText.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                          isScrollable: true,
                          tabs: [
                            Tab(
                              text: "Weekly",
                            ),
                            Tab(
                              text: "Monthly",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: RawScrollbar(
                      thumbColor: kYellowColor,
                      radius: const Radius.circular(20),
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.data!.packageDetail!.length,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${snapshot.data!.data!.packageDetail![index].daysName}",
                                  style: AppTextStyles.titleText
                                      .copyWith(height: 2),
                                ),
                                Text(
                                  "₹ ${isMonthly?snapshot.data!.data!.packageDetail![index].monthlyMealPrice??"":snapshot.data!.data!.packageDetail![index].weeklyMealPrice??""}",
                                 // "₹ ${price[index]}",
                                  style: AppTextStyles.normalText
                                      .copyWith(height: 2),
                                ),
                                Text(
                                  "${snapshot.data!.data!.packageDetail![index].itemName}",
                                  style: AppTextStyles.normalText
                                      .copyWith(height: 2),
                                ),
                                /*...data.packageDetail![index].items!.map(
                                (e) => Text(
                              e.itemname ?? "",
                              style: AppTextStyles.normalText.copyWith(
                                fontSize: 14,
                                height: 1.3,
                              ),
                            ),*/
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 7,
                            );
                          }),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 10, left: 10, top: 10),
                    child: Divider(
                      color: divColor,
                      thickness: 1.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Weekly(7 days)",
                                style: AppTextStyles.normalText
                                    .copyWith(height: 2),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: AppConstant.appColor,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0, vertical: 6),
                                  child: Text(
                                    "Rs ${snapshot.data!.data!.weeklyprice.toString().replaceAll(".00", "")}/-",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Monthly(30 days)",
                                style: AppTextStyles.normalText
                                    .copyWith(height: 2),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: AppConstant.appColor,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0, vertical: 6),
                                  child: Text(
                                    "Rs ${snapshot.data!.data!.monthlyprice.toString().replaceAll(".00", "")}/-",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                ]);
          }
          return const Center(
            child: CircularProgressIndicator(
              color: AppConstant.appColor,
            ),
          );
        },
      ),
    );
  }
}
