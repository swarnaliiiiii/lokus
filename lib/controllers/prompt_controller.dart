import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'inputcontroller.dart';
import 'package:lokus/screens/recommendations/travel_recs.dart';
import 'package:lokus/models/place_model.dart';

class PromptController extends GetxController {
  final InputController inputcontroller = Get.find<InputController>();
  
  var isGenerating = false.obs;
  var prompt = ''.obs;
  var errorMessage = ''.obs;
  var recommendedPlaces = <Place>[].obs; // Store recommended places using Place model
  var generatedItinerary = ''.obs;
  
  String generatePlacesRecommendationPrompt() {
    String basePrompt = "Give me detailed and comprehensive information about 10 places/destinations based on the following inputs:\n\n";
    
    if(inputcontroller.SelectedDuration.value.isNotEmpty) {
      basePrompt += "Duration: ${inputcontroller.SelectedDuration.value}\n";
    } else {
      basePrompt += "Duration: Not specified\n";
    }
    
    if(inputcontroller.SelectedBudget.value.isNotEmpty) {
      basePrompt += "Budget: ${inputcontroller.SelectedBudget.value}\n";
    } else {
      basePrompt += "Budget: Not specified\n";
    }
    
    if(inputcontroller.SelectedPeople.value.isNotEmpty) {
      basePrompt += "Number of People: ${inputcontroller.SelectedPeople.value}\n";
    } else {
      basePrompt += "Number of People: Not specified\n";
    }
    
    if(inputcontroller.SelectedDestination.value.isNotEmpty) {
      basePrompt += "Preferred Region/Country: ${inputcontroller.SelectedDestination.value}\n";
    } else {
      basePrompt += "Preferred Region/Country: Not specified (suggest worldwide destinations)\n";
    }
    
    basePrompt += "\nFor each of the 10 recommended places, please provide:\n";
    basePrompt += "1. Place name and location\n";
    basePrompt += "2. Brief description (2-3 sentences)\n";
    basePrompt += "3. Best time to visit\n";
    basePrompt += "4. Estimated budget range for the specified duration\n";
    basePrompt += "5. Top 3 attractions/activities\n";
    basePrompt += "6. Accommodation type recommendations\n";
    basePrompt += "7. Transportation options to reach there\n";
    basePrompt += "8. Local cuisine highlights\n";
    basePrompt += "9. Cultural tips or important notes\n";
    basePrompt += "10. Why it's perfect for the specified group size and budget\n\n";
    
    basePrompt += "Please format the response clearly with each place as a separate section, numbered 1-10.\n";
    basePrompt += "Make sure all recommendations align with the specified budget and duration constraints.";
    
    return basePrompt;
  }
  
  String generateDetailedItineraryPrompt(String selectedPlace) {
    String basePrompt = "Generate a detailed travel itinerary for ${selectedPlace} based on the following preferences:\n\n";
    
    if(inputcontroller.SelectedDuration.value.isNotEmpty) {
      basePrompt += "Duration: ${inputcontroller.SelectedDuration.value}\n";
    }
    
    if(inputcontroller.SelectedBudget.value.isNotEmpty) {
      basePrompt += "Budget: ${inputcontroller.SelectedBudget.value}\n";
    }
    
    if(inputcontroller.SelectedPeople.value.isNotEmpty) {
      basePrompt += "Number of People: ${inputcontroller.SelectedPeople.value}\n";
    }
    
    basePrompt += "Destination: ${selectedPlace}\n\n";
    
    basePrompt += "Please provide:\n";
    basePrompt += "1. Day-by-day detailed itinerary\n";
    basePrompt += "2. Specific accommodation recommendations with price ranges\n";
    basePrompt += "3. Transportation options and costs\n";
    basePrompt += "4. Must-visit attractions with timings and entry fees\n";
    basePrompt += "5. Restaurant recommendations for each meal\n";
    basePrompt += "6. Detailed budget breakdown\n";
    basePrompt += "7. Packing checklist\n";
    basePrompt += "8. Local customs and etiquette\n";
    basePrompt += "9. Emergency contacts and important addresses\n";
    basePrompt += "10. Weather information and what to expect\n";
    
    return basePrompt;
  }
  
  Future<void> generatePlacesRecommendations() async {
    try {
      isGenerating.value = true;
      errorMessage.value = '';
      recommendedPlaces.clear();
      
      String promptText = generatePlacesRecommendationPrompt();
      
      final gemini = Gemini.instance;
      final response = await gemini.text(promptText);
      
      if (response?.output != null) {
        // Parse the response to extract place information
        List<Place> places = Place.parseFromAIResponse(response!.output!);
        recommendedPlaces.value = places;
        
        // Navigate to places recommendation screen
        Get.to(() => PlacesRecommendationScreen(places: places));
      }
      
    } catch (e) {
      errorMessage.value = 'Error generating place recommendations: $e';
    } finally {
      isGenerating.value = false;
    }
  }
  
  Future<void> generateDetailedItinerary(String selectedPlace) async {
    try {
      isGenerating.value = true;
      errorMessage.value = '';
      
      String promptText = generateDetailedItineraryPrompt(selectedPlace);
      
      final gemini = Gemini.instance;
      final response = await gemini.text(promptText);
      
      if (response?.output != null) {
        generatedItinerary.value = response!.output!;
        // TODO: Replace with the correct screen for showing detailed itinerary
        // For now, just pop up a dialog or navigate to a placeholder screen
        // Example: Get.to(() => DetailedItineraryScreen(itinerary: generatedItinerary.value));
      }
      
    } catch (e) {
      errorMessage.value = 'Error generating detailed itinerary: $e';
    } finally {
      isGenerating.value = false;
    }
  }
  
  // Legacy method for backward compatibility
  Future<void> generateTravelItinerary() async {
    await generatePlacesRecommendations();
  }
}