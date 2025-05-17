import 'package:flutter/material.dart';
import 'package:lokus/domains/constants/appcolors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lokus/screens/splash/keywords/keywordscreen.dart';
import 'package:lokus/widgets/nav_bar.dart';
import 'package:lokus/widgets/square.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lokus/screens/splash/keywords/keywordscreen3.dart';
import 'dart:async';

class Keywordscreen2 extends StatefulWidget {
  const Keywordscreen2({Key? key}) : super(key: key);

  @override
  State<Keywordscreen2> createState() => _Keywordscreen2State();
}

class _Keywordscreen2State extends State<Keywordscreen2> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Keywordscreen3()));
    });
  }

  final List<String> _durationOptions = [
    'Weekend Getaway',
    'Short Trip',
    'Week-long Trip',
    'Extended Trip',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dashColor,
      body: Column(
        children: [
          CustomNav(
            icon: Icons.arrow_back,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Keywordscreen(),
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 20.r),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "What's your\ntravel length?",
                style: GoogleFonts.manrope(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: const Color.fromARGB(255, 23, 70, 109),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            height: 500.h,
            width: double.infinity,
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return Square(
                    child: _durationOptions[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
