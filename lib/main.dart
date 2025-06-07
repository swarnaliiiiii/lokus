import 'package:flutter/material.dart';
import 'package:lokus/app.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lokus/screens/search_prop/placeListController.dart';
import 'package:lokus/screens/search_prop/searchController.dart' as my_search_controller;
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'package:lokus/screens/tab_bar/tabcontroller.dart';
import 'package:lokus/controllers/inputcontroller.dart';

void main() async {
  // CRITICAL: Initialize Flutter binding first
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");
    
    // Get API key with better error handling
    String apiKey = dotenv.env['API_KEY'] ?? '';

    
    if (apiKey.isEmpty) {
      print('Warning: API_KEY not found in .env file');
      // You might want to handle this case differently
    }
    
    // Initialize Gemini
    Gemini.init(apiKey: apiKey);
    
    // Initialize GetX controllers early (optional - you can also do this in your app)
    _initializeControllers();
    
    print('App initialization completed successfully');
    
  } catch (e) {
    print('Error during app initialization: $e');
    // You might want to show an error dialog or handle this differently
  }
  runApp(const MyApp());
}

void _initializeControllers() {
  // Initialize controllers that need to be available globally
  Get.put(PlaceListController(), permanent: true);
  
  // Initialize search controller with dependency
  Get.put(
    my_search_controller.SearchController(
      placeListController: Get.find<PlaceListController>(),
    ),
    permanent: true,
  );
  
  Get.put(InputController(), permanent: true);
  Get.put(NavigationController(), permanent: true);

  print('Controllers initialized successfully');
}