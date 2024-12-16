import 'package:blog/modules/home/domain/repository/firebase_repository.dart';
import 'package:blog/modules/home/domain/usecases/is_post_favorited_usecase.dart';
import 'package:blog/shared/domain/usecases/get_secure_storage_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

class MockGetTokenUseCase extends Mock implements GetTokenUseCase {}

void main() {
  late IsPostFavoritedUseCase useCase;
  late MockFavoriteRepository mockRepository;
  late MockGetTokenUseCase mockGetTokenUseCase;

  setUp(() {
    mockRepository = MockFavoriteRepository();
    mockGetTokenUseCase = MockGetTokenUseCase();
    useCase = IsPostFavoritedUseCase(
      repository: mockRepository,
      getTokenUseCase: mockGetTokenUseCase,
    );
  });

  group('IsPostFavoritedUseCase Tests', () {
    test('should return true when the post is favorited', () async {
      when(() => mockGetTokenUseCase.call()).thenAnswer((_) async => 'user123');
      when(() => mockRepository.isPostFavorited('post1', userId: 'user123'))
          .thenAnswer((_) async => true);

      final result = await useCase.call('post1');

      expect(result, true);
      verify(() => mockGetTokenUseCase.call()).called(1);
      verify(() => mockRepository.isPostFavorited('post1', userId: 'user123'))
          .called(1);
    });

    test('should return false when the post is not favorited', () async {
      when(() => mockGetTokenUseCase.call()).thenAnswer((_) async => 'user123');
      when(() => mockRepository.isPostFavorited('post1', userId: 'user123'))
          .thenAnswer((_) async => false);

      final result = await useCase.call('post1');

      expect(result, false);
      verify(() => mockGetTokenUseCase.call()).called(1);
      verify(() => mockRepository.isPostFavorited('post1', userId: 'user123'))
          .called(1);
    });

    test('should throw an exception when userId is null', () async {
      when(() => mockGetTokenUseCase.call()).thenAnswer((_) async => null);

      expect(() => useCase.call('post1'), throwsA(isA<Exception>()));

      verify(() => mockGetTokenUseCase.call()).called(1);
      verifyNever(() =>
          mockRepository.isPostFavorited(any(), userId: any(named: 'userId')));
    });

    test('should throw an exception when repository call fails', () async {
      when(() => mockGetTokenUseCase.call()).thenAnswer((_) async => 'user123');
      when(() => mockRepository.isPostFavorited('post1', userId: 'user123'))
          .thenThrow(Exception('Repository error'));

      expect(() => useCase.call('post1'), throwsA(isA<Exception>()));

      verify(() => mockGetTokenUseCase.call()).called(1);
    });
  });
}
