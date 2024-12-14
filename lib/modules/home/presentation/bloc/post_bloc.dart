import 'package:blog/modules/home/domain/entities/comments.dart';
import 'package:blog/modules/home/domain/usecases/get_comments_usecas.dart';
import 'package:blog/modules/home/domain/usecases/get_posts_with_favorites_usecase.dart';
import 'package:blog/modules/home/domain/usecases/toggle_favorite_post_usecase.dart';
import 'package:blog/modules/home/presentation/bloc/post_event.dart';
import 'package:blog/modules/home/presentation/bloc/post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetCommentsUseCase _getCommentsUseCase;
  final ToggleFavoritePostUseCase _toggleFavoritePostUseCase;
  final GetPostsWithFavoritesUseCase _getPostsWithFavoritesUseCase;

  PostBloc({
    required GetCommentsUseCase getCommentsUseCase,
    required ToggleFavoritePostUseCase toggleFavoritePostUseCase,
    required GetPostsWithFavoritesUseCase getPostsWithFavoritesUseCase,
  })  : _getCommentsUseCase = getCommentsUseCase,
        _toggleFavoritePostUseCase = toggleFavoritePostUseCase,
        _getPostsWithFavoritesUseCase = getPostsWithFavoritesUseCase,
        super(PostInitial()) {
    on<LoadPostsEvent>(_onLoadPosts);
    on<ToggleFavoritePostEvent>(_onToggleFavoritePost);
  }
  Future<void> _onLoadPosts(
    LoadPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading());
    try {
      final postsWithFavorite = await _getPostsWithFavoritesUseCase.call();
      emit(PostLoaded(postsWithFavorite));
    } catch (e) {
      emit(PostError('Erro ao carregar os posts.'));
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
    Emitter<PostState> emit,
  ) async {
    try {
      await _toggleFavoritePostUseCase.call(ToggleFavoritePostParams(
          postId: event.postId, isFavorited: event.isFavorited));

      add(LoadPostsEvent());
    } catch (e) {
      emit(PostError('Erro ao atualizar o favorito.'));
    }
  }
}
