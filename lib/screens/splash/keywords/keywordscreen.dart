import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lokus/domains/constants/appcolors.dart';
import 'package:lokus/screens/splash/splashscreen.dart';
import 'package:lokus/widgets/nav_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lokus/widgets/square.dart';

class Keywordscreen extends StatefulWidget {
  const Keywordscreen({Key? key}) : super(key: key);

  @override
  State<Keywordscreen> createState() => _KeywordscreenState();
}

class _KeywordscreenState extends State<Keywordscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.keywordColor,
      body: Column(
        children: [
          CustomNav(
            icon: Icons.arrow_back,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SplashScreen(),
                ),
              );
            },
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.only(left: 20.r),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "What's your \n budget?",
                style: GoogleFonts.manrope(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: const Color.fromARGB(255, 23, 70, 109),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          // Wrap ListView in a Container with height constraint
          Container(
            height: 500.h, // Fixed height for the ListView section
            child: ListView(
              children: [
                Square(),
                Square(),
                Square(),
                Square(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}