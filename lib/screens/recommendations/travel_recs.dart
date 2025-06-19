import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  
  @override
  void initState() {
    super.initState();
    places = widget.places;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'Select\ndestination',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.2,
              ),
            ),
          ),
          
          // Grid of destinations
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
          ),
          
          // Book Now button
          Padding(
            padding: EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Handle book now action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8BC34A), // Green color like in design
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Book Now',
                  style: TextStyle(
                    fontSize: 18,
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
  
  void _selectPlace(Place place) {
    // Show detailed view or navigate to details screen
    _showPlaceDetails(place);
  }
  
  void _showPlaceDetails(Place place) {
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
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Place name and location
                  Text(
                    place.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    place.location,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Description
                  Text(
                    place.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  
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
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          'Budget',
                          place.budgetRange,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  
                  // Attractions
                  Text(
                    'Top Attractions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  ...place.topAttractions.map((attraction) => 
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              attraction,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    )
                  ).toList(),
                  SizedBox(height: 30),
                  
                  // Generate itinerary button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        promptController.generateDetailedItinerary(place.name);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Generate Detailed Itinerary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
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
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background image from AI response
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.network(
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
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
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
                        size: 60,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    );
                  },
                ),
              ),
              
              // Favorite button
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              
              // Place info at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16),
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
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getCountryCode(place.location),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      
                      // Place name
                      Text(
                        place.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
  
  Color _getPlaceColor(String placeName) {
    // Simple color assignment based on place name hash
    final colors = [
      Color(0xFF6B73FF),
      Color(0xFF9C27B0),
      Color(0xFF2196F3),
      Color(0xFF009688),
      Color(0xFF4CAF50),
      Color(0xFFFF9800),
      Color(0xFFF44336),
    ];
    return colors[placeName.hashCode % colors.length];
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