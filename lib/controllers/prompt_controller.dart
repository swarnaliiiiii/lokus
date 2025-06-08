import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'inputcontroller.dart';
import 'package:lokus/screens/recommendations/travel_recs.dart';

class PromptController extends GetxController {
  final InputController inputcontroller = Get.find<InputController>();
  
  var isGenerating = false.obs;
  var prompt = ''.obs;
  var errorMessage = ''.obs;
  var generatedItinerary = ''.obs; // Add this to store the response
  
  String generatePrompt() {
    String basePrompt = "Generate a detailed travel itinerary based on the following preferences:\n";
    
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
      basePrompt += "Destination: ${inputcontroller.SelectedDestination.value}\n";
    } else {
      basePrompt += "Destination: Not specified\n";
    }
    
    basePrompt += "\nPlease provide:\n";
    basePrompt += "1. Recommended destinations (if not specified)\n";
    basePrompt += "2. Day-by-day itinerary\n";
    basePrompt += "3. Accommodation suggestions\n";
    basePrompt += "4. Transportation options\n";
    basePrompt += "5. Must-visit attractions based on interests\n";
    basePrompt += "6. Local food recommendations\n";
    basePrompt += "7. Budget breakdown (if budget specified)\n";
    basePrompt += "8. Packing suggestions\n";
    basePrompt += "9. Best time to visit\n";
    basePrompt += "10. Local tips and cultural insights\n";
    
    return basePrompt;
  }
  
  Future<void> generateTravelItinerary() async {
    try{
      isGenerating.value = true;
      errorMessage.value = '';
      
      String promptText = generatePrompt();
      
      final gemini = Gemini.instance;
      final response = await gemini.text(promptText);
      
      if (response?.output != null) {
        generatedItinerary.value = response!.output!;
        // Navigate to result screen
        Get.to(() => TravelItineraryResultScreen());
      }
      
    } catch (e) {
      errorMessage.value = 'Error generating itinerary: $e';
    } finally {
      isGenerating.value = false;
    }
  }
}
