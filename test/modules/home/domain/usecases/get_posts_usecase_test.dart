import 'package:blog/modules/home/domain/datasources/remote_datasource.dart';
import 'package:blog/shared/domain/entities/post.dart';
import 'package:blog/modules/home/domain/usecases/get_posts_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

void main() {
  late GetPostsUseCase useCase;
  late MockPostRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockPostRemoteDataSource();
    useCase = GetPostsUseCase(datasource: mockDataSource);
  });

  group('GetPostsUseCase Tests', () {
    test(
        'should return a list of Post when the call to the datasource is successful',
        () async {
      final testPosts = [
        const Post(id: 1, title: 'Post 1', body: 'Body 1'),
        const Post(id: 2, title: 'Post 2', body: 'Body 2'),
      ];

      when(() => mockDataSource.getPosts()).thenAnswer((_) async => testPosts);

      final result = await useCase.call();

      verify(() => mockDataSource.getPosts()).called(1);
      expect(result, isA<List<Post>>());
      expect(result.length, 2);
      expect(result[0].id, 1);
      expect(result[0].title, 'Post 1');
      expect(result[1].title, 'Post 2');
    });

    test('should throw an exception when the call to datasource fails',
        () async {
      when(() => mockDataSource.getPosts())
          .thenThrow(Exception('Failed to fetch posts'));

      expect(() => useCase.call(), throwsA(isA<Exception>()));

      verify(() => mockDataSource.getPosts()).called(1);
    });
  });
}
