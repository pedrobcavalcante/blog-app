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
      emit(FavoriteError('Failed to load favorites'));
    }
  }

  Future<void> toggleFavorite(int postId, bool isFavorited) async {
    final currentState = state;
    if (currentState is! FavoriteLoaded) return;

    try {
      final index =
          currentState.favorites.indexWhere((post) => post.id == postId);
      if (index == -1) return;

      final updatedFavorites = List<FavoriteState>.from(currentState.favorites);
      updatedFavorites[index] =
          updatedFavorites[index].copyWith(isLoading: true);

      emit(FavoriteLoaded(updatedFavorites));

      await toggleFavoriteUseCase(
        ToggleFavoritePostParams(postId: postId, isFavorited: isFavorited),
      );

      updatedFavorites[index] = updatedFavorites[index].copyWith(
        isLoading: false,
        isFavorited: isFavorited,
      );

      emit(FavoriteLoaded(updatedFavorites));
    } catch (e) {
      emit(FavoriteError('Failed to toggle favorite'));
    }
  }
}
