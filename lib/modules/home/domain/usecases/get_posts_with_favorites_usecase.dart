import 'package:blog/modules/home/domain/entities/post.dart';
import 'package:blog/modules/home/domain/usecases/get_favorite_posts_usecase.dart';
import 'package:blog/modules/home/domain/usecases/get_posts_usecase.dart';
import 'package:blog/core/domain/usecases/usecase.dart';

class GetPostsWithFavoritesUseCase implements UseCase<void, List<Post>> {
  final GetPostsUseCase _getPostsUseCase;
  final GetFavoritePostsUseCase _getFavoritePostsUseCase;

  const GetPostsWithFavoritesUseCase({
    required GetPostsUseCase getPostsUseCase,
    required GetFavoritePostsUseCase getFavoritePostsUseCase
  })  : _getPostsUseCase = getPostsUseCase,
        _getFavoritePostsUseCase = getFavoritePostsUseCase;

  @override
  Future<List<Post>> call([void params]) async {
    final posts = await _getPostsUseCase.call();
    final favoritePosts = await _getFavoritePostsUseCase.call();

    return posts.map((post) {
      final isFavorited =
          favoritePosts.any((favoritePost) => favoritePost.postId == post.id.toString());
      return Post(
        id: post.id,
        title: post.title,
        body: post.body,
        isFavorited: isFavorited,
      );
    }).toList();
  }
}

