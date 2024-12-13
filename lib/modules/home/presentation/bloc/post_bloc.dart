import 'package:blog/modules/home/domain/entities/comments.dart';
import 'package:blog/modules/home/domain/usecases/get_comments_usecas.dart';
import 'package:blog/modules/home/presentation/bloc/post_event.dart';
import 'package:blog/modules/home/presentation/bloc/post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog/modules/home/domain/usecases/get_posts_usecase.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPostsUseCase _getPostsUseCase;
  final GetCommentsUseCase _getCommentsUseCase;

  PostBloc(
      {required GetPostsUseCase getPostsUseCase,
      required GetCommentsUseCase getCommentsUseCase})
      : _getPostsUseCase = getPostsUseCase,
        _getCommentsUseCase = getCommentsUseCase,
        super(PostInitial()) {
    on<LoadPostsEvent>(_onLoadPosts);
  }

  Future<void> _onLoadPosts(
    LoadPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading());
    try {
      final posts = await _getPostsUseCase.call();
      emit(PostLoaded(posts));
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
}
