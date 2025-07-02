import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lokus/models/location_model.dart';
import 'package:uuid/uuid.dart';

class LocationController extends GetxController {
  var isLoading = false.obs;
  var searchResults = <LocationModel>[].obs;
  var sessionToken = const Uuid().v4();

  // Popular destinations as fallback
  final List<LocationModel> popularDestinations = [
    LocationModel(id: '1', name: 'New York', country: 'United States', fullName: 'New York, NY, USA', latitude: 40.7128, longitude: -74.0060),
    LocationModel(id: '2', name: 'London', country: 'United Kingdom', fullName: 'London, UK', latitude: 51.5074, longitude: -0.1278),
    LocationModel(id: '3', name: 'Paris', country: 'France', fullName: 'Paris, France', latitude: 48.8566, longitude: 2.3522),
    LocationModel(id: '4', name: 'Tokyo', country: 'Japan', fullName: 'Tokyo, Japan', latitude: 35.6762, longitude: 139.6503),
    LocationModel(id: '5', name: 'Dubai', country: 'UAE', fullName: 'Dubai, United Arab Emirates', latitude: 25.2048, longitude: 55.2708),
    LocationModel(id: '6', name: 'Singapore', country: 'Singapore', fullName: 'Singapore', latitude: 1.3521, longitude: 103.8198),
    LocationModel(id: '7', name: 'Sydney', country: 'Australia', fullName: 'Sydney, NSW, Australia', latitude: -33.8688, longitude: 151.2093),
    LocationModel(id: '8', name: 'Mumbai', country: 'India', fullName: 'Mumbai, Maharashtra, India', latitude: 19.0760, longitude: 72.8777),
    LocationModel(id: '9', name: 'Delhi', country: 'India', fullName: 'New Delhi, Delhi, India', latitude: 28.6139, longitude: 77.2090),
    LocationModel(id: '10', name: 'Bangkok', country: 'Thailand', fullName: 'Bangkok, Thailand', latitude: 13.7563, longitude: 100.5018),
    LocationModel(id: '11', name: 'Istanbul', country: 'Turkey', fullName: 'Istanbul, Turkey', latitude: 41.0082, longitude: 28.9784),
    LocationModel(id: '12', name: 'Barcelona', country: 'Spain', fullName: 'Barcelona, Spain', latitude: 41.3851, longitude: 2.1734),
    LocationModel(id: '13', name: 'Rome', country: 'Italy', fullName: 'Rome, Italy', latitude: 41.9028, longitude: 12.4964),
    LocationModel(id: '14', name: 'Amsterdam', country: 'Netherlands', fullName: 'Amsterdam, Netherlands', latitude: 52.3676, longitude: 4.9041),
    LocationModel(id: '15', name: 'Los Angeles', country: 'United States', fullName: 'Los Angeles, CA, USA', latitude: 34.0522, longitude: -118.2437),
    LocationModel(id: '16', name: 'Berlin', country: 'Germany', fullName: 'Berlin, Germany', latitude: 52.5200, longitude: 13.4050),
    LocationModel(id: '17', name: 'Madrid', country: 'Spain', fullName: 'Madrid, Spain', latitude: 40.4168, longitude: -3.7038),
    LocationModel(id: '18', name: 'Vienna', country: 'Austria', fullName: 'Vienna, Austria', latitude: 48.2082, longitude: 16.3738),
    LocationModel(id: '19', name: 'Prague', country: 'Czech Republic', fullName: 'Prague, Czech Republic', latitude: 50.0755, longitude: 14.4378),
    LocationModel(id: '20', name: 'Zurich', country: 'Switzerland', fullName: 'Zurich, Switzerland', latitude: 47.3769, longitude: 8.5417),
    LocationModel(id: '21', name: 'Stockholm', country: 'Sweden', fullName: 'Stockholm, Sweden', latitude: 59.3293, longitude: 18.0686),
    LocationModel(id: '22', name: 'Copenhagen', country: 'Denmark', fullName: 'Copenhagen, Denmark', latitude: 55.6761, longitude: 12.5683),
    LocationModel(id: '23', name: 'Helsinki', country: 'Finland', fullName: 'Helsinki, Finland', latitude: 60.1699, longitude: 24.9384),
    LocationModel(id: '24', name: 'Oslo', country: 'Norway', fullName: 'Oslo, Norway', latitude: 59.9139, longitude: 10.7522),
    LocationModel(id: '25', name: 'Lisbon', country: 'Portugal', fullName: 'Lisbon, Portugal', latitude: 38.7223, longitude: -9.1393),
    // Indian cities
    LocationModel(id: '26', name: 'Bangalore', country: 'India', fullName: 'Bangalore, Karnataka, India', latitude: 12.9716, longitude: 77.5946),
    LocationModel(id: '27', name: 'Chennai', country: 'India', fullName: 'Chennai, Tamil Nadu, India', latitude: 13.0827, longitude: 80.2707),
    LocationModel(id: '28', name: 'Kolkata', country: 'India', fullName: 'Kolkata, West Bengal, India', latitude: 22.5726, longitude: 88.3639),
    LocationModel(id: '29', name: 'Hyderabad', country: 'India', fullName: 'Hyderabad, Telangana, India', latitude: 17.3850, longitude: 78.4867),
    LocationModel(id: '30', name: 'Pune', country: 'India', fullName: 'Pune, Maharashtra, India', latitude: 18.5204, longitude: 73.8567),
    LocationModel(id: '31', name: 'Ahmedabad', country: 'India', fullName: 'Ahmedabad, Gujarat, India', latitude: 23.0225, longitude: 72.5714),
    LocationModel(id: '32', name: 'Jaipur', country: 'India', fullName: 'Jaipur, Rajasthan, India', latitude: 26.9124, longitude: 75.7873),
    LocationModel(id: '33', name: 'Goa', country: 'India', fullName: 'Goa, India', latitude: 15.2993, longitude: 74.1240),
    LocationModel(id: '34', name: 'Kerala', country: 'India', fullName: 'Kerala, India', latitude: 10.8505, longitude: 76.2711),
    LocationModel(id: '35', name: 'Agra', country: 'India', fullName: 'Agra, Uttar Pradesh, India', latitude: 27.1767, longitude: 78.0081),
  ];

