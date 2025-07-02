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
          .take(5)
          .toList();
      return;
    }

    try {
      isLoading.value = true;
      
      final String apiKey = dotenv.env['API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        print('API_KEY is not set in .env file');
        // Fallback to popular destinations
        _searchInPopularDestinations(query);
        return;
      }

      final String baseUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      final String request = '$baseUrl?input=$query&key=$apiKey&sessiontoken=$sessionToken';
      
      final response = await http.get(Uri.parse(request));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final predictions = data['predictions'] as List<dynamic>? ?? [];
        
        searchResults.value = predictions
            .map((prediction) => LocationModel.fromJson(prediction))
            .toList();
            
        // If no results from API, search in popular destinations
        if (searchResults.isEmpty) {
          _searchInPopularDestinations(query);
        }
      } else {
        print('API request failed: ${response.statusCode}');
        _searchInPopularDestinations(query);
      }
    } catch (e) {
      print('Error searching locations: $e');
      _searchInPopularDestinations(query);
    } finally {
      isLoading.value = false;
    }
  }

  void _searchInPopularDestinations(String query) {
    searchResults.value = popularDestinations
        .where((location) => 
            location.name.toLowerCase().contains(query.toLowerCase()) ||
            location.country.toLowerCase().contains(query.toLowerCase()) ||
            location.fullName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void clearResults() {
    searchResults.clear();
  }

  void showPopularDestinations() {
    searchResults.value = popularDestinations.take(8).toList();
  }
}