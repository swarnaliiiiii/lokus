import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokus/screens/tab_bar/tabcontroller.dart';


class CustomNavBar extends StatelessWidget {
  final NavigationController _navController = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              imagePath: 'assets/images/icons8-home-48.png',
              index: 0,
            ),
            _buildNavItem(
              imagePath: 'assets/images/icons8-explore-48.png',
              index: 1,
            ),
            _buildNavItem(
              imagePath: 'assets/images/icons8-map-48.png',
              index: 2,
            ),
            _buildNavItem(
              imagePath: 'assets/images/icons8-tour-48.png',
              index: 3,
            ),
            _buildNavItem(
              imagePath: 'assets/images/icons8-customer-48.png',
              index: 4,
            ),
          ],
        )),
      ),
    );
  }
Widget _buildNavItem({
    required String imagePath,
    required int index,
  }) {
    bool isSelected = _navController.currentIndex.value == index;
    
    return GestureDetector(
      onTap: () => _navController.changePage(index),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          imagePath,
          width: 24,
          height: 24,
          fit: BoxFit.cover,
          color: isSelected ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}
