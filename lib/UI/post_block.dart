import 'package:flutter/material.dart';
import 'package:flutter_dz1/UI/single_post_page.dart';
import 'package:flutter_dz1/data/models/news_model.dart';

class PostBlock extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final Post post;

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
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: SizedBox(
                width: 150,
                height: 100,
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
