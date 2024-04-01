import '../data/models/news_model.dart';

abstract class APIProvider {
  Future<(List<Post>, int)> getPosts(int page);
}
