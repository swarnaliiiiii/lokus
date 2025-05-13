import 'package:flutter/material.dart';

class CustomNav extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onSkip;
  final IconData icon;
  final String label;

  const CustomNav({
    Key? key,
    this.onTap,
    this.onSkip,
    this.icon = Icons.arrow_back,
    this.label = "Next",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 35.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Skip button
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                const SizedBox(width: 8),
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
