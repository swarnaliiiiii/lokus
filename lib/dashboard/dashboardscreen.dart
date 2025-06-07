import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lokus/screens/search_prop/searchbox.dart' as custom_search;
import 'package:google_fonts/google_fonts.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({Key? key}) : super(key: key);

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            SizedBox(height: 20.h),
            Text(
              'Get Ready for an',
              style: GoogleFonts.manrope(
                fontSize: 28.sp,
                fontWeight: FontWeight.w300,
                color: Colors.black87,
              ),
            ),
            Text(
              'Amazing Trip!',
              style: GoogleFonts.manrope(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            
            SizedBox(height: 30.h),
            
            // Search section
            custom_search.SearchBar(),
            
            SizedBox(height: 40.h),
            
            // Explore section
            Text(
              'Explore Destinations',
              style: GoogleFonts.manrope(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            
            SizedBox(height: 20.h),
            
            // You can add more content here like destination cards, etc.
            Expanded(
              child: Container(
                // Placeholder for destination content
                child: Center(
                  child: Text(
                    'Destination cards will go here',
                    style: GoogleFonts.manrope(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}