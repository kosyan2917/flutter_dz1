import 'package:flutter_dz1/domain/api_provider.dart';

import '../../data/models/news_model.dart';

class MockProvider implements APIProvider {
  const MockProvider();

  @override
  Future<(List<Post>, int)> getPosts(int page) async {
    List<Post> result = [];
    result.add(Post(
        imageUrl:
            'https://dota2protracker.com/static/hero_images_jpg_res/leshrac_lg.jpg',
        title: 'Title 1',
        url: 'https://via.placeholder.com/150',
        content: 'Content 1'));
    result.add(Post(
        imageUrl: 'https://via.placeholder.com/150',
        title: 'Title 2',
        url: 'https://via.placeholder.com/150',
        content: null));
    result.add(Post(
        imageUrl: null,
        title: 'Title 3',
        url: 'https://via.placeholder.com/150',
        content: 'Content 3'));
    return (result, 3);
  }
}
