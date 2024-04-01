import 'package:flutter/material.dart';
import 'package:flutter_dz1/UI/theme_change_button.dart';
import 'package:flutter_dz1/domain/liked_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dz1/data/models/news_model.dart';

class SinglePostPage extends ConsumerWidget {
  final Post post;

  const SinglePostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(likedListProvider);
    ButtonStyle buttonStyle = ButtonStyle(
        backgroundColor:
        MaterialStateProperty.all(Theme
            .of(context)
            .colorScheme
            .primary),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            side: BorderSide(
                color: Theme
                    .of(context)
                    .colorScheme
                    .secondary, width: 1),
            borderRadius: BorderRadius.circular(10))));
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: Theme
                    .of(context)
                    .colorScheme
                    .primary,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(post.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: post.imageUrl != null
                          ? Image.network(post.imageUrl!, errorBuilder:
                          (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Image.asset("assets/mock.png");
                      })
                          : Image.asset("assets/mock.png"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    post.content != null
                        ? Text(post.content!)
                        : const Text(
                        "API для этой новости не вернул никакого содержания. Ознакомтесь с полной новостью по нажав на кнопку снизу."),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: buttonStyle,
                            onPressed: _launchURL,
                            child: Text("Читать полностью",
                                style: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .secondary,
                                ))),
                        const SizedBox(
                          width: 10,
                        ),
                        ref.read(likedListProvider.notifier).has(post.title)
                            ? ElevatedButton(
                            style: buttonStyle,
                            onPressed: () {
                              ref.read(likedListProvider.notifier).remove(post);
                            },
                            child: Text("Убрать из понравившегося",
                              style: TextStyle(color: Theme
                                  .of(context)
                                  .colorScheme
                                  .secondary),))
                            : ElevatedButton(
                            style: buttonStyle,
                            onPressed: () =>
                                ref.read(likedListProvider.notifier).add(post),
                            child: Text("Мне нравится",
                              style: TextStyle(color: Theme
                                  .of(context)
                                  .colorScheme
                                  .secondary),))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  _launchURL() async {
    final url = post.url;
    await launchUrl(Uri.parse(url));
  }
}
