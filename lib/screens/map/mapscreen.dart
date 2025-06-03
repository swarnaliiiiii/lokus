import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;

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
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: 'Find your location...',
                  hintStyle: TextStyle(fontSize: 14.sp),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, size: 20.sp),
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
