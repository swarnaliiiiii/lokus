import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lokus/domains/constants/appcolors.dart';
import 'package:lokus/widgets/nav_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:lokus/controllers/inputcontroller.dart';
import 'package:lokus/dashboard/dashboardscreen.dart';

class DestinationTypeScreen extends StatefulWidget {
  const DestinationTypeScreen({Key? key}) : super(key: key);

  @override
  State<DestinationTypeScreen> createState() => _DestinationTypeScreenState();
}

class _DestinationTypeScreenState extends State<DestinationTypeScreen> {
  final InputController inputController = Get.find<InputController>();
  Timer? _navigationTimer;

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  void _handleDestinationSelection(String destination) {
    inputController.setTravelDestination(destination);
    
    // Navigate after short delay
    _navigationTimer = Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboardscreen()));
    });
  }

  // Helper method to get icon for each destination type
  IconData _getDestinationIcon(String destination) {
    switch (destination) {
      case 'Beach & Coastal':
        return Icons.beach_access;
      case 'Mountain & Hills':
        return Icons.landscape;
      case 'City & Urban':
        return Icons.location_city;
      case 'Desert & Wilderness':
        return Icons.landscape_outlined;
      case 'Historical & Cultural':
        return Icons.museum;
      case 'Adventure & Sports':
        return Icons.sports_motorsports;
      case 'Spiritual & Religious':
        return Icons.temple_hindu;
      case 'Wildlife & Nature':
        return Icons.nature;
      case 'Island Paradise':
        return Icons.park;
      case 'Countryside & Rural':
        return Icons.agriculture;
      default:
        return Icons.place;
    }
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
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(left: 20.r),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "What type of\ndestination?",
                style: GoogleFonts.manrope(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: const Color.fromARGB(255, 23, 70, 109),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: Container(
              width: double.infinity,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: inputController.destinationOptions.length,
                itemBuilder: (context, index) {
                  String option = inputController.destinationOptions[index];
                  
                  return Obx(() {
                    bool isSelected = inputController.isDestinationSelected(option);
                    
                    return GestureDetector(
                      onTap: () => _handleDestinationSelection(option),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.letterColor : Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: isSelected ? AppColors.letterColor ?? Colors.blue : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(18.r),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? Colors.white.withOpacity(0.2)
                                      : AppColors.letterColor?.withOpacity(0.1) ?? Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  _getDestinationIcon(option),
                                  color: isSelected ? Colors.white : AppColors.letterColor ?? Colors.blue,
                                  size: 24.r,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Text(
                                  option,
                                  style: GoogleFonts.manrope(
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isSelected ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  padding: EdgeInsets.all(4.r),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: AppColors.letterColor ?? Colors.blue,
                                    size: 16.r,
                                  ),
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
          ),
          // Show selected destination
          Obx(() => inputController.SelectedDestination.value.isNotEmpty
              ? Container(
                  margin: EdgeInsets.all(20.r),
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.letterColor ?? Colors.blue,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.letterColor ?? Colors.blue,
                        size: 20.r,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'Selected: ${inputController.SelectedDestination.value}',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.letterColor ?? Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink()),
        ],
      ),
    );
  }
}