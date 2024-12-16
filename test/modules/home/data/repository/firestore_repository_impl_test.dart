import 'package:blog/modules/home/data/repository/firestore_repository_impl.dart';
import 'package:blog/modules/home/domain/datasources/firestore_datasource.dart';
import 'package:blog/modules/home/domain/entities/favorite_post.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoriteDatasource extends Mock implements FavoriteDatasource {}

void main() {
  late FavoriteRepositoryImpl repository;
  late MockFavoriteDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockFavoriteDatasource();
    repository = FavoriteRepositoryImpl(datasource: mockDatasource);

    registerFallbackValue(<Map<String, dynamic>>[]);
  });

  group('getFavoritePosts', () {
    test('should return a list of FavoritePost when call is successful',
        () async {
      when(() => mockDatasource.getFavoritePosts(userId: 'user1')).thenAnswer(
        (_) async => [
          {'id': "1", 'isFavorited': true},
          {'id': "2", 'isFavorited': false},
        ],
      );

      final result = await repository.getFavoritePosts(userId: 'user1');

      verify(() => mockDatasource.getFavoritePosts(userId: 'user1')).called(1);
      expect(result, isA<List<FavoritePost>>());
      expect(result.length, 2);
      expect(result[0].postId, "1");
      expect(result[0].isFavorited, true);
      expect(result[1].postId, "2");
      expect(result[1].isFavorited, false);
    });

    test('should throw an exception when the call fails', () async {
      when(() => mockDatasource.getFavoritePosts(userId: 'user1'))
          .thenThrow(Exception('Erro no datasource'));

      expect(() => repository.getFavoritePosts(userId: 'user1'),
          throwsA(isA<Exception>()));
      verify(() => mockDatasource.getFavoritePosts(userId: 'user1')).called(1);
    });
  });

  group('toggleFavoritePost', () {
    test('should call toggleFavoritePost on the datasource', () async {
      when(() => mockDatasource.toggleFavoritePost(
          postId: '1',
          isFavorited: true,
          userId: 'user1')).thenAnswer((_) async {});

      await repository.toggleFavoritePost(1, true, userId: 'user1');

      verify(() => mockDatasource.toggleFavoritePost(
            postId: '1',
            isFavorited: true,
            userId: 'user1',
          )).called(1);
    });

    test('should throw an exception when toggleFavoritePost fails', () async {
      when(() => mockDatasource.toggleFavoritePost(
          postId: '1',
          isFavorited: true,
          userId: 'user1')).thenThrow(Exception('Erro no datasource'));

      expect(() => repository.toggleFavoritePost(1, true, userId: 'user1'),
          throwsA(isA<Exception>()));

      verify(() => mockDatasource.toggleFavoritePost(
            postId: '1',
            isFavorited: true,
            userId: 'user1',
          )).called(1);
    });
  });

  group('isPostFavorited', () {
    test('should return true when post is favorited', () async {
      when(() => mockDatasource.isPostFavorited(postId: '1', userId: 'user1'))
          .thenAnswer((_) async => true);

      final result = await repository.isPostFavorited('1', userId: 'user1');

      expect(result, true);
      verify(() => mockDatasource.isPostFavorited(
            postId: '1',
            userId: 'user1',
          )).called(1);
    });

    test('should return false when post is not favorited', () async {
      when(() => mockDatasource.isPostFavorited(postId: '1', userId: 'user1'))
          .thenAnswer((_) async => false);

      final result = await repository.isPostFavorited('1', userId: 'user1');

      expect(result, false);
      verify(() => mockDatasource.isPostFavorited(
            postId: '1',
            userId: 'user1',
          )).called(1);
    });

    test('should throw an exception when isPostFavorited fails', () async {
      when(() => mockDatasource.isPostFavorited(postId: '1', userId: 'user1'))
          .thenThrow(Exception('Erro no datasource'));

      expect(() => repository.isPostFavorited('1', userId: 'user1'),
          throwsA(isA<Exception>()));

      verify(() => mockDatasource.isPostFavorited(
            postId: '1',
            userId: 'user1',
          )).called(1);
    });
  });
}
