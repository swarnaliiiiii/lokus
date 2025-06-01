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
  final List<String> _budgetOptions = [
    'Budget',
    'Moderate',
    'Comfortable',
    'Premium',
  ];

  String? _selectedBudget;
  bool _isLoading = false; // Fixed: Added loading state

  Future<void> _selectBudget(String budget) async {
    try { // Fixed: Added proper error handling
      final url = Uri.parse('https://api.example.com/select-budget');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'budget': budget}),
      );
      
      if (response.statusCode == 200) {
        print('Budget selected successfully: $budget');
      } else {
        print('Failed to select budget. Status: ${response.statusCode}');
        // Handle error appropriately
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to select budget. Please try again.')),
        );
      }
    } catch (e) {
      print('Error selecting budget: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error. Please check your connection.')),
      );
    }
  }

  void onOptionTap(String budget) async { // Fixed: Made async for better handling
    if (_isLoading) return; // Fixed: Prevent multiple taps
    
    setState(() {
      _selectedBudget = budget;
      _isLoading = true;
    });

    await _selectBudget(budget);
    
    if (mounted) { // Fixed: Check if widget is still mounted
      setState(() {
        _isLoading = false;
      });
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Keywordscreen2(),
        ),
      );
    }
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
              Navigator.pop(context); // Fixed: Use pop instead of push for back navigation
            },
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.only(left: 20.w), // Fixed: Use .w for horizontal padding
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "What's your \nbudget?",
                style: GoogleFonts.manrope(
                  fontSize: 30.sp, // Fixed: Added .sp for responsive font size
                  fontWeight: FontWeight.w900,
                  color: const Color.fromARGB(255, 23, 70, 109),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Expanded( // Fixed: Use Expanded instead of fixed height Container
            child: ListView.builder(
              itemCount: _budgetOptions.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedBudget == _budgetOptions[index];
                return Square(
                  child: _budgetOptions[index],
                  onTap: _isLoading ? null : () => onOptionTap(_budgetOptions[index]), // Fixed: Disable tap when loading
                );
              },
            ),
          ),
          if (_isLoading) // Fixed: Added loading indicator
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
