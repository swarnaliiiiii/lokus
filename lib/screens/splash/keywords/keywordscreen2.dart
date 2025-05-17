import 'package:flutter/material.dart';
import 'package:lokus/domains/constants/appcolors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lokus/screens/splash/keywords/keywordscreen.dart';
import 'package:lokus/widgets/nav_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Keywordscreen2 extends StatefulWidget {
  const Keywordscreen2({Key? key}) : super(key: key);

  @override
  State<Keywordscreen2> createState() => _Keywordscreen2State();
}

class _Keywordscreen2State extends State<Keywordscreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dashColor,
      body: Column(
        children: [
          CustomNav(
            icon: Icons.arrow_back,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "What's your \n travel length?",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: const Color.fromARGB(255, 23, 70, 109),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
