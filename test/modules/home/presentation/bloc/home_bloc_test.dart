import 'package:blog/modules/home/domain/entities/comments.dart';
import 'package:blog/modules/home/domain/entities/post.dart';
import 'package:blog/modules/home/domain/usecases/get_comments_usecas.dart';
import 'package:blog/modules/home/domain/usecases/get_posts_with_favorites_usecase.dart';
import 'package:blog/modules/home/presentation/bloc/home_bloc.dart';
import 'package:blog/modules/home/presentation/bloc/home_event.dart';
import 'package:blog/modules/home/presentation/bloc/home_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCommentsUseCase extends Mock implements GetCommentsUseCase {}

class MockGetPostsWithFavoritesUseCase extends Mock
    implements GetPostsWithFavoritesUseCase {}

void main() {
  late HomeBloc homeBloc;
  late MockGetCommentsUseCase mockGetCommentsUseCase;
  late MockGetPostsWithFavoritesUseCase mockGetPostsWithFavoritesUseCase;

  setUp(() {
    mockGetCommentsUseCase = MockGetCommentsUseCase();
    mockGetPostsWithFavoritesUseCase = MockGetPostsWithFavoritesUseCase();

    homeBloc = HomeBloc(
      getCommentsUseCase: mockGetCommentsUseCase,
      getPostsWithFavoritesUseCase: mockGetPostsWithFavoritesUseCase,
    );

    registerFallbackValue(0);
  });

  tearDown(() {
    homeBloc.close();
  });

  group('HomeBloc Tests', () {
    final mockPosts = [
      Post(id: 1, title: 'Post 1', body: 'Body 1'),
      Post(id: 2, title: 'Post 2', body: 'Body 2'),
    ];
    final mockComments = [
      Comment(
          postId: 1,
          id: 1,
          name: 'User 1',
          email: 'email1@test.com',
          body: 'Comment 1'),
      Comment(
          postId: 1,
          id: 2,
          name: 'User 2',
          email: 'email2@test.com',
          body: 'Comment 2'),
    ];

    blocTest<HomeBloc, HomeState>(
      'should emit [HomeLoading, HomeLoaded] when posts are loaded successfully',
      build: () {
        when(() => mockGetPostsWithFavoritesUseCase.call())
            .thenAnswer((_) async => mockPosts);
        return homeBloc;
      },
      act: (bloc) => bloc.add(LoadPostsEvent()),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeLoaded>(),
      ],
      verify: (_) {
        verify(() => mockGetPostsWithFavoritesUseCase.call()).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'should emit [HomeLoading, HomeError] when loading posts fails',
      build: () {
        when(() => mockGetPostsWithFavoritesUseCase.call())
            .thenThrow(Exception('Erro ao carregar os posts.'));
        return homeBloc;
      },
      act: (bloc) => bloc.add(LoadPostsEvent()),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeError>(),
      ],
      verify: (_) {
        verify(() => mockGetPostsWithFavoritesUseCase.call()).called(1);
      },
    );

    test('should return comments when getComments is called successfully',
        () async {
      when(() => mockGetCommentsUseCase.call(1))
          .thenAnswer((_) async => mockComments);

      final result = await homeBloc.getComments(1);

      expect(result, mockComments);
      verify(() => mockGetCommentsUseCase.call(1)).called(1);
    });

    test('should throw exception when getComments fails', () async {
      when(() => mockGetCommentsUseCase.call(1))
          .thenThrow(Exception('Erro ao carregar os comentários'));

      expect(
        () async => await homeBloc.getComments(1),
        throwsA(isA<Exception>()),
      );

      verify(() => mockGetCommentsUseCase.call(1)).called(1);
    });
  });
}
