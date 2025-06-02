import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokus/screens/search_prop/placeListController.dart';
import 'package:lokus/screens/search_prop/place.dart';
import 'package:lokus/screens/search_prop/searchController.dart' as mysearch;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Find your location.....',
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(8.0),
                 borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ))),
        SizedBox(width: 8.w),
        Container(
          height: 48.h,
          width: 48.w,
          decoration: BoxDecoration(
           color: Colors.orange,
           borderRadius: BorderRadius.circular(8.0),
         ),
         child: IconButton(
           icon: Icon(Icons.search, color: Colors.white),
           onPressed: () async {
             final searchController = Get.find<mysearch.SearchController>();
             final placeListController = Get.find<PlaceListController>();
             String query = '';
             await searchController.search(query);
             if (searchController.searchResults.isNotEmpty) {
               placeListController.placelist.value = searchController.searchResults;
             } else {
               print("No results found for the query.");
             }
           },
         ),
        )
      ],
    );
  }
}
