import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lokus/domains/constants/appcolors.dart';

class Square extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100.h,
        width: 200.w,
        decoration: BoxDecoration(
          color: AppColors.page2Color,
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }
}
