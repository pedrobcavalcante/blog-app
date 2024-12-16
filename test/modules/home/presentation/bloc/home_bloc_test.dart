import 'package:blog/shared/domain/entities/post.dart';
import 'package:blog/modules/post_detail/domain/usecases/get_comments_usecase.dart';
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

  late MockGetPostsWithFavoritesUseCase mockGetPostsWithFavoritesUseCase;

  setUp(() {
    mockGetPostsWithFavoritesUseCase = MockGetPostsWithFavoritesUseCase();

    homeBloc = HomeBloc(
      getPostsWithFavoritesUseCase: mockGetPostsWithFavoritesUseCase,
    );

    registerFallbackValue(0);
  });

  tearDown(() {
    homeBloc.close();
  });

  group('HomeBloc Tests', () {
    final mockPosts = [
      const Post(id: 1, title: 'Post 1', body: 'Body 1'),
      const Post(id: 2, title: 'Post 2', body: 'Body 2'),
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
  });
}
