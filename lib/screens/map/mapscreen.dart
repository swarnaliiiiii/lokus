import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  final searchController = TextEditingController();
  Location location = Location();
  var uuid = const Uuid();
  List<dynamic> ListofLocation = [];
  String token = '1234567890';

  @override
  void initState() {
    searchController.addListener(() {
      super.initState();
    });
  }

  onChange() {
    placeSuggestion(searchController.text);
  }

  void placeSuggestion(String input) {
    const String apiKey = "";
    try {
      String baseUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      String request =
          '$baseUrl?inpute=$input&key=$apiKey&sessiontoken=$token';
      var url = Uri.parse(request);
      http.get(url).then((response) {
        var data = json.decode(response.body);
        if (kDebugMode) {
          print(data);
        }
        if (response.statusCode == 200) {
          setState(() {
            ListofLocation = json.decode(response.body)['predictions'];
          });
        }
      }).catchError((e) {
        print(e.toString());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE0B2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60.h,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Map',
              style: GoogleFonts.manrope(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            CircleAvatar(
              radius: 18.r,
              backgroundColor: Colors.orange.shade200,
              child: Icon(Icons.person, color: Colors.white, size: 20.sp),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: searchController,
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: 'Find your location...',
                  hintStyle: TextStyle(fontSize: 14.sp),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, size: 20.sp),
                ),
                onChanged: (value) {
                  // Handle search logic here
                },
              ),
            ),
            Visibility(
              visible: searchController.text.isEmpty ? false : true,
              child: SizedBox(
                height: 120.h,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5, // Example count
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Text(
                        ListofLocation[index]["description"],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'My Location',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 12.h),
            // Map Container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                    },
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(22.719568, 75.857727),
                      zoom: 12,
                    ),
                    zoomControlsEnabled: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
