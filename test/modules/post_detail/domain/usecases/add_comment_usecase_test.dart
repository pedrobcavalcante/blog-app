import 'package:blog/modules/post_detail/domain/usecases/add_comment_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:blog/modules/home/domain/datasources/remote_datasource.dart';
import 'package:blog/shared/domain/entities/comments.dart';

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

void main() {
  late MockPostRemoteDataSource mockPostRemoteDataSource;
  late AddCommentUseCase addCommentUseCase;

  setUp(() {
    mockPostRemoteDataSource = MockPostRemoteDataSource();
    addCommentUseCase = AddCommentUseCase(datasource: mockPostRemoteDataSource);
  });

  test('should call addComment on PostRemoteDataSource', () async {
    const comment = Comment(
        id: 1,
        postId: 1,
        name: 'Test',
        email: 'test@example.com',
        body: 'Test comment');

    when(() => mockPostRemoteDataSource.addComment(comment))
        .thenAnswer((_) async => comment);

    final result = await addCommentUseCase.call(comment);

    verify(() => mockPostRemoteDataSource.addComment(comment)).called(1);
    expect(result, comment);
  });

  test('should throw an exception if addComment fails', () async {
    const comment = Comment(
        id: 1,
        postId: 1,
        name: 'Test',
        email: 'test@example.com',
        body: 'Test comment');

    when(() => mockPostRemoteDataSource.addComment(comment))
        .thenThrow(Exception('Failed to add comment'));

    expect(() => addCommentUseCase.call(comment), throwsA(isA<Exception>()));
  });
}