  Future<void> searchLocations(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    if (query.length < 2) {
      // Show popular destinations for short queries
      searchResults.value = popularDestinations
          .where((location) => 
              location.name.toLowerCase().contains(query.toLowerCase()) ||
              location.country.toLowerCase().contains(query.toLowerCase()))
          .take(8)
          .toList();
      return;
    }

    // Always search in popular destinations first for immediate results
    _searchInPopularDestinations(query);

    // Try API search in background (but don't rely on it)
    _tryApiSearch(query);
  }

  Future<void> _tryApiSearch(String query) async {
    try {
      isLoading.value = true;
      
      final String apiKey = dotenv.env['API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        print('API_KEY is not set in .env file - using popular destinations only');
        return;
      }

      final String baseUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      final String request = '$baseUrl?input=$query&key=$apiKey&sessiontoken=$sessionToken&types=(cities)';
      
      final response = await http.get(Uri.parse(request)).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          print('API request timed out - using popular destinations');
          return http.Response('{"status": "REQUEST_DENIED"}', 408);
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Check if API response is valid
        if (data['status'] == 'OK' && data['predictions'] != null) {
          final predictions = data['predictions'] as List<dynamic>;
          
          final apiResults = predictions
              .map((prediction) => LocationModel.fromJson(prediction))
              .toList();
              
          // Combine API results with popular destinations (remove duplicates)
          final combinedResults = <LocationModel>[];
          final addedNames = <String>{};
          
          // Add API results first
          for (final result in apiResults) {
            if (!addedNames.contains(result.name.toLowerCase())) {
              combinedResults.add(result);
              addedNames.add(result.name.toLowerCase());
            }
          }
          
          // Add popular destinations that aren't already included
          for (final popular in searchResults) {
            if (!addedNames.contains(popular.name.toLowerCase()) && combinedResults.length < 10) {
              combinedResults.add(popular);
              addedNames.add(popular.name.toLowerCase());
            }
          }
          
          searchResults.value = combinedResults;
        } else {
          print('API returned error status: ${data['status']} - using popular destinations only');
        }
      } else {
        print('API request failed with status: ${response.statusCode} - using popular destinations only');
      }
    } catch (e) {
      print('Error with API search (using popular destinations): $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _searchInPopularDestinations(String query) {
    final results = popularDestinations
        .where((location) => 
            location.name.toLowerCase().contains(query.toLowerCase()) ||
            location.country.toLowerCase().contains(query.toLowerCase()) ||
            location.fullName.toLowerCase().contains(query.toLowerCase()))
        .take(8)
        .toList();
    
    searchResults.value = results;
  }

  void clearResults() {
    searchResults.clear();
  }

  void showPopularDestinations() {
    searchResults.value = popularDestinations.take(8).toList();
  }
}