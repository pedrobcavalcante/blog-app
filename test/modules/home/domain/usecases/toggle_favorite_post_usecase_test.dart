import 'package:blog/modules/home/domain/repository/firebase_repository.dart';
import 'package:blog/modules/home/domain/usecases/toggle_favorite_post_usecase.dart';
import 'package:blog/shared/domain/usecases/get_secure_storage_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirestoreRepository extends Mock implements FirestoreRepository {}

class MockGetTokenUseCase extends Mock implements GetTokenUseCase {}

void main() {
  late ToggleFavoritePostUseCase useCase;
  late MockFirestoreRepository mockRepository;
  late MockGetTokenUseCase mockGetTokenUseCase;

  setUp(() {
    mockRepository = MockFirestoreRepository();
    mockGetTokenUseCase = MockGetTokenUseCase();
    useCase = ToggleFavoritePostUseCase(
      repository: mockRepository,
      getTokenUseCase: mockGetTokenUseCase,
    );
  });

  group('ToggleFavoritePostUseCase Tests', () {
    test('should call the repository with correct parameters when successful',
        () async {
      const params = ToggleFavoritePostParams(postId: 1, isFavorited: true);

      when(() => mockGetTokenUseCase.call()).thenAnswer((_) async => 'user123');
      when(() => mockRepository.toggleFavoritePost(
            params.postId,
            params.isFavorited,
            userId: 'user123',
          )).thenAnswer((_) async {});

      await useCase.call(params);

      verify(() => mockGetTokenUseCase.call()).called(1);
      verify(() => mockRepository.toggleFavoritePost(
            params.postId,
            params.isFavorited,
            userId: 'user123',
          )).called(1);
    });

    test('should throw an exception when userId is null', () async {
      const params = ToggleFavoritePostParams(postId: 1, isFavorited: true);

      when(() => mockGetTokenUseCase.call()).thenAnswer((_) async => null);

      expect(() => useCase.call(params), throwsA(isA<Exception>()));

      verify(() => mockGetTokenUseCase.call()).called(1);
      verifyNever(() => mockRepository.toggleFavoritePost(
            any(),
            any(),
            userId: any(named: 'userId'),
          ));
    });

    test('should throw an exception when repository call fails', () async {
      const params = ToggleFavoritePostParams(postId: 1, isFavorited: false);

      when(() => mockGetTokenUseCase.call()).thenAnswer((_) async => 'user123');
      when(() => mockRepository.toggleFavoritePost(
            params.postId,
            params.isFavorited,
            userId: 'user123',
          )).thenThrow(Exception('Failed to toggle favorite'));

      expect(() => useCase.call(params), throwsA(isA<Exception>()));

      verify(() => mockGetTokenUseCase.call()).called(1);
    });
  });
}
