import 'package:flutter_dz1/data/models/news_model.dart';
import 'package:flutter_dz1/data/api_service.dart';
import 'package:flutter_dz1/domain/api_provider.dart';

const int pageSize = 10;

class PostProvider implements APIProvider {
  final APIService apiService;

  PostProvider(this.apiService);

  @override
  Future<(List<Post>, int)> getPosts(int page) async {
    List<Post> result = [];
    final stories = await apiService.getStories(page);

    for (var story in stories['articles']) {
      Post post = Post(
          imageUrl: story['urlToImage'],
          title: story['title'],
          url: story['url'],
          content: story['content']);
      result.add(post);
    }
    return (result, int.parse(stories['totalResults'].toString()));
  }
}
