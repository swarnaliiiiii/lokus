import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lokus/screens/search_prop/searchbox.dart';
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
      ),
      body: Center(
        child: Text('Get Ready for an Amazing Trip!',
          style: GoogleFonts.manrope(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
         ),

      ),
    );
  }
}
