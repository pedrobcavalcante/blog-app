import 'package:blog/modules/home/domain/entities/post.dart';
import 'package:blog/modules/home/domain/usecases/toggle_favorite_post_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ButtonState { initial, loading, error }

class FavoriteState extends Post {
  final ButtonState buttonState;

  FavoriteState({
    required this.buttonState,
    required super.id,
    required super.title,
    required super.body,
    super.isFavorited,
  });

  FavoriteState copyWith({
    ButtonState? buttonState,
    int? id,
    String? title,
    String? body,
    bool? isFavorited,
  }) {
    return FavoriteState(
      buttonState: buttonState ?? this.buttonState,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }
}

class FavoriteCubit extends Cubit<Map<String, ButtonState>> {
  final ToggleFavoritePostUseCase toggleFavoriteUseCase;
  FavoriteCubit(this.toggleFavoriteUseCase) : super({});
  List<FavoriteState> favorites = [];
  Future<void> addFavorites(List<Post> posts) async {
    for (var post in posts) {
      final favoriteState = FavoriteState(
        buttonState: ButtonState.initial,
        body: post.body,
        id: post.id,
        title: post.title,
        isFavorited: post.isFavorited,
      );

      favorites.add(favoriteState);
    }
    _emitState();
  }

  Future<void> toggleFavorite(int postId, bool isFavorited) async {
    try {
      final index = favorites.indexWhere((post) => post.id == postId);
      if (index == -1) return;

      favorites[index] = favorites[index].copyWith(
        buttonState: ButtonState.loading,
      );
      _emitState();

      await toggleFavoriteUseCase(
        ToggleFavoritePostParams(postId: postId, isFavorited: isFavorited),
      );

      favorites[index] = favorites[index].copyWith(
        buttonState: ButtonState.initial,
        isFavorited: isFavorited,
      );
      _emitState();
    } catch (e) {
      final index = favorites.indexWhere((post) => post.id == postId);
      if (index != -1) {
        favorites[index] = favorites[index].copyWith(
          buttonState: ButtonState.error,
        );
        _emitState();
      }
    }
  }

  void _emitState() {
    emit({
      for (var post in favorites) post.id.toString(): post.buttonState,
    });
  }
}
