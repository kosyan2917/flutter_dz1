import 'package:http/http.dart' as http;
import 'dart:convert';
import 'secrets.dart';

class APIService {
  static const String url =
      "https://newsapi.org/v2/top-headlines?pageSize=10&country=us&apiKey=$apiKey";

  APIService();

  Future<dynamic> getStories({int page = 1}) async {
    final response = await http.get(Uri.parse('$url&page=$page'));
    return json.decode(response.body);
  }
}
