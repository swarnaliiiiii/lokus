import 'package:flutter/material.dart';
import 'package:lokus/app.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  String apiKey = dotenv.env['API_KEY'] ?? '';
  Gemini.init(apiKey: apiKey);
  runApp(const MyApp());
}
