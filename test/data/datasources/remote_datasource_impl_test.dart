import 'package:blog/core/network/interface/http_client_interface.dart';
import 'package:blog/modules/home/data/datasources/remote_datasource_impl.dart';
import 'package:blog/modules/home/domain/entities/post.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

class MockHttpClient extends Mock implements HttpClientInterface {}

void main() {
  late MockHttpClient mockHttpClient;
  late PostRemoteDataSourceImpl postRemoteDataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    postRemoteDataSource = PostRemoteDataSourceImpl(client: mockHttpClient);

    when(() => mockHttpClient.get('/posts')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/posts'),
        statusCode: 200,
        data: [
          {'id': 1, 'title': 'Post 1', 'body': 'This is the body of post 1'},
          {'id': 2, 'title': 'Post 2', 'body': 'This is the body of post 2'}
        ],
      ),
    );

    when(() => mockHttpClient.get('/posts/1')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/posts/1'),
        statusCode: 200,
        data: {
          'id': 1,
          'title': 'Post 1',
          'body': 'This is the body of post 1'
        },
      ),
    );
  });

  group('PostRemoteDataSourceImpl Tests', () {
    test('should return a list of posts when calling getPosts', () async {
      final result = await postRemoteDataSource.getPosts();

      verify(() => mockHttpClient.get('/posts')).called(1);

      expect(result, isA<List<Post>>());
      expect(result.length, 2);
      expect(result[0].title, 'Post 1');
      expect(result[1].title, 'Post 2');
    });

    test('should return a single post when calling getPostById', () async {
      final result = await postRemoteDataSource.getPostById(1);

      verify(() => mockHttpClient.get('/posts/1')).called(1);

      expect(result, isA<Post>());
      expect(result.id, 1);
      expect(result.title, 'Post 1');
    });

    test('should throw an exception when getPosts fails', () async {
      when(() => mockHttpClient.get('/posts'))
          .thenThrow(Exception('Failed to fetch posts'));

      expect(() => postRemoteDataSource.getPosts(), throwsA(isA<Exception>()));
    });

    test('should throw an exception when getPostById fails', () async {
      when(() => mockHttpClient.get('/posts/1'))
          .thenThrow(Exception('Failed to fetch post'));

      expect(
          () => postRemoteDataSource.getPostById(1), throwsA(isA<Exception>()));
    });
  });
}
