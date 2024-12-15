import 'package:blog/modules/home/domain/entities/favorite_post.dart';

abstract class FirestoreRepository {
  Future<List<FavoritePost>> getFavoritePosts({required String userId});
  Future<void> toggleFavoritePost(int postId, bool isFavorited, {required String userId});
  Future<bool> isPostFavorited(String postId, {required String userId});
}

