import 'package:flutter/material.dart';
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
  var recommendedPlaces = <Place>[].obs;
  var generatedItinerary = ''.obs;

  String generatePlacesRecommendationPrompt() {
    String basePrompt =
        "Give me detailed and comprehensive information about 10 places/destinations based on the following inputs:\n\n";

    if (inputcontroller.SelectedDuration.value.isNotEmpty) {
      basePrompt += "Duration: ${inputcontroller.SelectedDuration.value}\n";
    } else {
      basePrompt += "Duration: Not specified\n";
    }

    if (inputcontroller.SelectedBudget.value.isNotEmpty) {
      basePrompt += "Budget: ${inputcontroller.SelectedBudget.value}\n";
    } else {
      basePrompt += "Budget: Not specified\n";
    }

    if (inputcontroller.SelectedPeople.value.isNotEmpty) {
      basePrompt +=
          "Number of People: ${inputcontroller.SelectedPeople.value}\n";
    } else {
      basePrompt += "Number of People: Not specified\n";
    }

    if (inputcontroller.SelectedDestination.value.isNotEmpty) {
      basePrompt +=
          "Preferred Region/Country: ${inputcontroller.SelectedDestination.value}\n";
    } else {
      basePrompt +=
          "Preferred Region/Country: India (suggest destinations within India only)\n";
    }

    basePrompt +=
        "\nFor each of the 10 recommended places, please provide the information in this EXACT format:\n\n";
    basePrompt += "PLACE [NUMBER]:\n";
    basePrompt += "NAME: [Place name]\n";
    basePrompt += "LOCATION: [City, Country]\n";
    basePrompt +=
        "IMAGE_URL: [Provide a high-quality landscape/travel image URL for this destination from a reliable source like Unsplash, Pexels, or other free image services]\n";
    basePrompt += "DESCRIPTION: [Brief description in 2-3 sentences]\n";
    basePrompt += "BEST_TIME: [Best time to visit]\n";
    basePrompt +=
        "BUDGET_RANGE: [Estimated budget range for the specified duration]\n";
    basePrompt +=
        "TOP_ATTRACTIONS: [List 3 main attractions separated by semicolons]\n";
    basePrompt += "ACCOMMODATION: [Accommodation type recommendations]\n";
    basePrompt += "TRANSPORTATION: [Transportation options to reach there]\n";
    basePrompt += "CUISINE: [Local cuisine highlights]\n";
    basePrompt += "CULTURAL_TIPS: [Cultural tips or important notes]\n";
    basePrompt +=
        "WHY_PERFECT: [Why it's perfect for the specified group size and budget]\n\n";

    basePrompt +=
        "IMPORTANT: Please ensure you provide valid, accessible image URLs for each destination. Use high-quality landscape photos that showcase the beauty of each place.\n";
    basePrompt +=
        "Focus on destinations within India only - include popular tourist destinations, hill stations, beaches, historical sites, and cultural destinations across different states of India.\n";
    basePrompt +=
        "Make sure all recommendations align with the specified budget and duration constraints.\n";
    basePrompt += "Please follow the exact format above for easy parsing.";

    return basePrompt;
  }

  String generateDetailedItineraryPrompt(String selectedPlace) {
    String basePrompt =
        "Generate a detailed travel itinerary for ${selectedPlace} based on the following preferences:\n\n";

    if (inputcontroller.SelectedDuration.value.isNotEmpty) {
      basePrompt += "Duration: ${inputcontroller.SelectedDuration.value}\n";
    }

    if (inputcontroller.SelectedBudget.value.isNotEmpty) {
      basePrompt += "Budget: ${inputcontroller.SelectedBudget.value}\n";
    }

    if (inputcontroller.SelectedPeople.value.isNotEmpty) {
      basePrompt +=
          "Number of People: ${inputcontroller.SelectedPeople.value}\n";
    }

    basePrompt += "Destination: ${selectedPlace}\n\n";

    basePrompt += "Please provide:\n";
    basePrompt += "1. Day-by-day detailed itinerary\n";
    basePrompt +=
        "2. Specific accommodation recommendations with price ranges\n";
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

  // Method with navigation (for backward compatibility)
  Future<void> generatePlacesRecommendations() async {
    try {
      isGenerating.value = true;
      errorMessage.value = '';
      recommendedPlaces.clear();

      String promptText = generatePlacesRecommendationPrompt();

      final gemini = Gemini.instance;
      final response = await gemini.text(promptText);

      if (response?.output != null) {
        // Parse the response to extract place information with image URLs
        List<Place> places =
            Place.parseFromAIResponseWithImages(response!.output!);
        recommendedPlaces.value = places;

        // Only navigate if we have places to show
        if (places.isNotEmpty) {
          Get.to(() => PlacesRecommendationScreen(places: places));
        } else {
          errorMessage.value = 'No places found in the response';
        }
      } else {
        errorMessage.value = 'No response received from AI service';
      }
    } catch (e) {
      errorMessage.value = 'Error generating place recommendations: $e';
      print('Error in generatePlacesRecommendations: $e');
    } finally {
      isGenerating.value = false;
    }
  }

  // Method without navigation (for use in TravelRecommendationsScreen)
  Future<void> generatePlacesRecommendationsWithoutNavigation() async {
    try {
      isGenerating.value = true;
      errorMessage.value = '';

      // Don't clear existing places, append new ones
      String promptText = generatePlacesRecommendationPrompt();

      final gemini = Gemini.instance;
      final response = await gemini.text(promptText);

      if (response?.output != null) {
        // Parse the response to extract place information with image URLs
        List<Place> newPlaces =
            Place.parseFromAIResponseWithImages(response!.output!);

        // Filter out duplicates based on place name
        List<Place> filteredPlaces = newPlaces
            .where((newPlace) => !recommendedPlaces.any((existingPlace) =>
                existingPlace.name.toLowerCase() ==
                newPlace.name.toLowerCase()))
            .toList();

        // Add new places to existing list
        recommendedPlaces.addAll(filteredPlaces);
      } else {
        errorMessage.value = 'No response received from AI service';
      }
    } catch (e) {
      errorMessage.value = 'Error generating place recommendations: $e';
      print('Error in generatePlacesRecommendationsWithoutNavigation: $e');
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
        // For now, just show a success message
        Get.snackbar(
          'Success',
          'Itinerary generated successfully',
          backgroundColor: Get.theme.primaryColor,
          colorText: Color(Get.theme.primaryColor.value),
        );
      } else {
        errorMessage.value = 'No itinerary generated';
      }
    } catch (e) {
      errorMessage.value = 'Error generating detailed itinerary: $e';
      print('Error in generateDetailedItinerary: $e');
    } finally {
      isGenerating.value = false;
    }
  }

  // Legacy method for backward compatibility
  Future<void> generateTravelItinerary() async {
    await generatePlacesRecommendations();
  }
}
