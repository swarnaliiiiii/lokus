import 'package:get/get.dart';
import '/routes/app_routes.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;
  
  final List<String> routes = [
    AppRoutes.home,
    AppRoutes.explore,
    AppRoutes.map,
    AppRoutes.tour,
    AppRoutes.profile,
  ];

  void changePage(int index) {
    currentIndex.value = index;
    Get.offAllNamed(routes[index]);
  }
}
