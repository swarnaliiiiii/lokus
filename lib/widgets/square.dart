import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lokus/domains/constants/appcolors.dart';

class Square extends StatelessWidget {
  final String child; // Fixed: Added proper type annotation
  final VoidCallback? onTap; // Fixed: Added missing onTap parameter

  const Square({Key? key, required this.child, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector( // Fixed: Added tap functionality
        onTap: onTap,
        child: Container(
          height: 100.h,
          width: 200.w,
          decoration: BoxDecoration(
            color: AppColors.page2Color,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Center( // Fixed: Added Center widget for better text alignment
              child: Text(
                child,
                style: TextStyle(
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color.fromARGB(255, 23, 70, 109),
                ),
                textAlign: TextAlign.center, // Fixed: Added text alignment
              ),
            ),
          ),
        ),
      ),
    );
  }
}
