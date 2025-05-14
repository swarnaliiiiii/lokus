import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lokus/domains/constants/appcolors.dart';

class CustomNav extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onSkip;
  final IconData icon;
  final IconData icon1;
  final String label;

  const CustomNav({
    Key? key,
    this.onTap,
    this.onSkip,
    this.icon = Icons.arrow_back,
    this.icon1 = Icons.arrow_forward,
    this.label = "Next",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 35.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
        children: [
          // Skip button
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                SizedBox(width: 8.w),
                Icon(
                  icon,
                  color: const Color.fromARGB(255, 23, 70, 109),
                  size: 35,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onSkip,
            child: const Text(
              "Skip",
              style: TextStyle(
                color: Color.fromARGB(255, 23, 70, 109),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
