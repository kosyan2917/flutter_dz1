import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dz1/api_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dz1/theme/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _isDark = false;

  ThemeData getTheme() {
    if (_isDark) {
      return darkMode;
    }
    return lightMode;
  }

  void changeTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naviation Demo',
      theme: getTheme(),
      home: PostsPage(
        isDark: _isDark,
      ),
    );
  }
}

class PostsPage extends StatefulWidget {
  static final apiService = APIService();
  final bool isDark;

  PostsPage({super.key, required this.isDark});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final List<Widget> posts = [];

  void toggleTheme() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            color: Colors.blue,
            child: Row(
              children: [
                TextButton(
                    onPressed: MyApp.of(context).changeTheme,
                    child: Icon(Icons.dark_mode))
              ],
            ),
          ),
          FutureBuilder(
            future: fetchPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return Expanded(child: ListView(children: snapshot.data!));
            },
          ),
        ],
      ),
    ));
  }

  Future<List<Widget>> fetchPosts() async {
    final stories = await PostsPage.apiService.getStories();
    final List<Widget> posts = [];
    for (var story in stories['articles']) {
      print(story);
      posts.add(PostBlock(
        imageUrl: story['urlToImage'],
        title: story['title'],
        post: story,
      ));
    }
    return posts;
  }
}

class SinglePostPage extends StatelessWidget {
  final Object? post;

  const SinglePostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_left),
                    label: Text('Bababa'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shadowColor: Colors.transparent)),
                Container(
                    child: TextButton(
                  child: Icon(Icons.dark_mode),
                  onPressed: MyApp.of(context).changeTheme,
                ))
              ],
            ),
          )
        ],
      ),
    ));
  }
}

class PostBlock extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final Map<String, dynamic> post;

  const PostBlock(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Container(
                width: 150,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: imageUrl != null
                        ? Image.network(imageUrl!, errorBuilder:
                            (BuildContext context, Object exception,
                                StackTrace? stackTrace) {
                            return Image.asset("assets/mock.png");
                          })
                        : Image.asset("assets/mock.png")),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 3, right: 5, bottom: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(child: Text(title)),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: 100,
                        height: 30,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 1),
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                          child: Text("Читать",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              )),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SinglePostPage(post: post);
                            }));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
