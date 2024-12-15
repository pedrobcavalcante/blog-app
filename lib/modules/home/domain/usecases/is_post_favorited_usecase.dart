import 'package:blog/modules/home/domain/repository/firebase_repository.dart';
import 'package:blog/core/domain/usecases/usecase.dart';
import 'package:blog/shared/domain/usecases/get_secure_storage_usecase.dart';

class IsPostFavoritedUseCase implements UseCase<String, bool> {
  final FirestoreRepository _repository;
  final GetTokenUseCase _getTokenUseCase;

  const IsPostFavoritedUseCase(
      {required FirestoreRepository repository,
      required GetTokenUseCase getTokenUseCase})
      : _repository = repository,
        _getTokenUseCase = getTokenUseCase;

  @override
  Future<bool> call(String postId) async {
    final userId = await _getTokenUseCase.call();
    if (userId == null) {
      throw Exception('Não foi poss vel recuperar o userId.');
    }

    return await _repository.isPostFavorited(postId, userId: userId);
  }
}
