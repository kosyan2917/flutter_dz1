import 'package:http/http.dart' as http;
import 'dart:convert';
import 'secrets.dart';

abstract class APIService {
  Future<dynamic> getStories(int page);

}

class NewsApiService implements APIService {
  static const String url =
      "https://newsapi.org/v2/top-headlines?pageSize=10&country=us&apiKey=$apiKey";

  @override
  Future<dynamic> getStories(int page) async {
    final response = await http.get(Uri.parse('$url&page=$page'));
    return json.decode(response.body);
  }
}

class MockApiService implements APIService {

  @override
  Future<dynamic> getStories(int page) async {
    return {
      'articles': [
        {
          'urlToImage': 'testImageUrl',
          'title': 'testTitle',
          'url': 'testUrl',
          'content': 'testContent'
        }
      ],
      'totalResults': 'b'
    };
  }

}