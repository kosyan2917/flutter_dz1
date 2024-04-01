import 'package:flutter/material.dart';
import 'package:flutter_dz1/UI/liked_page.dart';
import 'package:flutter_dz1/UI/theme_change_button.dart';
import 'package:flutter_dz1/domain/api_provider.dart';
import 'package:flutter_dz1/UI/post_block.dart';

const pageSize = 10;

class PostsPage extends StatefulWidget {
  final APIProvider apiProvider;

  const PostsPage({super.key, required this.apiProvider});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late int _currentPage;

  @override
  initState() {
    super.initState();
    _currentPage = 1;
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return const LikedPage();
                  })),
                  label: const Text(
                    "Мне понравились",
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shadowColor: Colors.transparent),
                  icon: const Icon(Icons.favorite_border),
                ),
                const ThemeChangeButton()
              ],
            ),
          ),
          FutureBuilder(
            future: fetchPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator()),
                  ),
                );
              }
              if (snapshot.hasError) {
                throw snapshot.error!;
              }
              return Expanded(
                  child: ListView(
                      children: snapshot.data!.$1 +
                          [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: makePagination(snapshot.data!.$2),
                              ),
                            )
                          ]));
            },
          ),
        ],
      ),
    ));
  }

  Future<(List<Widget>, int)> fetchPosts() async {
    final stories = await widget.apiProvider.getPosts(_currentPage);
    final List<Widget> posts = [];
    for (var story in stories.$1) {
      posts.add(PostBlock(
        imageUrl: story.imageUrl,
        title: story.title,
        post: story,
      ));
    }
    return (posts, stories.$2);
  }

  List<Widget> makePagination(int count) {
    ButtonStyle pressedButton = ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 1),
            borderRadius: BorderRadius.circular(10))));

    ButtonStyle buttonStyle = ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).colorScheme.background),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 1),
            borderRadius: BorderRadius.circular(10))));

    List<Widget> pages = [];
    pages.add(Flexible(
      child: TextButton(
        style: buttonStyle,
        onPressed: () {
          if (_currentPage > 1) {
            setState(() {
              _currentPage = _currentPage - 1;
            });
          }
        },
        child: const Icon(Icons.arrow_left),
      ),
    ));
    pages.add(const SizedBox(
      width: 10,
    ));
    for (var i = 0; i < count / pageSize; i++) {
      if (i + 1 == _currentPage) {
        pages.add(Flexible(
          child: TextButton(
              style: pressedButton,
              onPressed: () {
                setState(() {
                  _currentPage = i + 1;
                });
              },
              child: Text(
                (i + 1).toString(),
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              )),
        ));
      } else {
        pages.add(Flexible(
          child: TextButton(
              style: buttonStyle,
              onPressed: () {
                setState(() {
                  _currentPage = i + 1;
                });
              },
              child: Text(
                (i + 1).toString(),
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              )),
        ));
      }
      pages.add(const SizedBox(
        width: 10,
      ));
    }
    pages.add(Flexible(
      child: TextButton(
        style: buttonStyle,
        onPressed: () {
          if (_currentPage < count / pageSize) {
            setState(() {
              _currentPage = _currentPage + 1;
            });
          }
        },
        child: const Icon(Icons.arrow_right),
      ),
    ));
    return pages;
  }
}
