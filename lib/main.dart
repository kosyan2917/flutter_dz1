import 'package:flutter/material.dart';
import 'package:flutter_dz1/api_service.dart';
import 'package:flutter_dz1/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

const pageSize = 10;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: MyApp.of(context).changeTheme,
                  child: Icon(
                    Icons.brightness_6,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                )
              ],
            ),
          ),
          FutureBuilder(
            future: fetchPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
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
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
    final stories = await PostsPage.apiService.getStories(page: _currentPage);
    final List<Widget> posts = [];
    for (var story in stories['articles']) {
      posts.add(PostBlock(
        imageUrl: story['urlToImage'],
        title: story['title'],
        post: story,
      ));
    }
    return (posts, int.parse(stories['totalResults'].toString()));
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
        child: Icon(Icons.arrow_left),
      ),
    ));
    pages.add(SizedBox(
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
      pages.add(SizedBox(
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
        child: Icon(Icons.arrow_right),
      ),
    ));
    return pages;
  }
}

class SinglePostPage extends StatelessWidget {
  final Map post;

  const SinglePostPage({super.key, required this.post});

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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_left),
                    label: Text('Назад'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shadowColor: Colors.transparent)),
                TextButton(
                  onPressed: MyApp.of(context).changeTheme,
                  child: Icon(
                    Icons.brightness_6,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(post['title'],
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: post['urlToImage'] != null
                      ? Image.network(post['urlToImage']!, errorBuilder:
                          (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                          return Image.asset("assets/mock.png");
                        })
                      : Image.asset("assets/mock.png"),
                ),
                SizedBox(
                  height: 10,
                ),
                post['content'] != null
                    ? Text(post['content'])
                    : Text(
                        "API для этой новости не вернул никакого содержания. Ознакомтесь с полной новостью по нажав на кнопку снизу."),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1),
                            borderRadius: BorderRadius.circular(10)))),
                    onPressed: _launchURL,
                    child: Text("Читать полностью",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ))),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  _launchURL() async {
    final url = post['url'];
    await launchUrl(Uri.parse(url));
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
              child: SizedBox(
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
                    Text(title),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: 100,
                        height: 30,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.primary),
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
