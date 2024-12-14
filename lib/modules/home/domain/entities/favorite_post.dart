class FavoritePost {
  final String postId;
  final bool isFavorited;

  FavoritePost({
    required this.postId,
    required this.isFavorited,
  });

  factory FavoritePost.fromMap(Map<String, dynamic> doc) {
    return FavoritePost(
      postId: doc['postId'],
      isFavorited: doc['isFavorited'] ?? false,
    );
  }
}
