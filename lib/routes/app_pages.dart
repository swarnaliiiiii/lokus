import 'package:get/get.dart';
import 'package:lokus/routes/app_routes.dart';
import 'package:lokus/screens/splash/dashboard/dashboardscreen.dart';
import 'package:lokus/screens/map/mapscreen.dart';

class AppPages {
  static final List<GetPage> routes = [
    GetPage(name: AppRoutes.home, page: () => Dashboardscreen()),
    GetPage(name: AppRoutes.map, page: () => MapScreen()),
  ];
}
