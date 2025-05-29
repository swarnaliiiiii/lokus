import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lokus/domains/constants/appcolors.dart';
import 'package:lokus/screens/splash/splashscreen.dart';
import 'package:lokus/widgets/nav_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lokus/widgets/square.dart';
import 'package:lokus/screens/splash/keywords/keywordscreen2.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Keywordscreen extends StatefulWidget {
  const Keywordscreen({Key? key}) : super(key: key);

  @override
  State<Keywordscreen> createState() => _KeywordscreenState();
}

class _KeywordscreenState extends State<Keywordscreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   Timer(Duration(seconds: 3), () {
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => Keywordscreen2()));
  //   });
  // }

  final List<String> _budgetOptions = [
    'Budget',
    'Moderate',
    'Comfortable',
    'Premium',
  ];

  String? _selectedBudget;

  Future<void> _selectBudget(String budget) async {
    final url = Uri.parse('https://api.example.com/select-budget');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'budget': budget}),
    );
    print('Response status: ${response.statusCode}');
  }

  void onOptionTap(String budget) {
    setState(() {
      _selectedBudget = budget;
    });
    _selectBudget(budget).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Keywordscreen2(),
        ),
      );
    });
  }

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
          Container(
            height: 500.h,
            child: ListView.builder(
              itemCount: _budgetOptions.length,
              itemBuilder: (context, index) {
                return Square(
                  child: _budgetOptions[index],
                  onTap: () => onOptionTap(_budgetOptions[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
