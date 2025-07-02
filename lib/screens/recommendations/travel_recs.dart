import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lokus/controllers/prompt_controller.dart';

import 'package:lokus/models/place_model.dart';

class PlacesRecommendationScreen extends StatefulWidget {
  final List<Place> places;
  
  const PlacesRecommendationScreen({Key? key, required this.places}) : super(key: key);

  @override
  State<PlacesRecommendationScreen> createState() => _PlacesRecommendationScreenState();
}

class _PlacesRecommendationScreenState extends State<PlacesRecommendationScreen> {
  final PromptController promptController = Get.find<PromptController>();
  late List<Place> places;
  bool isGeneratingPlaces = false;
  
  @override
  void initState() {
    super.initState();
    places = List.from(widget.places);
  }
  
  // Add this method to safely call setState
  void _safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 8.r),
            child: Text(
              'Select\ndestination',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.2.h,
              ),
            ),
          ),
          
          // Grid of destinations
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  Expanded(
                    child: places.isEmpty 
                        ? Center(
                            child: Text(
                              'No places available',
                              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: places.length,
                            itemBuilder: (context, index) {
                              return PlaceCard(
                                place: places[index],
                                onSelectPlace: () => _selectPlace(places[index]),
                              );
                            },
                          ),
                  ),
                  
                  // Show loader when generating places
                  if (isGeneratingPlaces)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.r),
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8BC34A)),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Generating more places...',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Generate More Places button
          Padding(
            padding: EdgeInsets.all(24.r),
            child: SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: isGeneratingPlaces ? null : _generateMorePlaces,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isGeneratingPlaces 
                      ? Colors.grey[400] 
                      : const Color(0xFF8BC34A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                  elevation: 0,
                ),
                child: isGeneratingPlaces
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Generating...',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Generate More Places',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _generateMorePlaces() async {
    // Check if widget is still mounted before setting state
    if (!mounted) return;
    
    _safeSetState(() {
      isGeneratingPlaces = true;
    });
    
    try {
      // Store the original count
      int originalCount = places.length;
      
      // Generate more places
      await promptController.generatePlacesRecommendationsWithoutNavigation();
      
      // Check if widget is still mounted before updating UI
      if (!mounted) return;
      
      // Update the local places list with new places from controller
      if (promptController.recommendedPlaces.length > originalCount) {
        _safeSetState(() {
          places = List.from(promptController.recommendedPlaces);
        });
        
        // Check if widget is still mounted before showing snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${places.length - originalCount} new places generated!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No new places found. Try adjusting your preferences.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate more places: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      // Always check mounted before final setState
      _safeSetState(() {
        isGeneratingPlaces = false;
      });
    }
  }
  
  void _selectPlace(Place place) {
    // Check if widget is still mounted before showing modal
    if (!mounted) return;
    _showPlaceDetails(place);
  }
  
  void _showPlaceDetails(Place place) {
    // Check if context is still valid
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  
                  // Place name and location
                  Text(
                    place.name,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    place.location,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Description
                  Text(
                    place.description,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Info cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Best Time',
                          place.bestTime,
                          Colors.blue,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildInfoCard(
                          'Budget',
                          place.budgetRange,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Attractions
                  Text(
                    'Top Attractions',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ...place.topAttractions.map((attraction) =>
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20.r),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              attraction,
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ),
                        ],
                      ),
                    )
                  ).toList(),
                  SizedBox(height: 15.h),

                  // Generate itinerary button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            promptController.generateDetailedItinerary(place.name);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                          ),
                          child: Text(
                            'Add to Map',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            promptController.generateDetailedItinerary(place.name);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                          ),
                          child: Text(
                            'Book Now',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoCard(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onSelectPlace;
  
  const PlaceCard({Key? key, required this.place, required this.onSelectPlace}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelectPlace,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            children: [
              // Background image from AI response
              Container(
                width: double.infinity,
                height: double.infinity,
                child: place.imageUrl.isNotEmpty
                    ? Image.network(
                        place.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  _getPlaceColor(place.name),
                                  _getPlaceColor(place.name).withOpacity(0.7),
                                ],
                              ),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _buildFallbackContainer();
                        },
                      )
                    : _buildFallbackContainer(),
              ),
              
              // Favorite button
              Positioned(
                top: 12.r,
                right: 12.r,
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 20.r,
                  ),
                ),
              ),
              
              // Place info at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Country/Region tag
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 4.r),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          _getCountryCode(place.location),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Place name
                      Text(
                        place.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFallbackContainer() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _getPlaceColor(place.name),
            _getPlaceColor(place.name).withOpacity(0.7),
          ],
        ),
      ),
      child: Icon(
        Icons.landscape,
        size: 60.r,
        color: Colors.white.withOpacity(0.5),
      ),
    );
  }
  
  Color _getPlaceColor(String placeName) {
    const colors = [
      Color(0xFF6B73FF),
      Color(0xFF9C27B0),
      Color(0xFF2196F3),
      Color(0xFF009688),
      Color(0xFF4CAF50),
      Color(0xFFFF9800),
      Color(0xFFF44336),
    ];
    return colors[placeName.hashCode.abs() % colors.length];
  }
  
  String _getCountryCode(String location) {
    List<String> parts = location.split(',');
    if (parts.length > 1) {
      String lastPart = parts.last.trim();
      if (lastPart.length >= 2) {
        return lastPart.substring(0, 2).toUpperCase();
      }
    }
    
    if (location.length >= 2) {
      return location.substring(0, 2).toUpperCase();
    }
    return 'XX';
  }
}