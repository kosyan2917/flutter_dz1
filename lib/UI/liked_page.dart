import 'package:flutter_dz1/UI/post_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dz1/domain/liked_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme_change_button.dart';

class LikedPage extends ConsumerWidget {
  const LikedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedPosts = ref.watch(likedListProvider);
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_left),
                    label: const Text('Назад'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shadowColor: Colors.transparent)),
                const ThemeChangeButton()
              ],
            ),
          ),
          Expanded(
              child: ListView(
                children: [
                  for (final post in likedPosts)
                    PostBlock(imageUrl: post.imageUrl, title: post.title, post: post)
                ],
              )
          )
        ],
      )),
    );
  }
}
