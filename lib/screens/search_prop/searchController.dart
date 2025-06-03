import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lokus/screens/search_prop/placeListController.dart';
import 'package:lokus/screens/search_prop/place.dart';

class SearchController extends GetxController {
  late final PlaceListController placeListController;
  
  final TextEditingController searchTextController = TextEditingController();
  RxList<Place> searchResults = <Place>[].obs;

  SearchController({required this.placeListController});

  Future<void> search([String? query]) async {
    query = query?.trim() ?? searchTextController.text.trim();

    if (query.isEmpty) {
      print("Query is empty");
      return;
    }

    print("Searching for: $query");

    if (placeListController.placelist.isNotEmpty) {
      searchResults.clear();
      for (var place in placeListController.placelist) {
        if (place.displayName != null &&
            place.displayName!.toLowerCase().contains(query.toLowerCase())) {
          searchResults.add(place);
        }
      }

      print(searchResults.isEmpty
          ? "Search result is empty"
          : "Found ${searchResults.length} results");
    } else {
      print("Place list is empty");
    }
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}