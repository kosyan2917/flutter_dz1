import 'package:flutter/material.dart';
import 'package:flutter_dz1/data/api_service.dart';
import 'package:flutter_dz1/domain/api_provider.dart';
import 'package:flutter_dz1/domain/providers/post_provider.dart';
import 'package:flutter_dz1/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'UI/posts_page.dart';

const pageSize = 10;

void main() {
  runApp(
      ProviderScope(child: MyApp(apiProvider: PostProvider(NewsApiService()))));
}

class MyApp extends ConsumerWidget {
  final APIProvider apiProvider;

  const MyApp({super.key, required this.apiProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    return MaterialApp(
      title: 'News Dz',
      theme: themeState.themeData,
      home: PostsPage(apiProvider: apiProvider),
    );
  }
}
