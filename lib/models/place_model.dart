class Place {
  final String name;
  final String location;
  final String imageUrl;
  final String description;
  final String bestTime;
  final String budgetRange;
  final List<String> topAttractions;
  final String accommodation;
  final String transportation;
  final String cuisine;
  final String culturalTips;
  final String whyPerfect;

  Place({
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.description,
    required this.bestTime,
    required this.budgetRange,
    required this.topAttractions,
    required this.accommodation,
    required this.transportation,
    required this.cuisine,
    required this.culturalTips,
    required this.whyPerfect,
  });

  // Your existing parseFromAIResponse method
  static List<Place> parseFromAIResponse(String response) {
    // Your existing parsing logic here
    // This is for backward compatibility
    return [];
  }

  // New method to parse response with image URLs
  static List<Place> parseFromAIResponseWithImages(String response) {
    List<Place> places = [];
    
    try {
      // Split the response into individual place sections
      List<String> placeSections = response.split(RegExp(r'PLACE \d+:'));
      
      for (String section in placeSections) {
        if (section.trim().isEmpty) continue;
        
        // Extract each field using regex
        String name = _extractField(section, 'NAME');
        String location = _extractField(section, 'LOCATION');
        String imageUrl = _extractField(section, 'IMAGE_URL');
        String description = _extractField(section, 'DESCRIPTION');
        String bestTime = _extractField(section, 'BEST_TIME');
        String budgetRange = _extractField(section, 'BUDGET_RANGE');
        String attractionsStr = _extractField(section, 'TOP_ATTRACTIONS');
        String accommodation = _extractField(section, 'ACCOMMODATION');
        String transportation = _extractField(section, 'TRANSPORTATION');
        String cuisine = _extractField(section, 'CUISINE');
        String culturalTips = _extractField(section, 'CULTURAL_TIPS');
        String whyPerfect = _extractField(section, 'WHY_PERFECT');
        
        // Parse attractions list
        List<String> attractions = attractionsStr.split(';')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        
        // Create place object if we have minimum required fields
        if (name.isNotEmpty && location.isNotEmpty) {
          places.add(Place(
            name: name,
            location: location,
            imageUrl: imageUrl.isNotEmpty ? imageUrl : _getDefaultImageUrl(name),
            description: description,
            bestTime: bestTime,
            budgetRange: budgetRange,
            topAttractions: attractions,
            accommodation: accommodation,
            transportation: transportation,
            cuisine: cuisine,
            culturalTips: culturalTips,
            whyPerfect: whyPerfect,
          ));
        }
      }
    } catch (e) {
      print('Error parsing AI response: $e');
    }
    
    return places;
  }
  
  static String _extractField(String section, String fieldName) {
    try {
      RegExp regex = RegExp('$fieldName:\\s*(.+?)(?=\\n[A-Z_]+:|\\n\\n|\$)', 
          dotAll: true, multiLine: true);
      RegExpMatch? match = regex.firstMatch(section);
      return match?.group(1)?.trim() ?? '';
    } catch (e) {
      return '';
    }
  }
  
  static String _getDefaultImageUrl(String placeName) {
    // Fallback image URLs from Unsplash for Indian destinations
    Map<String, String> defaultImages = {
      'goa': 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800',
      'kerala': 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=800',
      'rajasthan': 'https://images.unsplash.com/photo-1477587458883-47145ed94245?w=800',
      'himachal': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
      'kashmir': 'https://images.unsplash.com/photo-1605640840605-14ac1855827b?w=800',
      'delhi': 'https://images.unsplash.com/photo-1587474260584-136574528ed5?w=800',
      'mumbai': 'https://images.unsplash.com/photo-1595658658481-d53d3f999875?w=800',
      'bangalore': 'https://images.unsplash.com/photo-1570168007204-dfb528c6958f?w=800',
      'kolkata': 'https://images.unsplash.com/photo-1558431382-27e303142255?w=800',
      'chennai': 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=800',
      'agra': 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=800',
      'jaipur': 'https://images.unsplash.com/photo-1477587458883-47145ed94245?w=800',
      'udaipur': 'https://images.unsplash.com/photo-1509023464722-18d996393ca8?w=800',
      'manali': 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=800',
      'shimla': 'https://images.unsplash.com/photo-1605640840605-14ac1855827b?w=800',
      'rishikesh': 'https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=800',
      'haridwar': 'https://images.unsplash.com/photo-1567157577867-05ccb1388e66?w=800',
      'varanasi': 'https://images.unsplash.com/photo-1561361513-2d000a50f0dc?w=800',
      'pushkar': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
      'hampi': 'https://images.unsplash.com/photo-1582659343788-d0d3d6e56626?w=800',
    };
    
    String key = placeName.toLowerCase();
    for (String city in defaultImages.keys) {
      if (key.contains(city)) {
        return defaultImages[city]!;
      }
    }
    
    // Generic India travel image if no match found
    return 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=800';
  }
}