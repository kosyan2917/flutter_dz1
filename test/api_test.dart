import 'package:flutter_dz1/data/api_service.dart';
import 'package:flutter_dz1/data/models/news_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dz1/domain/providers/post_provider.dart';


void main() {
  group('PostProvider', () {
    test('getPosts returns a list of posts and total results', () async {
      final postProvider = PostProvider(NewsApiService());
      final result = await postProvider.getPosts(1);
      expect(result.$1, isA<List<Post>>());
      expect(result.$1[0].imageUrl, 'testImageUrl');
      expect(result.$1[0].title, 'testTitle');
      expect(result.$1[0].url, 'testUrl');
      expect(result.$1[0].content, 'testContent');
      expect(result.$2, 1);
    });
  });
}