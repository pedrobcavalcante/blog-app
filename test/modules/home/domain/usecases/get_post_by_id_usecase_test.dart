import 'package:blog/modules/home/domain/datasources/remote_datasource.dart';
import 'package:blog/modules/home/domain/entities/post.dart';
import 'package:blog/modules/home/domain/usecases/get_post_by_id_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

void main() {
  late GetPostByIdUseCase useCase;
  late MockPostRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockPostRemoteDataSource();
    useCase = GetPostByIdUseCase(postRemoteDataSource: mockDataSource);
  });

  group('GetPostByIdUseCase Tests', () {
    test('should return a Post when the call to the datasource is successful',
        () async {
      const testPostId = 1;
      final testPost = Post(
        id: 1,
        title: 'Test Post',
        body: 'This is a test post',
      );

      when(() => mockDataSource.getPostById(testPostId))
          .thenAnswer((_) async => testPost);

      final result = await useCase.call(testPostId);

      verify(() => mockDataSource.getPostById(testPostId)).called(1);
      expect(result, isA<Post>());
      expect(result.id, testPost.id);
      expect(result.title, testPost.title);
      expect(result.body, testPost.body);
    });

    test('should throw an exception when the call to datasource fails',
        () async {
      const testPostId = 1;
      when(() => mockDataSource.getPostById(testPostId))
          .thenThrow(Exception('Failed to fetch post'));

      expect(() => useCase.call(testPostId), throwsA(isA<Exception>()));

      verify(() => mockDataSource.getPostById(testPostId)).called(1);
    });
  });
}
