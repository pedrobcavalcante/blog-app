import 'package:blog/modules/home/domain/entities/comments.dart';
import 'package:blog/modules/home/domain/usecases/get_comments_usecas.dart';
import 'package:blog/modules/home/domain/usecases/get_posts_with_favorites_usecase.dart';
import 'package:blog/modules/home/domain/usecases/toggle_favorite_post_usecase.dart';
import 'package:blog/modules/home/presentation/bloc/home_event.dart';
import 'package:blog/modules/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCommentsUseCase _getCommentsUseCase;
  final ToggleFavoritePostUseCase _toggleFavoritePostUseCase;
  final GetPostsWithFavoritesUseCase _getPostsWithFavoritesUseCase;

  HomeBloc({
    required GetCommentsUseCase getCommentsUseCase,
    required ToggleFavoritePostUseCase toggleFavoritePostUseCase,
    required GetPostsWithFavoritesUseCase getPostsWithFavoritesUseCase,
  })  : _getCommentsUseCase = getCommentsUseCase,
        _toggleFavoritePostUseCase = toggleFavoritePostUseCase,
        _getPostsWithFavoritesUseCase = getPostsWithFavoritesUseCase,
        super(HomeInitial()) {
    on<LoadPostsEvent>(_onLoadPosts);
    on<ToggleFavoritePostEvent>(_onToggleFavoritePost);
  }
  Future<void> _onLoadPosts(
    LoadPostsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final postsWithFavorite = await _getPostsWithFavoritesUseCase.call();
      emit(HomeLoaded(postsWithFavorite));
    } catch (e) {
      emit(HomeError('Erro ao carregar os posts.'));
    }
  }

  Future<List<Comment>> getComments(int postId) async {
    try {
      return await _getCommentsUseCase.call(postId);
    } catch (e) {
      throw Exception('Erro ao carregar os comentários');
    }
  }

  Future<void> _onToggleFavoritePost(
    ToggleFavoritePostEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await _toggleFavoritePostUseCase.call(ToggleFavoritePostParams(
          postId: event.postId, isFavorited: event.isFavorited));

      add(LoadPostsEvent());
    } catch (e) {
      emit(HomeError('Erro ao atualizar o favorito.'));
    }
  }
}
