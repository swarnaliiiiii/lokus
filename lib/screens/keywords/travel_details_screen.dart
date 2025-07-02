import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lokus/domains/constants/appcolors.dart';
import 'package:lokus/widgets/nav_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:lokus/controllers/inputcontroller.dart';
import 'package:lokus/controllers/prompt_controller.dart';
import 'package:lokus/controllers/location_controller.dart';
import 'package:lokus/models/location_model.dart';
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
  final LocationController locationController = Get.put(LocationController());
  Timer? _navigationTimer;
  Timer? _searchTimer;

  final TextEditingController _fromLocationController = TextEditingController();
  final TextEditingController _toLocationController = TextEditingController();
  final FocusNode _fromFocusNode = FocusNode();
  final FocusNode _toFocusNode = FocusNode();
  
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showFromSuggestions = false;
  bool _showToSuggestions = false;
  String _activeField = '';

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    _setupFocusListeners();
  }

  void _setupFocusListeners() {
    _fromFocusNode.addListener(() {
      if (_fromFocusNode.hasFocus) {
        setState(() {
          _activeField = 'from';
          _showFromSuggestions = true;
          _showToSuggestions = false;
        });
        if (_fromLocationController.text.isEmpty) {
          locationController.showPopularDestinations();
        }
      }
    });

    _toFocusNode.addListener(() {
      if (_toFocusNode.hasFocus) {
        setState(() {
          _activeField = 'to';
          _showToSuggestions = true;
          _showFromSuggestions = false;
        });
        if (_toLocationController.text.isEmpty) {
          locationController.showPopularDestinations();
        }
      }
    });
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

  void _onLocationSearch(String query, String field) {
    _searchTimer?.cancel();
    _searchTimer = Timer(Duration(milliseconds: 300), () {
      locationController.searchLocations(query);
    });
  }

  void _selectLocation(LocationModel location, String field) {
    if (field == 'from') {
      _fromLocationController.text = location.fullName;
      setState(() {
        _showFromSuggestions = false;
      });
      _fromFocusNode.unfocus();
    } else {
      _toLocationController.text = location.fullName;
      setState(() {
        _showToSuggestions = false;
      });
      _toFocusNode.unfocus();
    }
    locationController.clearResults();
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _searchTimer?.cancel();
    _fromLocationController.dispose();
    _toLocationController.dispose();
    _fromFocusNode.dispose();
    _toFocusNode.dispose();
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

  Widget _buildLocationField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String field,
    required IconData icon,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
            controller: controller,
            focusNode: focusNode,
            onChanged: (value) {
              setState(() {});
              _onLocationSearch(value, field);
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.manrope(
                color: Colors.grey[500],
                fontSize: 16,
              ),
              prefixIcon: Icon(
                icon,
                color: AppColors.letterColor ?? Colors.blue,
              ),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[400]),
                      onPressed: () {
                        controller.clear();
                        setState(() {});
                        if (field == 'from') {
                          locationController.showPopularDestinations();
                        } else {
                          locationController.showPopularDestinations();
                        }
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.r),
            ),
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionsList() {
    return Obx(() {
      if (locationController.searchResults.isEmpty && !locationController.isLoading.value) {
        return SizedBox.shrink();
      }

      return Container(
        margin: EdgeInsets.only(top: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            if (locationController.isLoading.value)
              Container(
                padding: EdgeInsets.all(16.r),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.letterColor ?? Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Searching locations...',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ...locationController.searchResults.take(6).map((location) {
              return InkWell(
                onTap: () => _selectLocation(location, _activeField),
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: AppColors.letterColor ?? Colors.blue,
                        size: 20.r,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              location.name,
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            if (location.country.isNotEmpty)
                              Text(
                                location.country,
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide suggestions when tapping outside
        FocusScope.of(context).unfocus();
        setState(() {
          _showFromSuggestions = false;
          _showToSuggestions = false;
        });
        locationController.clearResults();
      },
      child: Scaffold(
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
                    _buildLocationField(
                      label: "From",
                      controller: _fromLocationController,
                      focusNode: _fromFocusNode,
                      field: "from",
                      icon: Icons.location_on_outlined,
                      hint: "Enter departure location",
                    ),
                    
                    // From Location Suggestions
                    if (_showFromSuggestions && _activeField == 'from')
                      _buildSuggestionsList(),
                    
                    SizedBox(height: 24.h),
                    
                    // To Location
                    _buildLocationField(
                      label: "To",
                      controller: _toLocationController,
                      focusNode: _toFocusNode,
                      field: "to",
                      icon: Icons.place_outlined,
                      hint: "Enter destination location",
                    ),
                    
                    // To Location Suggestions
                    if (_showToSuggestions && _activeField == 'to')
                      _buildSuggestionsList(),
                    
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
      ),
    );
  }
}