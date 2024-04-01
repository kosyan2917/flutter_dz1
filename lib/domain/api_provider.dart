import 'package:flutter_dz1/data/api_service.dart';

import '../data/models/news_model.dart';

abstract class APIProvider {
  Future<(List<Post>, int)> getPosts(int page);
}
