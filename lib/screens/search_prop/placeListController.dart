import 'package:get/get.dart';
import 'package:lokus/screens/search_prop/place.dart';

class PlaceListController extends GetxController {
  RxList<Place> placelist = <Place>[
    Place(
      id: '1',
      displayName: 'Paris',
      country: 'France',
      description: 'The city of lights and love, home to the Eiffel Tower.',
      latitude: 48.8566,
      longitude: 2.3522,
    ),
    Place(
      id: '2',
      displayName: 'Tokyo',
      country: 'Japan',
      description: 'A bustling metropolis blending modern tech and tradition.',
      latitude: 35.6762,
      longitude: 139.6503,
    ),
    Place(
      id: '3',
      displayName: 'New York',
      country: 'USA',
      description: 'The Big Apple, famous for Times Square and Central Park.',
      latitude: 40.7128,
      longitude: -74.0060,
    ),
    // Indian Places
    Place(
      id: '4',
      displayName: 'Mumbai',
      country: 'India',
      description: 'The financial capital of India, home to Bollywood.',
      latitude: 19.0760,
      longitude: 72.8777,
    ),
    Place(
      id: '5',
      displayName: 'Delhi',
      country: 'India',
      description: 'The capital city with rich history and monuments.',
      latitude: 28.7041,
      longitude: 77.1025,
    ),
    Place(
      id: '6',
      displayName: 'Bangalore',
      country: 'India',
      description:
          'The Silicon Valley of India, known for its pleasant weather.',
      latitude: 12.9716,
      longitude: 77.5946,
    ),
    Place(
      id: '7',
      displayName: 'Goa',
      country: 'India',
      description: 'Beautiful beaches and Portuguese colonial architecture.',
      latitude: 15.2993,
      longitude: 74.1240,
    ),
    Place(
      id: '8',
      displayName: 'Jaipur',
      country: 'India',
      description: 'The Pink City, famous for palaces and forts.',
      latitude: 26.9124,
      longitude: 75.7873,
    ),
    Place(
      id: '9',
      displayName: 'Kerala',
      country: 'India',
      description: 'Gods Own Country with backwaters and hill stations.',
      latitude: 10.8505,
      longitude: 76.2711,
    ),
    Place(
      id: '10',
      displayName: 'Agra',
      country: 'India',
      description: 'Home to the magnificent Taj Mahal.',
      latitude: 27.1767,
      longitude: 78.0081,
    ),
  ].obs;
}
