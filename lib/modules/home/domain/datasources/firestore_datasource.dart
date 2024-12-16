abstract class FavoriteDatasource {
  Future<List<Map<String, dynamic>>> getFavoritePosts({required String userId});
  Future<void> toggleFavoritePost(
      {required String userId,
      required String postId,
      required bool isFavorited});
  Future<bool> isPostFavorited(
      {required String userId, required String postId});
}
