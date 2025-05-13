import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lokus/domains/constants/appcolors.dart';
import 'package:lokus/screens/splash/splashscreen.dart';
import 'package:lokus/widgets/nav_bar.dart';

class Keywordscreen extends StatefulWidget {
  const Keywordscreen({Key? key}) : super(key: key);

  @override
  State<Keywordscreen> createState() => _KeywordscreenState();
}

class _KeywordscreenState extends State<Keywordscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.keywordColor,
        body: Column(
          children: [
            CustomNav(
              icon: Icons.arrow_back,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SplashScreen()));
              },
              // Removed invalid 'child' parameter
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("What's your \n budget?",
                  style: GoogleFonts.manrope(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: const Color.fromARGB(255, 23, 70, 109),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
