class Post {
  final int id;
  final String title;
  final String body;
  final bool isFavorited;

  Post({
    required this.id,
    required this.title,
    required this.body,
    this.isFavorited = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      isFavorited: json['isFavorited'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'isFavorited': isFavorited,
    };
  }
}
