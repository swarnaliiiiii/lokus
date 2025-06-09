class Place {
  final String name;
  final String location;
  final String description;
  final String bestTime;
  final String budgetRange;
  final List<String> topAttractions;
  final String accommodationType;
  final String transportation;
  final String localCuisine;
  final String culturalTips;
  final String whyPerfect;
  final String? imageUrl;
  final double? rating;
  
  Place({
    required this.name,
    required this.location,
    required this.description,
    required this.bestTime,
    required this.budgetRange,
    required this.topAttractions,
    required this.accommodationType,
    required this.transportation,
    required this.localCuisine,
    required this.culturalTips,
    required this.whyPerfect,
    this.imageUrl,
    this.rating,
  });
  
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      bestTime: json['bestTime'] ?? '',
      budgetRange: json['budgetRange'] ?? '',
      topAttractions: List<String>.from(json['topAttractions'] ?? []),
      accommodationType: json['accommodationType'] ?? '',
      transportation: json['transportation'] ?? '',
      localCuisine: json['localCuisine'] ?? '',
      culturalTips: json['culturalTips'] ?? '',
      whyPerfect: json['whyPerfect'] ?? '',
      imageUrl: json['imageUrl'],
      rating: json['rating']?.toDouble(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'description': description,
      'bestTime': bestTime,
      'budgetRange': budgetRange,
      'topAttractions': topAttractions,
      'accommodationType': accommodationType,
      'transportation': transportation,
      'localCuisine': localCuisine,
      'culturalTips': culturalTips,
      'whyPerfect': whyPerfect,
      'imageUrl': imageUrl,
      'rating': rating,
    };
  }
  
  // Parse AI response to extract place information
  static List<Place> parseFromAIResponse(String aiResponse) {
    List<Place> places = [];
    
    try {
      // Split by numbered sections (1., 2., 3., etc.)
      List<String> sections = aiResponse.split(RegExp(r'\n\s*\d+\.\s*'));
      
      for (int i = 1; i < sections.length && places.length < 10; i++) {
        String section = sections[i].trim();
        if (section.isNotEmpty) {
          Place place = _parseIndividualPlace(section, i);
          places.add(place);
        }
      }
    } catch (e) {
      print('Error parsing AI response: $e');
      // Return dummy data if parsing fails
      return _generateDummyPlaces();
    }
    
    // Ensure we have at least some places
    if (places.isEmpty) {
      return _generateDummyPlaces();
    }
    
    return places;
  }
  
  static Place _parseIndividualPlace(String section, int index) {
    // Extract place name (usually the first line or after location indicators)
    String name = _extractPlaceName(section, index);
    
    return Place(
      name: name,
      location: _extractLocation(section),
      description: _extractDescription(section),
      bestTime: _extractBestTime(section),
      budgetRange: _extractBudgetRange(section),
      topAttractions: _extractAttractions(section),
      accommodationType: _extractAccommodation(section),
      transportation: _extractTransportation(section),
      localCuisine: _extractCuisine(section),
      culturalTips: _extractCulturalTips(section),
      whyPerfect: _extractWhyPerfect(section),
      rating: 4.0 + (index % 10) * 0.2, // Generate random rating
    );
  }
  
  static String _extractPlaceName(String section, int index) {
    // Look for place name patterns
    List<String> lines = section.split('\n');
    for (String line in lines) {
      line = line.trim();
      if (line.isNotEmpty && !line.startsWith('Duration:') && 
          !line.startsWith('Budget:') && !line.startsWith('Number:')) {
        // Remove any numbering or formatting
        line = line.replaceAll(RegExp(r'^\d+\.\s*'), '');
        line = line.replaceAll(RegExp(r'^Place name[:\s]*', caseSensitive: false), '');
        if (line.length > 3 && line.length < 100) {
          return line.split('\n')[0].trim();
        }
      }
    }
    return 'Destination $index';
  }
  
  static String _extractLocation(String section) {
    RegExp locationRegex = RegExp(r'location[:\s]*([^\n]+)', caseSensitive: false);
    Match? match = locationRegex.firstMatch(section);
    return match?.group(1)?.trim() ?? 'Beautiful Location';
  }
  
  static String _extractDescription(String section) {
    RegExp descRegex = RegExp(r'description[:\s]*([^\n]+(?:\n[^0-9\n][^\n]*)*)', caseSensitive: false);
    Match? match = descRegex.firstMatch(section);
    String description = match?.group(1)?.trim() ?? '';
    
    if (description.isEmpty) {
      // Get first few sentences as description
      List<String> sentences = section.split(RegExp(r'[.!?]+'));
      description = sentences.take(2).join('. ').trim();
      if (description.isNotEmpty && !description.endsWith('.')) {
        description += '.';
      }
    }
    
    return description.isNotEmpty ? description : 'A wonderful destination waiting to be explored.';
  }
  
  static String _extractBestTime(String section) {
    RegExp timeRegex = RegExp(r'best time[:\s]*([^\n]+)', caseSensitive: false);
    Match? match = timeRegex.firstMatch(section);
    return match?.group(1)?.trim() ?? 'Year-round';
  }
  
  static String _extractBudgetRange(String section) {
    RegExp budgetRegex = RegExp(r'budget[^:]*[:\s]*([^\n]+)', caseSensitive: false);
    Match? match = budgetRegex.firstMatch(section);
    return match?.group(1)?.trim() ?? '\$500 - \$1500';
  }
  
  static List<String> _extractAttractions(String section) {
    List<String> attractions = [];
    
    // Look for numbered attractions or bullet points
    RegExp attractionRegex = RegExp(r'(?:attractions?|activities)[^:]*:([^0-9]+?)(?=\d+\.|$)', caseSensitive: false, dotAll: true);
    Match? match = attractionRegex.firstMatch(section);
    
    if (match != null) {
      String attractionsText = match.group(1) ?? '';
      // Split by common delimiters
      attractions = attractionsText
          .split(RegExp(r'[•\-\n]'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty && e.length > 3)
          .take(3)
          .toList();
    }
    
    if (attractions.isEmpty) {
      attractions = ['Historic Sites', 'Natural Beauty', 'Local Culture'];
    }
    
    return attractions;
  }
  
  static String _extractAccommodation(String section) {
    RegExp accomRegex = RegExp(r'accommodation[^:]*[:\s]*([^\n]+)', caseSensitive: false);
    Match? match = accomRegex.firstMatch(section);
    return match?.group(1)?.trim() ?? 'Hotels, Resorts, Guesthouses';
  }
  
  static String _extractTransportation(String section) {
    RegExp transportRegex = RegExp(r'transportation[^:]*[:\s]*([^\n]+)', caseSensitive: false);
    Match? match = transportRegex.firstMatch(section);
    return match?.group(1)?.trim() ?? 'Flights and local transport available';
  }
  
  static String _extractCuisine(String section) {
    RegExp cuisineRegex = RegExp(r'(?:cuisine|food)[^:]*[:\s]*([^\n]+)', caseSensitive: false);
    Match? match = cuisineRegex.firstMatch(section);
    return match?.group(1)?.trim() ?? 'Delicious local and international cuisine';
  }
  
  static String _extractCulturalTips(String section) {
    RegExp tipsRegex = RegExp(r'(?:cultural|tips|customs)[^:]*[:\s]*([^\n]+)', caseSensitive: false);
    Match? match = tipsRegex.firstMatch(section);
    return match?.group(1)?.trim() ?? 'Respect local customs and traditions';
  }
  
  static String _extractWhyPerfect(String section) {
    RegExp whyRegex = RegExp(r'(?:why|perfect)[^:]*[:\s]*([^\n]+)', caseSensitive: false);
    Match? match = whyRegex.firstMatch(section);
    return match?.group(1)?.trim() ?? 'Perfect destination for your travel preferences';
  }
  
  static List<Place> _generateDummyPlaces() {
    return List.generate(10, (index) {
      return Place(
        name: _dummyPlaceNames[index],
        location: _dummyLocations[index],
        description: _dummyDescriptions[index],
        bestTime: _dummyBestTimes[index % _dummyBestTimes.length],
        budgetRange: '\${500 + (index * 150)} - \${1200 + (index * 200)}',
        topAttractions: _dummyAttractions[index],
        accommodationType: 'Hotels, Resorts, Local stays',
        transportation: 'International flights, Local transport',
        localCuisine: _dummyCuisines[index],
        culturalTips: 'Respect local customs and dress modestly at religious sites',
        whyPerfect: 'Perfect blend of ${_dummyFeatures[index]} that matches your travel style',
        rating: 4.0 + (index * 0.2),
      );
    });
  }
  
  static const List<String> _dummyPlaceNames = [
    'Santorini', 'Kyoto', 'Machu Picchu', 'Bali', 'Iceland',
    'Morocco', 'New Zealand', 'Costa Rica', 'Norway', 'Thailand'
  ];
  
  static const List<String> _dummyLocations = [
    'Greece', 'Japan', 'Peru', 'Indonesia', 'Nordic Region',
    'North Africa', 'Oceania', 'Central America', 'Scandinavia', 'Southeast Asia'
  ];
  
  static const List<String> _dummyDescriptions = [
    'Experience stunning sunsets and white-washed buildings overlooking the Aegean Sea.',
    'Discover ancient temples, traditional gardens, and the perfect blend of old and new.',
    'Trek through mystical mountains to reach the ancient Incan citadel in the clouds.',
    'Enjoy tropical paradise with beautiful beaches, lush rice terraces, and rich culture.',
    'Witness the Northern Lights, geysers, and dramatic volcanic landscapes.',
    'Explore vibrant markets, desert landscapes, and stunning Islamic architecture.',
    'Adventure through diverse landscapes from mountains to fjords and pristine beaches.',
    'Discover incredible biodiversity, zip-line through cloud forests, and relax on pristine beaches.',
    'Cruise through majestic fjords and experience the land of the midnight sun.',
    'Experience golden temples, floating markets, and some of the world\'s best street food.'
  ];
  
  static const List<String> _dummyBestTimes = [
    'April - October', 'March - May & September - November', 'May - September',
    'April - September', 'June - August', 'October - April'
  ];
  
  static const List<List<String>> _dummyAttractions = [
    ['Oia Village', 'Red Beach', 'Ancient Akrotiri'],
    ['Fushimi Inari Shrine', 'Bamboo Grove', 'Kiyomizu Temple'],
    ['Machu Picchu Citadel', 'Huayna Picchu', 'Sacred Valley'],
    ['Uluwatu Temple', 'Rice Terraces', 'Mount Batur'],
    ['Blue Lagoon', 'Northern Lights', 'Golden Circle'],
    ['Marrakech Medina', 'Sahara Desert', 'Atlas Mountains'],
    ['Milford Sound', 'Hobbiton', 'Franz Josef Glacier'],
    ['Manuel Antonio', 'Monteverde', 'Arenal Volcano'],
    ['Geiranger Fjord', 'Lofoten Islands', 'Northern Lights'],
    ['Grand Palace', 'Floating Markets', 'Phi Phi Islands']
  ];
  
  static const List<String> _dummyCuisines = [
    'Fresh seafood, Greek salads, and local wines',
    'Sushi, ramen, kaiseki, and matcha delicacies',
    'Quinoa dishes, ceviche, and traditional Andean cuisine',
    'Nasi goreng, satay, fresh tropical fruits',
    'Fresh seafood, lamb, and Nordic specialties',
    'Tagines, couscous, mint tea, and pastries',
    'Lamb, seafood, Pavlova, and local wines',
    'Gallo pinto, fresh fruits, and coffee',
    'Salmon, reindeer, and traditional Nordic fare',
    'Pad Thai, green curry, mango sticky rice'
  ];
  
  static const List<String> _dummyFeatures = [
    'romance and stunning views',
    'culture and tranquility',
    'adventure and history',
    'relaxation and spirituality',
    'nature and adventure',
    'culture and exotic experiences',
    'adventure and natural beauty',
    'eco-tourism and adventure',
    'natural wonders and serenity',
    'culture and culinary delights'
  ];
}