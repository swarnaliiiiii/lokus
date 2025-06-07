import 'package:flutter/material.dart';
import 'package:lokus/domains/constants/appcolors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lokus/screens/keywords/keywordscreen.dart';
import 'package:lokus/widgets/nav_bar.dart';
import 'package:lokus/widgets/square.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lokus/screens/keywords/keywordscreen3.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:lokus/controllers/inputcontroller.dart';

class Keywordscreen2 extends StatefulWidget {
  const Keywordscreen2({Key? key}) : super(key: key);

  @override
  State<Keywordscreen2> createState() => _Keywordscreen2State();
}

class _Keywordscreen2State extends State<Keywordscreen2> {

  final InputController inputController = Get.find<InputController>();
  Timer? _navigationTimer;

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  void _handleDurationSelection(String duration) {
    // Save duration using controller
    inputController.setTravelDuration(duration);
    
    // Navigate after short delay
    _navigationTimer = Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Keywordscreen3()));
    });
  }

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
              itemCount: inputController.durationOptions.length,
              itemBuilder: (context, index) {
                String option = inputController.durationOptions[index];
                
                return Obx(() {
                  bool isSelected = inputController.isDurationSelected(option);
                  
                  return GestureDetector(
                    onTap: () => _handleDurationSelection(option),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.letterColor : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected ? AppColors.letterColor ?? Colors.blue : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                option,
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  color: isSelected ? AppColors.dashColor : Colors.black87,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: AppColors.dashColor,
                                size: 24.r,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          // Show selected duration
          Obx(() => inputController.SelectedDuration.value.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: AppColors.letterColor?.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Selected: ${inputController.SelectedDuration.value}',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.letterColor,
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink()),
        ],
      ),
    );
  }
}