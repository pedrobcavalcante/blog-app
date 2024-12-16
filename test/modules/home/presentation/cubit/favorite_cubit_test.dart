import 'package:bloc_test/bloc_test.dart';
import 'package:blog/modules/home/domain/entities/favorite_state.dart';
import 'package:blog/modules/home/presentation/cubit/favorite_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:blog/modules/home/presentation/cubit/favorite_cubit.dart';
import 'package:blog/modules/home/domain/usecases/toggle_favorite_post_usecase.dart';
import 'package:blog/shared/domain/entities/post.dart';

class MockToggleFavoritePostUseCase extends Mock
    implements ToggleFavoritePostUseCase {}

void main() {
  late FavoriteCubit favoriteCubit;
  late MockToggleFavoritePostUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockToggleFavoritePostUseCase();
    favoriteCubit = FavoriteCubit(mockUseCase);
  });

  final posts = [
    const Post(id: 1, title: 'Post 1', body: 'Body 1', isFavorited: false),
    const Post(id: 2, title: 'Post 2', body: 'Body 2', isFavorited: true),
  ];

  blocTest<FavoriteCubit, FavoriteCubitState>(
    'should emit FavoriteLoading and FavoriteLoaded when addFavorites succeeds',
    build: () => favoriteCubit,
    act: (cubit) => cubit.addFavorites(posts),
    expect: () => [isA<FavoriteLoading>(), isA<FavoriteLoaded>()],
  );

  blocTest<FavoriteCubit, FavoriteCubitState>(
    'should emit FavoriteLoaded with updated favorite when toggleFavorite succeeds',
    build: () {
      when(() => mockUseCase(
              const ToggleFavoritePostParams(postId: 1, isFavorited: true)))
          .thenAnswer((_) async {});
      return favoriteCubit;
    },
    seed: () => FavoriteLoaded([
      FavoriteState(
        id: 1,
        title: 'Post 1',
        body: 'Body 1',
        isFavorited: false,
      ),
    ]),
    act: (cubit) => cubit.toggleFavorite(1, true),
    expect: () => [
      FavoriteLoaded([
        FavoriteState(
          id: 1,
          title: 'Post 1',
          body: 'Body 1',
          isFavorited: false,
          isLoading: true,
        ),
      ]),
      FavoriteLoaded([
        FavoriteState(
          id: 1,
          title: 'Post 1',
          body: 'Body 1',
          isFavorited: true,
          isLoading: false,
        ),
      ]),
    ],
    verify: (_) {
      verify(() => mockUseCase(
            const ToggleFavoritePostParams(postId: 1, isFavorited: true),
          )).called(1);
    },
  );

  blocTest<FavoriteCubit, FavoriteCubitState>(
    'should emit FavoriteError when toggleFavorite fails',
    build: () {
      when(() => mockUseCase.call(
            const ToggleFavoritePostParams(postId: 1, isFavorited: true),
          )).thenThrow(Exception('Failed to toggle favorite'));
      return favoriteCubit;
    },
    seed: () => FavoriteLoaded([
      FavoriteState(
        id: 1,
        title: 'Post 1',
        body: 'Body 1',
        isFavorited: false,
      ),
    ]),
    act: (cubit) => cubit.toggleFavorite(1, true),
    expect: () => [
      isA<FavoriteLoaded>(),
      isA<FavoriteError>(),
    ],
  );
}
