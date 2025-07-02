import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lokus/domains/constants/appcolors.dart';
import 'package:lokus/widgets/nav_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:lokus/controllers/inputcontroller.dart';
import 'package:lokus/controllers/prompt_controller.dart';
import 'package:lokus/screens/recommendations/travel_recs.dart';
import 'package:lokus/screens/recommendations/generate_travel.dart';

class TravelDetailsScreen extends StatefulWidget {
  const TravelDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TravelDetailsScreen> createState() => _TravelDetailsScreenState();
}

class _TravelDetailsScreenState extends State<TravelDetailsScreen> {
  final InputController inputController = Get.find<InputController>();
  final PromptController promptController = Get.find<PromptController>();
  Timer? _navigationTimer;

  final TextEditingController _fromLocationController = TextEditingController();
  final TextEditingController _toLocationController = TextEditingController();
  
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    // Load saved data if available
    _loadSavedData();
  }

  void _loadSavedData() {
    _fromLocationController.text = inputController.SelectedFromLocation.value;
    _toLocationController.text = inputController.SelectedToLocation.value;
    
    if (inputController.SelectedStartDate.value.isNotEmpty) {
      _startDate = DateTime.tryParse(inputController.SelectedStartDate.value);
    }
    if (inputController.SelectedEndDate.value.isNotEmpty) {
      _endDate = DateTime.tryParse(inputController.SelectedEndDate.value);
    }
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _fromLocationController.dispose();
    _toLocationController.dispose();
    super.dispose();
  }

  void _handleContinue() async {
    // Save all the data
    await inputController.setFromLocation(_fromLocationController.text);
    await inputController.setToLocation(_toLocationController.text);
    await inputController.setStartDate(_startDate?.toIso8601String() ?? '');
    await inputController.setEndDate(_endDate?.toIso8601String() ?? '');
    
    // Navigate to recommendations screen
    _navigationTimer = Timer(Duration(seconds: 1), () {
      Get.to(() => TravelRecommendationsScreen(
        destinationType: inputController.SelectedDestination.value
      ));
    });
  }

  bool _isFormValid() {
    return _fromLocationController.text.isNotEmpty &&
           _toLocationController.text.isNotEmpty &&
           _startDate != null &&
           _endDate != null &&
           _endDate!.isAfter(_startDate!);
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.letterColor ?? Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _startDate = picked;
        // If end date is before start date, reset it
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate?.add(Duration(days: 1)) ?? DateTime.now().add(Duration(days: 1))),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.letterColor ?? Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.day}/${date.month}/${date.year}';
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
                "Travel Details",
                style: GoogleFonts.manrope(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: const Color.fromARGB(255, 23, 70, 109),
                ),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // From Location
                  Text(
                    "From",
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.letterColor ?? Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _fromLocationController,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Enter departure location',
                        hintStyle: GoogleFonts.manrope(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: AppColors.letterColor ?? Colors.blue,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16.r),
                      ),
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // To Location
                  Text(
                    "To",
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.letterColor ?? Colors.blue,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _toLocationController,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Enter destination location',
                        hintStyle: GoogleFonts.manrope(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          Icons.place_outlined,
                          color: AppColors.letterColor ?? Colors.blue,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16.r),
                      ),
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Date Selection
                  Text(
                    "Travel Dates",
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.letterColor ?? Colors.blue,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  
                  Row(
                    children: [
                      // Start Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Departure",
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 6.h),
                            GestureDetector(
                              onTap: _selectStartDate,
                              child: Container(
                                padding: EdgeInsets.all(16.r),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: _startDate != null 
                                        ? AppColors.letterColor ?? Colors.blue
                                        : Colors.grey.shade300,
                                    width: _startDate != null ? 2 : 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: _startDate != null 
                                          ? AppColors.letterColor ?? Colors.blue
                                          : Colors.grey[500],
                                      size: 20.r,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        _formatDate(_startDate),
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: _startDate != null 
                                              ? Colors.black87
                                              : Colors.grey[500],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(width: 16.w),
                      
                      // End Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Return",
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 6.h),
                            GestureDetector(
                              onTap: _startDate != null ? _selectEndDate : null,
                              child: Container(
                                padding: EdgeInsets.all(16.r),
                                decoration: BoxDecoration(
                                  color: _startDate != null ? Colors.white : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: _endDate != null 
                                        ? AppColors.letterColor ?? Colors.blue
                                        : Colors.grey.shade300,
                                    width: _endDate != null ? 2 : 1,
                                  ),
                                  boxShadow: _startDate != null ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ] : [],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: _endDate != null 
                                          ? AppColors.letterColor ?? Colors.blue
                                          : Colors.grey[400],
                                      size: 20.r,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        _formatDate(_endDate),
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: _endDate != null 
                                              ? Colors.black87
                                              : Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: _isFormValid() ? _handleContinue : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFormValid() 
                            ? AppColors.letterColor ?? Colors.blue
                            : Colors.grey[400],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: _isFormValid() ? 2 : 0,
                      ),
                      child: Text(
                        'Continue',
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}