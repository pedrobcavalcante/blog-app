import 'package:blog/modules/home/domain/entities/favorite_post.dart';
import 'package:blog/modules/home/domain/entities/post.dart';
import 'package:blog/modules/home/domain/usecases/get_favorite_posts_usecase.dart';
import 'package:blog/modules/home/domain/usecases/get_posts_usecase.dart';
import 'package:blog/modules/home/domain/usecases/get_posts_with_favorites_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPostsUseCase extends Mock implements GetPostsUseCase {}

class MockGetFavoritePostsUseCase extends Mock
    implements GetFavoritePostsUseCase {}

void main() {
  late GetPostsWithFavoritesUseCase useCase;
  late MockGetPostsUseCase mockGetPostsUseCase;
  late MockGetFavoritePostsUseCase mockGetFavoritePostsUseCase;

  setUp(() {
    mockGetPostsUseCase = MockGetPostsUseCase();
    mockGetFavoritePostsUseCase = MockGetFavoritePostsUseCase();
    useCase = GetPostsWithFavoritesUseCase(
      getPostsUseCase: mockGetPostsUseCase,
      getFavoritePostsUseCase: mockGetFavoritePostsUseCase,
    );
  });

  group('GetPostsWithFavoritesUseCase Tests', () {
    test('should return posts with favorite status when both calls succeed',
        () async {
      final posts = [
        Post(id: 1, title: 'Post 1', body: 'Body 1'),
        Post(id: 2, title: 'Post 2', body: 'Body 2'),
        Post(id: 3, title: 'Post 3', body: 'Body 3'),
      ];

      final favoritePosts = [
        FavoritePost(postId: '1', isFavorited: true),
        FavoritePost(postId: '3', isFavorited: true),
      ];

      when(() => mockGetPostsUseCase.call()).thenAnswer((_) async => posts);
      when(() => mockGetFavoritePostsUseCase.call())
          .thenAnswer((_) async => favoritePosts);

      final result = await useCase.call();

      verify(() => mockGetPostsUseCase.call()).called(1);
      verify(() => mockGetFavoritePostsUseCase.call()).called(1);

      expect(result, isA<List<Post>>());
      expect(result.length, 3);
      expect(result[0].isFavorited, true);
      expect(result[1].isFavorited, false);
      expect(result[2].isFavorited, true);
    });

    test('should throw an exception if GetPostsUseCase fails', () async {
      when(() => mockGetPostsUseCase.call())
          .thenThrow(Exception('Failed to fetch posts'));
      when(() => mockGetFavoritePostsUseCase.call())
          .thenAnswer((_) async => []);

      expect(() => useCase.call(), throwsA(isA<Exception>()));

      verify(() => mockGetPostsUseCase.call()).called(1);
      verifyNever(() => mockGetFavoritePostsUseCase.call());
    });

    test('should throw an exception if GetFavoritePostsUseCase fails',
        () async {
      final posts = [
        Post(id: 1, title: 'Post 1', body: 'Body 1'),
        Post(id: 2, title: 'Post 2', body: 'Body 2'),
      ];

      when(() => mockGetPostsUseCase.call()).thenAnswer((_) async => posts);
      when(() => mockGetFavoritePostsUseCase.call())
          .thenThrow(Exception('Failed to fetch favorites'));

      expect(() => useCase.call(), throwsA(isA<Exception>()));

      verify(() => mockGetPostsUseCase.call()).called(1);
      verify(() => mockGetFavoritePostsUseCase.call()).called(1);
    });
  });
}
