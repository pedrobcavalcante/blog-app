import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:blog/modules/post_detail/domain/usecases/add_comment_usecase.dart';
import 'package:blog/modules/post_detail/domain/usecases/get_comments_usecase.dart';
import 'package:blog/shared/domain/usecases/get_user_email_usecase.dart';
import 'package:blog/shared/domain/usecases/get_username_usecase.dart';
import 'package:blog/modules/post_detail/presentation/cubit/post_detail_cubit.dart';
import 'package:blog/modules/post_detail/presentation/cubit/post_detail_state.dart';
import 'package:blog/shared/domain/entities/comments.dart';
import 'package:bloc_test/bloc_test.dart';

class MockAddCommentUseCase extends Mock implements AddCommentUseCase {}

class MockGetCommentsUseCase extends Mock implements GetCommentsUseCase {}

class MockGetUserEmailUseCase extends Mock implements GetUserEmailUseCase {}

class MockGetUsernameUseCase extends Mock implements GetUsernameUseCase {}

void main() {
  late MockAddCommentUseCase mockAddCommentUseCase;
  late MockGetCommentsUseCase mockGetCommentsUseCase;
  late MockGetUserEmailUseCase mockGetUserEmailUseCase;
  late MockGetUsernameUseCase mockGetUsernameUseCase;
  late PostDetailCubit postDetailCubit;

  setUp(() {
    mockAddCommentUseCase = MockAddCommentUseCase();
    mockGetCommentsUseCase = MockGetCommentsUseCase();
    mockGetUserEmailUseCase = MockGetUserEmailUseCase();
    mockGetUsernameUseCase = MockGetUsernameUseCase();
    postDetailCubit = PostDetailCubit(
      addCommentUseCase: mockAddCommentUseCase,
      getCommentsUseCase: mockGetCommentsUseCase,
      getUserEmailUseCase: mockGetUserEmailUseCase,
      getUsernameUseCase: mockGetUsernameUseCase,
    );
  });

  group('initializeComments', () {
    blocTest<PostDetailCubit, PostDetailState>(
      'should emit [PostDetailLoading, PostDetailLoaded] on success',
      build: () {
        const postId = 1;
        const comments = [
          Comment(
              postId: postId,
              name: 'User',
              email: 'user@example.com',
              body: 'Nice post!')
        ];

        when(() => mockGetCommentsUseCase(postId))
            .thenAnswer((_) async => comments);

        return postDetailCubit;
      },
      act: (cubit) => cubit.initializeComments(1),
      expect: () => [
        PostDetailLoading(),
        PostDetailLoaded(const [
          Comment(
              postId: 1,
              name: 'User',
              email: 'user@example.com',
              body: 'Nice post!')
        ])
      ],
    );

    blocTest<PostDetailCubit, PostDetailState>(
      'should emit [PostDetailLoading, PostDetailError] on failure',
      build: () {
        when(() => mockGetCommentsUseCase(1))
            .thenThrow(Exception('Error loading comments'));
        return postDetailCubit;
      },
      act: (cubit) => cubit.initializeComments(1),
      expect: () => [
        PostDetailLoading(),
        PostDetailError('Erro ao carregar comentários.')
      ],
    );
  });

  group('addComment', () {
    blocTest<PostDetailCubit, PostDetailState>(
      'should emit [PostDetailLoading, PostDetailLoaded] on success',
      build: () {
        const postId = 1;
        const commentText = 'Great post!';
        const email = 'user@example.com';
        const name = 'User';
        const comment = Comment(
            postId: postId, name: name, email: email, body: commentText);

        when(() => mockGetUserEmailUseCase()).thenAnswer((_) async => email);
        when(() => mockGetUsernameUseCase()).thenAnswer((_) async => name);
        when(() => mockAddCommentUseCase(comment))
            .thenAnswer((_) async => comment);

        return postDetailCubit;
      },
      act: (cubit) => cubit.addComment('Great post!', 1),
      expect: () => [
        PostDetailLoading(),
        PostDetailLoaded(const [
          Comment(
              postId: 1,
              name: 'User',
              email: 'user@example.com',
              body: 'Great post!')
        ]),
      ],
    );

    blocTest<PostDetailCubit, PostDetailState>(
      'should emit [PostDetailLoading, PostDetailError] on failure',
      build: () {
        when(() => mockGetUserEmailUseCase())
            .thenThrow(Exception('Error fetching email'));
        when(() => mockGetUsernameUseCase())
            .thenThrow(Exception('Error fetching username'));

        return postDetailCubit;
      },
      act: (cubit) => cubit.addComment('Great post!', 1),
      expect: () => [
        PostDetailLoading(),
        PostDetailError('Erro ao adicionar comentário.')
      ],
    );
  });
}
