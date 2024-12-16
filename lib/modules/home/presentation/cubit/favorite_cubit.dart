import 'package:blog/modules/home/domain/entities/favorite_state.dart';
import 'package:blog/modules/home/domain/entities/post.dart';
import 'package:blog/modules/home/domain/usecases/toggle_favorite_post_usecase.dart';
import 'package:blog/modules/home/presentation/cubit/favorite_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCubit extends Cubit<FavoriteCubitState> {
  final ToggleFavoritePostUseCase toggleFavoriteUseCase;

  FavoriteCubit(this.toggleFavoriteUseCase) : super(FavoriteInitial());

  Future<void> addFavorites(List<Post> posts) async {
    try {
      emit(FavoriteLoading());
      final favoritePosts = posts
          .map((post) => FavoriteState(
                id: post.id,
                title: post.title,
                body: post.body,
                isFavorited: post.isFavorited,
              ))
          .toList();
      emit(FavoriteLoaded(favoritePosts));
    } catch (e) {
      emit(const FavoriteError('Failed to load favorites'));
    }
  }

  Future<void> toggleFavorite(int postId, bool isFavorited) async {
    final currentState = state;
    if (currentState is! FavoriteLoaded) return;

    try {
      final favoritesMap = {
        for (var favorite in currentState.favorites) favorite.id: favorite
      };

      if (!favoritesMap.containsKey(postId)) return;

      favoritesMap[postId] = favoritesMap[postId]!.copyWith(isLoading: true);
      emit(FavoriteLoaded(favoritesMap.values.toList()));

      await toggleFavoriteUseCase(
        ToggleFavoritePostParams(postId: postId, isFavorited: isFavorited),
      );

      favoritesMap[postId] = favoritesMap[postId]!.copyWith(
        isLoading: false,
        isFavorited: isFavorited,
      );

      emit(FavoriteLoaded(favoritesMap.values.toList()));
    } catch (e) {
      emit(const FavoriteError('Failed to toggle favorite'));
    }
  }
}
