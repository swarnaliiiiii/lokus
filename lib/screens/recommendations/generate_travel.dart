import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokus/controllers/prompt_controller.dart';
import 'package:lokus/screens/recommendations/travel_recs.dart';

class TravelRecommendationsScreen extends StatefulWidget {
  final String destinationType;
  
  const TravelRecommendationsScreen({
    Key? key, 
    required this.destinationType
  }) : super(key: key);

  @override
  State<TravelRecommendationsScreen> createState() => _TravelRecommendationsScreenState();
}

class _TravelRecommendationsScreenState extends State<TravelRecommendationsScreen> {
  final PromptController promptController = Get.find<PromptController>();
  
  @override
  void initState() {
    super.initState();
    // Generate recommendations when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateRecommendations();
    });
  }
  
  Future<void> _generateRecommendations() async {
    // Call the method without navigation since we're handling it here
    await promptController.generatePlacesRecommendationsWithoutNavigation();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F0),
      // appBar: AppBar(
      //   backgroundColor: Color(0xFFF5F5F0),
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   title: Text(
      //     widget.destinationType,
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontSize: 18,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      // ),
      body: Obx(() {
        // Show loading while generating
        if (promptController.isGenerating.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Color(0xFF8BC34A),
                ),
                SizedBox(height: 20),
                Text(
                  'Finding perfect destinations for you...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.destinationType,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }
        
        // Show error/empty state if no places found and not generating
        if (promptController.recommendedPlaces.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  promptController.errorMessage.value.isNotEmpty 
                      ? 'Error loading recommendations'
                      : 'No recommendations found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  promptController.errorMessage.value.isNotEmpty
                      ? promptController.errorMessage.value
                      : 'Try selecting a different destination type',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _generateRecommendations,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8BC34A),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text('Try Again'),
                ),
              ],
            ),
          );
        }
        
        // Show the places recommendation screen content
        return PlacesRecommendationScreen(places: promptController.recommendedPlaces);
      }),
    );
  }
}