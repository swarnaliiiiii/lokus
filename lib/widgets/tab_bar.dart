import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lokus/domains/constants/appcolors.dart';

class CustomTab extends StatelessWidget {
  final VoidCallback? onNext;
  final IconData icon;
  final String label;

  const CustomTab({
    Key? key,
    this.onNext,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNext,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.dashColor),
          SizedBox(height: 4.h),
          Text(label, style: TextStyle(color: AppColors.dashColor)),
        ],
      ),
    );
  }
}
