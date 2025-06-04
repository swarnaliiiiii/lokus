import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  final TextEditingController _searchController = TextEditingController();
  Location location = Location();
  var uuid = const Uuid();
  List<dynamic> ListofLocation = [];
  String token = '1234567890';

  @override
  void initState() {
    super.initState(); // This should be called first
    _searchController.addListener(() {
      onChange(); // Connect the listener to onChange method
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // Don't forget to dispose the controller
    super.dispose();
  }

  onChange() {
    placeSuggestion(_searchController.text);
  }

  void placeSuggestion(String input) {
    final String apiKey = dotenv.env['API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      print('API_KEY is not set in .env file');
      return;
    }
    
    if (input.isEmpty) {
      setState(() {
        ListofLocation = [];
      });
      return;
    }
    
    try {
      String baseUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      String request =
          '$baseUrl?input=$input&key=$apiKey&sessiontoken=$token'; // Fixed: 'inpute' -> 'input'
      var url = Uri.parse(request);
      http.get(url).then((response) {
        var data = json.decode(response.body);
        if (kDebugMode) {
          print(data);
        }
        if (response.statusCode == 200) {
          setState(() {
            ListofLocation = json.decode(response.body)['predictions'] ?? [];
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
                controller: _searchController,
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: 'Find your location...',
                  hintStyle: TextStyle(fontSize: 14.sp),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, size: 20.sp),
                ),
                // Removed onChanged since we're using addListener
              ),
            ),
            Visibility(
              visible: ListofLocation.isNotEmpty, // Better condition
              child: Container(
                height: 120.h,
                margin: EdgeInsets.only(top: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ListofLocation.length, // Use actual length
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Handle place selection
                        _searchController.text = ListofLocation[index]["description"];
                        setState(() {
                          ListofLocation = [];
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        child: Text(
                          ListofLocation[index]["description"] ?? "",
                          style: TextStyle(fontSize: 14.sp),
                        ),
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