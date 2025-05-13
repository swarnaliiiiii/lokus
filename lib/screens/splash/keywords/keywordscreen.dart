import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lokus/domains/constants/appcolors.dart';

class Keywordscreen extends StatefulWidget{
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              color: AppColors.dashColor,

            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              color: AppColors.page2Color,
              
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              color: AppColors.page3Color,
              
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200,
              color: AppColors.splashColor,
            ),
          ),
        ],
      )
    );
  }
}