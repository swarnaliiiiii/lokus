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
  final PageController _pageController = PageController();
  final PromptController promptController = Get.find<PromptController>();
  
  int currentIndex = 0;
  late List<Place> places;
  
  @override
  void initState() {
    super.initState();
    places = widget.places;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Recommended Places'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${currentIndex + 1} / ${places.length}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: LinearProgressIndicator(
                    value: (currentIndex + 1) / places.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          
          // Swipeable cards
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemCount: places.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: PlaceCard(
                    place: places[index],
                    onSelectPlace: () => _selectPlace(places[index].name),
                  ),
                );
              },
            ),
          ),
          
          // Navigation buttons
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button
                currentIndex > 0
                    ? ElevatedButton.icon(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: Icon(Icons.arrow_back),
                        label: Text('Previous'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                        ),
                      )
                    : SizedBox(width: 100),
                
                // Next button
                currentIndex < places.length - 1
                    ? ElevatedButton.icon(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        icon: Icon(Icons.arrow_forward),
                        label: Text('Next'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: () => _showAllPlacesSummary(),
                        icon: Icon(Icons.list),
                        label: Text('View All'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _selectPlace(String placeName) {
    // Generate detailed itinerary for selected place
    promptController.generateDetailedItinerary(placeName);
  }
  
  void _showAllPlacesSummary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Recommended Places',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      title: Text(places[index].name),
                      subtitle: Text(places[index].description),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _selectPlace(places[index].name);
                        },
                        child: Text('Select'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with place name and location
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.white, size: 28),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          place.location,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Content area
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Text(
                        place.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Key info cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              Icons.access_time,
                              'Best Time',
                              place.bestTime,
                              Colors.green,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _buildInfoCard(
                              Icons.account_balance_wallet,
                              'Budget',
                              place.budgetRange,
                              Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      
                      // Attractions
                      _buildSectionHeader('Top Attractions'),
                      ...place.topAttractions.map((attraction) => 
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              SizedBox(width: 8),
                              Expanded(child: Text(attraction)),
                            ],
                          ),
                        )
                      ).toList(),
                      SizedBox(height: 15),
                      
                      // Why perfect section
                      _buildSectionHeader('Why Perfect for You'),
                      Text(
                        place.whyPerfect,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Select button
            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onSelectPlace,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Select This Place',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoCard(IconData icon, String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}