import 'package:flutter/material.dart';
import 'package:lokus/domains/constants/appcolors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lokus/screens/splash/keywords/keywordscreen.dart';
import 'package:lokus/widgets/nav_bar.dart';
import 'package:lokus/widgets/square.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Keywordscreen3 extends StatefulWidget {
  const Keywordscreen3({Key? key}) : super(key: key);

  @override
  State<Keywordscreen3> createState() => _Keywordscreen3State();
}

class _Keywordscreen3State extends State<Keywordscreen3> {
  final List<String> _peopleOptions = [
    'Solo Traveler',
    'Couple',
    'Family of 4',
    'Group',
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
                "What's your\nperson count?",
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
                    child: _peopleOptions[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
