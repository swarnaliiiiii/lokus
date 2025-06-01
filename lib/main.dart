import 'package:flutter/material.dart';
import 'package:lokus/app.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lokus/screens/search_prop/placeListController.dart';
import 'package:lokus/screens/search_prop/searchController.dart' as my_search_controller;
import 'package:get/get.dart';

void main() {
  String apiKey = dotenv.env['API_KEY'] ?? '';
  Gemini.init(apiKey: apiKey);
  Get.put(PlaceListController());
  Get.put(my_search_controller.SearchController());
  runApp(const MyApp());
}
