import 'package:blog/modules/home/domain/usecases/get_posts_with_favorites_usecase.dart';
import 'package:blog/modules/home/presentation/bloc/home_event.dart';
import 'package:blog/modules/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPostsWithFavoritesUseCase _getPostsWithFavoritesUseCase;

  HomeBloc({
    required GetPostsWithFavoritesUseCase getPostsWithFavoritesUseCase,
  })  : _getPostsWithFavoritesUseCase = getPostsWithFavoritesUseCase,
        super(HomeInitial()) {
    on<LoadPostsEvent>(_onLoadPosts);
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
}
