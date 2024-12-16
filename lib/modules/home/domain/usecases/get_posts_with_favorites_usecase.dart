import 'package:blog/modules/home/domain/entities/favorite_post.dart';
import 'package:blog/shared/domain/entities/post.dart';
import 'package:blog/modules/home/domain/usecases/get_favorite_posts_usecase.dart';
import 'package:blog/modules/home/domain/usecases/get_posts_usecase.dart';
import 'package:blog/core/domain/usecases/usecase.dart';

class GetPostsWithFavoritesUseCase implements UseCase<void, List<Post>> {
  final GetPostsUseCase _getPostsUseCase;
  final GetFavoritePostsUseCase _getFavoritePostsUseCase;

  const GetPostsWithFavoritesUseCase(
      {required GetPostsUseCase getPostsUseCase,
      required GetFavoritePostsUseCase getFavoritePostsUseCase})
      : _getPostsUseCase = getPostsUseCase,
        _getFavoritePostsUseCase = getFavoritePostsUseCase;

  @override
  Future<List<Post>> call([void params]) async {
    final results = await Future.wait([
      _getPostsUseCase.call(),
      _getFavoritePostsUseCase.call(),
    ]);

    final posts = results[0] as List<Post>;
    final favoritePosts = results[1] as List<FavoritePost>;

    return posts.map((post) {
      final isFavorited = favoritePosts.any((favoritePost) =>
          favoritePost.postId == post.id.toString() &&
          favoritePost.isFavorited);
      return Post(
        id: post.id,
        title: post.title,
        body: post.body,
        isFavorited: isFavorited,
      );
    }).toList();
  }
}
