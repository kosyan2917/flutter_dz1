import 'package:riverpod/riverpod.dart';

import '../data/models/news_model.dart';

class LikedList extends Notifier<List<Post>> {
  @override
  List<Post> build() {
    return [];
  }

  void add(Post post) {
    state = [...state, post];
  }

  void remove(Post post) {
    state = [
      for (final p in state)
        if (p.title != post.title) p,
    ];
  }

  bool has(String title) {
    for (final post in state) {
      if (post.title == title) return true;
    }
    return false;
  }
}

final likedListProvider =
    NotifierProvider<LikedList, List<Post>>(LikedList.new);
