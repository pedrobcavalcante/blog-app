import 'package:blog/modules/home/domain/datasources/remote_datasource.dart';
import 'package:blog/modules/home/domain/entities/comments.dart';

import 'package:blog/modules/home/domain/usecases/get_comments_usecas.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

void main() {
  late GetCommentsUseCase useCase;
  late MockPostRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockPostRemoteDataSource();
    useCase = GetCommentsUseCase(datasource: mockDataSource);
  });

  group('GetCommentsUseCase Tests', () {
    test('should return a list of comments when call is successful', () async {
      when(() => mockDataSource.getCommentsByPostId(1)).thenAnswer(
        (_) async => [
          Comment(
              postId: 1,
              id: 1,
              name: 'John Doe',
              email: 'john@example.com',
              body: 'Comment body 1'),
          Comment(
              postId: 1,
              id: 2,
              name: 'Jane Doe',
              email: 'jane@example.com',
              body: 'Comment body 2'),
        ],
      );

      final result = await useCase.call(1);

      verify(() => mockDataSource.getCommentsByPostId(1)).called(1);
      expect(result, isA<List<Comment>>());
      expect(result.length, 2);
      expect(result[0].name, 'John Doe');
      expect(result[1].name, 'Jane Doe');
    });

    test('should throw an exception when the datasource call fails', () async {
      when(() => mockDataSource.getCommentsByPostId(1))
          .thenThrow(Exception('Failed to fetch comments'));

      expect(() => useCase.call(1), throwsA(isA<Exception>()));

      verify(() => mockDataSource.getCommentsByPostId(1)).called(1);
    });
  });
}
