import 'package:blog/modules/home/domain/repository/firebase_repository.dart';
import 'package:blog/core/domain/usecases/usecase.dart';
import 'package:blog/shared/domain/usecases/get_secure_storage_usecase.dart';
import 'package:equatable/equatable.dart';

class ToggleFavoritePostParams extends Equatable {
  final int postId;
  final bool isFavorited;

  const ToggleFavoritePostParams({
    required this.postId,
    required this.isFavorited,
  });

  @override
  List<Object?> get props => [postId, isFavorited];
}

class ToggleFavoritePostUseCase
    implements UseCase<ToggleFavoritePostParams, void> {
  final FirestoreRepository _repository;
  final GetTokenUseCase _getTokenUseCase;

  const ToggleFavoritePostUseCase({
    required FirestoreRepository repository,
    required GetTokenUseCase getTokenUseCase,
  })  : _repository = repository,
        _getTokenUseCase = getTokenUseCase;

  @override
  Future<void> call(ToggleFavoritePostParams params) async {
    final userId = await _getTokenUseCase.call();
    if (userId == null) {
      throw Exception('Não foi possível recuperar o userId.');
    }
    await _repository.toggleFavoritePost(params.postId, params.isFavorited,
        userId: userId);
  }
}
