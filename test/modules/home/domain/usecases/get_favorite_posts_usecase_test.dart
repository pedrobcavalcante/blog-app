import 'package:blog/modules/home/domain/entities/favorite_post.dart';
import 'package:blog/modules/home/domain/repository/firebase_repository.dart';

import 'package:blog/shared/domain/usecases/get_secure_storage_usecase.dart';
import 'package:blog/modules/home/domain/usecases/get_favorite_posts_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirestoreRepository extends Mock implements FirestoreRepository {}

class MockGetTokenUseCase extends Mock implements GetTokenUseCase {}

void main() {
  late GetFavoritePostsUseCase useCase;
  late MockFirestoreRepository mockRepository;
  late MockGetTokenUseCase mockGetTokenUseCase;

  setUp(() {
    mockRepository = MockFirestoreRepository();
    mockGetTokenUseCase = MockGetTokenUseCase();
    useCase = GetFavoritePostsUseCase(
      repository: mockRepository,
      getTokenUseCase: mockGetTokenUseCase,
    );

    registerFallbackValue(<FavoritePost>[]);
  });

  group('GetFavoritePostsUseCase Tests', () {
    test('should return a list of FavoritePost when call is successful',
        () async {
      when(() => mockGetTokenUseCase.call()).thenAnswer((_) async => 'user123');

      when(() => mockRepository.getFavoritePosts(userId: 'user123'))
          .thenAnswer((_) async => [
                FavoritePost(postId: "1", isFavorited: true),
                FavoritePost(postId: "2", isFavorited: false),
              ]);

      final result = await useCase.call();

      expect(result, isA<List<FavoritePost>>());
      expect(result.length, 2);
      expect(result[0].postId, "1");
      expect(result[0].isFavorited, true);
      expect(result[1].postId, "2");
      expect(result[1].isFavorited, false);

      verify(() => mockGetTokenUseCase.call()).called(1);
      verify(() => mockRepository.getFavoritePosts(userId: 'user123'))
          .called(1);
    });

    test('should throw an exception when userId is null', () async {
      when(() => mockGetTokenUseCase.call()).thenAnswer((_) async => null);

      expect(() => useCase.call(), throwsA(isA<Exception>()));

      verify(() => mockGetTokenUseCase.call()).called(1);
      verifyNever(
          () => mockRepository.getFavoritePosts(userId: any(named: 'userId')));
    });

    test('should throw an exception when repository call fails', () async {
      when(() => mockGetTokenUseCase()).thenAnswer((_) async => 'user123');

      when(() => mockRepository.getFavoritePosts(userId: 'user123'))
          .thenThrow(Exception('Failed to fetch favorites'));

      expect(() => useCase(), throwsA(isA<Exception>()));
    });
  });
}
