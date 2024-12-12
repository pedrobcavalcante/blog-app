import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog/modules/home/domain/usecases/get_posts_usecase.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPostsUseCase _getPostsUseCase;

  PostBloc({required GetPostsUseCase getPostsUseCase})
      : _getPostsUseCase = getPostsUseCase,
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
}
