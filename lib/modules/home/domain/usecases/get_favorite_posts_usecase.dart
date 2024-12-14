import 'package:blog/modules/home/domain/entities/favorite_post.dart';
import 'package:blog/modules/home/domain/repository/firebase_repository.dart';
import 'package:blog/core/domain/usecases/usecase.dart';
import 'package:blog/shared/domain/usecases/get_secure_storage_usecase.dart';

class GetFavoritePostsUseCase implements UseCase<void, List<FavoritePost>> {
  final FirebaseRepository _repository;
  final GetTokenUseCase _getTokenUseCase;

  const GetFavoritePostsUseCase({
    required FirebaseRepository repository,
    required GetTokenUseCase getTokenUseCase,
  })  : _repository = repository,
        _getTokenUseCase = getTokenUseCase;

  @override
  Future<List<FavoritePost>> call([void input]) async {
    final userId = await _getTokenUseCase.call();
    if (userId == null) {
      throw Exception('Não foi possível recuperar o userId.');
    }

    return await _repository.getFavoritePosts(userId: userId);
  }
}
