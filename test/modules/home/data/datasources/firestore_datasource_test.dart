import 'package:blog/core/network/interface/http_client_interface.dart';
import 'package:blog/modules/home/data/datasources/post_remote_datasource_impl.dart';

import 'package:blog/modules/home/domain/entities/post.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockHttpClient extends Mock implements HttpClientInterface {}

void main() {
  late MockHttpClient mockClient;
  late PostRemoteDataSourceImpl dataSource;

  setUp(() {
    mockClient = MockHttpClient();
    dataSource = PostRemoteDataSourceImpl(client: mockClient);
  });

  group('getPosts', () {
    test('should return a list of posts when the call is successful', () async {
      final mockResponse = Response(
        data: [
          {'id': 1, 'title': 'Post 1', 'body': 'Content 1'},
          {'id': 2, 'title': 'Post 2', 'body': 'Content 2'},
        ],
        statusCode: 200,
        requestOptions: RequestOptions(path: '/posts'),
      );

      when(() => mockClient.get('/posts'))
          .thenAnswer((_) async => mockResponse);

      final result = await dataSource.getPosts();

      expect(result, isA<List<Post>>());
      expect(result.length, 2);
      expect(result.first.title, 'Post 1');
    });

    test('should throw an exception when the call fails', () async {
      when(() => mockClient.get('/posts'))
          .thenThrow(Exception('Failed to fetch posts'));

      expect(() => dataSource.getPosts(), throwsA(isA<Exception>()));
    });
  });

  group('getPostById', () {
    test('should return a post when the call is successful', () async {
      final mockResponse = Response(
        data: {'id': 1, 'title': 'Post 1', 'body': 'Content 1'},
        statusCode: 200,
        requestOptions: RequestOptions(path: '/posts/1'),
      );

      when(() => mockClient.get('/posts/1'))
          .thenAnswer((_) async => mockResponse);

      final result = await dataSource.getPostById(1);

      expect(result, isA<Post>());
      expect(result.title, 'Post 1');
    });

    test('should throw an exception when the call fails', () async {
      when(() => mockClient.get('/posts/1'))
          .thenThrow(Exception('Failed to fetch post'));

      expect(() => dataSource.getPostById(1), throwsA(isA<Exception>()));
    });
  });

  group('getCommentsByPostId', () {
    test('should throw an exception when the call fails', () async {
      when(() => mockClient.get('/comments?postId=1'))
          .thenThrow(Exception('Failed to fetch comments'));

      expect(
          () => dataSource.getCommentsByPostId(1), throwsA(isA<Exception>()));
    });

    test('should throw an exception when the call fails', () async {
      when(() => mockClient.get('/comments?postId=1'))
          .thenThrow(Exception('Failed to fetch comments'));

      expect(
          () => dataSource.getCommentsByPostId(1), throwsA(isA<Exception>()));
    });
  });
}
