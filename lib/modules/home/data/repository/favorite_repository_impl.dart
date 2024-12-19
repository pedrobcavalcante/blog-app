import 'package:blog/modules/home/domain/datasources/firestore_datasource.dart';
import 'package:blog/modules/home/domain/entities/favorite_post.dart';
import 'package:blog/modules/home/domain/repository/firebase_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteDatasource _datasource;

  FavoriteRepositoryImpl({required FavoriteDatasource datasource})
      : _datasource = datasource;

  @override
  Future<List<FavoritePost>> getFavoritePosts({required String userId}) async {
    try {
      final result = await _datasource.getFavoritePosts(userId: userId);
      return result
          .map((e) =>
              FavoritePost(postId: e['id'], isFavorited: e['isFavorited']))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar favoritos: $e');
    }
  }

  @override
  Future<void> toggleFavoritePost(int postId, bool isFavorited,
      {required String userId}) async {
    try {
      await _datasource.toggleFavoritePost(
          postId: postId.toString(), isFavorited: isFavorited, userId: userId);
    } catch (e) {
      throw Exception('Erro ao favoritar/desfavoritar o post: $e');
    }
  }

  @override
  Future<bool> isPostFavorited(String postId, {required String userId}) async {
    try {
      return await _datasource.isPostFavorited(postId: postId, userId: userId);
    } catch (e) {
      throw Exception('Erro ao verificar se o post é favoritado: $e');
    }
  }
}
