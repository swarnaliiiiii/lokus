import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokus/controllers/prompt_controller.dart'; // Adjust the import based on your project structure

class TravelItineraryResultScreen extends StatefulWidget {
  @override
  _TravelItineraryResultScreenState createState() => _TravelItineraryResultScreenState();
}

class _TravelItineraryResultScreenState
    extends State<TravelItineraryResultScreen> {
  @override
  final PromptController promptController = Get.find<PromptController>();
  final RxInt currentPage = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF6B73FF),
          Color(0xFF9B59B6),
        ],
      )),
      child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    Expanded(
                      child: Text(
                        'Your Travel Itinerary',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Share functionality
                      },
                      icon: Icon(Icons.share, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
