import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kLightYellowColor = Color(0x7FFCC647);
const kYellowColor = Color(0xFFFCC546);
const kDividerColor = Color(0xffEFEFEF);
const kBorderColor = Color(0xff6F767E);

const kTextPrimary = Color(0xFF33363F);
const kgrey = Color(0xFF3A5160);
const kSilverNight = Color(0xFFB0B5B9);

Widget poppinsText(
        {required String? txt,
        required double? fontSize,
        Color color = kTextPrimary,
        FontWeight weight = FontWeight.w600,
        double? letterSpacing,
        int maxLines = 1,
        TextAlign? textAlign}) =>
    Text(
      txt!,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: weight,
            letterSpacing: letterSpacing),
      ),
    );

class AppTextStyles {
  // Poppins TextStyles
  static TextStyle normalText = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF2F3443),
  );
  static TextStyle titleText = GoogleFonts.poppins(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF2F3443),
  );
  static TextStyle boldText = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: const Color(0xFF2F3443),
  );
  static TextStyle semiBoldText = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF2F3443),
  );
}














/*TabBar(
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                    color: AppConstant.appColor,
                  ),
                  isScrollable: true,
                  labelStyle:
                  GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                  indicatorSize: TabBarIndicatorSize.label,
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Container(
                      decoration: BoxDecoration(
                          color: (_tabController!.index == 0)
                              ? Colors.grey
                              : AppConstant.appColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Tab(
                          text: 'Request',
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: (_tabController!.index == 1)
                              ? AppConstant.appColor
                              : AppConstant.appColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Tab(
                          text: 'Active',
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: (_tabController!.index == 2)
                              ? AppConstant.appColor
                              : AppConstant.appColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Tab(
                          text: 'Upcoming',
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: (_tabController!.index == 3)
                              ? AppConstant.appColor
                              : AppConstant.appColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Tab(
                          text: 'Order History',
                        ),
                      ),
                    ),
                  ],
                ),*/