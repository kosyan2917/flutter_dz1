class Post {
  final String? imageUrl;
  final String title;
  final String? content;
  final bool liked;
  final String url;

  Post({
    required this.imageUrl,
    required this.title,
    required this.content,
    required this.url,
    this.liked = false,
  });
}