import 'package:get/get.dart';

class SearchController extends GetxController {
  final PlaceListController placeListController = Get.find<PlaceListController>();
  RxList<Place> searchResults = <Place>[].obs;

  Future<void> search(String query) async {
    print("Searching for: $query");
    if (placeListController.placelist.isNotEmpty) {
      print("Place list is not empty");
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
}
