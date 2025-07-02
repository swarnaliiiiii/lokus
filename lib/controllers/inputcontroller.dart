import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputController extends GetxController {
  var SelectedDuration = ''.obs;
  var SelectedBudget = ''.obs;
  var SelectedPeople = ''.obs;
  var SelectedDestination = ''.obs;
  var SelectedFromLocation = ''.obs;
  var SelectedToLocation = ''.obs;
  var SelectedStartDate = ''.obs;
  var SelectedEndDate = ''.obs;

  final List<String> durationOptions = [
    'Weekend Getaway',
    'Short Trip',
    'Week-long Trip',
    'Extended Trip',
  ];
  
  final List<String> budgetOptions = [
    'Budget',
    'Moderate',
    'Comfortable',
    'Premium',
  ];

  final List<String> peopleOptions = [
    'Solo Traveler',
    'Couple',
    'Family of 4',
    'Group',
  ];

  final List<String> destinationOptions = [
    'Beach & Coastal',
    'Mountain & Hills',
    'City & Urban',
    'Desert & Wilderness',
    'Historical & Cultural',
    'Adventure & Sports',
    'Spiritual & Religious',
    'Wildlife & Nature',
    'Island Paradise',
    'Countryside & Rural',
  ];

  @override
  void onInit() {
    super.onInit();
    loadSavedPreferences();
  }

  Future<void> loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    SelectedDuration.value = prefs.getString('SelectedDuration') ?? '';
    SelectedBudget.value = prefs.getString('SelectedBudget') ?? '';
    SelectedPeople.value = prefs.getString('SelectedPeople') ?? '';
    SelectedDestination.value = prefs.getString('SelectedDestination') ?? '';
    SelectedFromLocation.value = prefs.getString('SelectedFromLocation') ?? '';
    SelectedToLocation.value = prefs.getString('SelectedToLocation') ?? '';
    SelectedStartDate.value = prefs.getString('SelectedStartDate') ?? '';
    SelectedEndDate.value = prefs.getString('SelectedEndDate') ?? '';
  }

  Future<void> setTravelDuration(String duration) async {
    SelectedDuration.value = duration;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('SelectedDuration', duration);
  }

  Future<void> setTravelBudget(String budget) async {
    SelectedBudget.value = budget;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('SelectedBudget', budget);
  }

  Future<void> setTravelPeople(String people) async {
    SelectedPeople.value = people;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('SelectedPeople', people);
  }

  Future<void> setTravelDestination(String destination) async {
    SelectedDestination.value = destination;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('SelectedDestination', destination);
  }

  Future<void> setFromLocation(String fromLocation) async {
    SelectedFromLocation.value = fromLocation;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('SelectedFromLocation', fromLocation);
  }

  Future<void> setToLocation(String toLocation) async {
    SelectedToLocation.value = toLocation;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('SelectedToLocation', toLocation);
  }

  Future<void> setStartDate(String startDate) async {
    SelectedStartDate.value = startDate;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('SelectedStartDate', startDate);
  }

  Future<void> setEndDate(String endDate) async {
    SelectedEndDate.value = endDate;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('SelectedEndDate', endDate);
  }

  bool isDurationSelected(String duration) {
    return SelectedDuration.value == duration;
  }
  bool isBudgetSelected(String budget) {
    return SelectedBudget.value == budget;
  }
  bool isPeopleSelected(String people) {
    return SelectedPeople.value == people;
  }
  bool isDestinationSelected(String destination) {
    return SelectedDestination.value == destination;
  }

  Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('SelectedDuration');
    await prefs.remove('SelectedBudget');
    await prefs.remove('SelectedPeople');
    await prefs.remove('SelectedDestination');
    await prefs.remove('SelectedFromLocation');
    await prefs.remove('SelectedToLocation');
    await prefs.remove('SelectedStartDate');
    await prefs.remove('SelectedEndDate');
    SelectedDuration.value = '';
    SelectedBudget.value = '';
    SelectedPeople.value = '';
    SelectedDestination.value = '';
    SelectedFromLocation.value = '';
    SelectedToLocation.value = '';
    SelectedStartDate.value = '';
    SelectedEndDate.value = '';
    return;
  }

  String getFormatedPreference() {
    return 'Duration: ${SelectedDuration.value}, Budget: ${SelectedBudget.value}, People: ${SelectedPeople.value}, Destination: ${SelectedDestination.value}, From: ${SelectedFromLocation.value}, To: ${SelectedToLocation.value}, Start Date: ${SelectedStartDate.value}, End Date: ${SelectedEndDate.value}';
  }
}