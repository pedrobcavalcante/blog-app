import 'package:blog/modules/post_detail/domain/usecases/add_comment_usecase.dart';
import 'package:blog/modules/post_detail/domain/usecases/get_comments_usecase.dart';
import 'package:blog/modules/post_detail/presentation/cubit/post_detail_state.dart';
import 'package:blog/shared/domain/usecases/get_user_email_usecase.dart';
import 'package:blog/shared/domain/usecases/get_username_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog/shared/domain/entities/comments.dart';

class PostDetailCubit extends Cubit<PostDetailState> {
  final AddCommentUseCase _addCommentUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final GetUserEmailUseCase _getUserEmailUseCase;
  final GetUsernameUseCase _getUsernameUseCase;
  List<Comment> _comments = [];
  PostDetailCubit({
    required AddCommentUseCase addCommentUseCase,
    required GetCommentsUseCase getCommentsUseCase,
    required GetUserEmailUseCase getUserEmailUseCase,
    required GetUsernameUseCase getUsernameUseCase,
  })  : _addCommentUseCase = addCommentUseCase,
        _getCommentsUseCase = getCommentsUseCase,
        _getUserEmailUseCase = getUserEmailUseCase,
        _getUsernameUseCase = getUsernameUseCase,
        super(PostDetailInitial());

  Future<void> initializeComments(int postId) async {
    try {
      emit(PostDetailLoading());
      _comments = await _getCommentsUseCase(postId);
      emit(PostDetailLoaded(_comments));
    } catch (e) {
      emit(PostDetailError('Erro ao carregar comentários.'));
    }
  }

  Future<void> addComment(String comment, int postId) async {
    try {
      emit(PostDetailLoading());
      final email = await _getUserEmailUseCase();
      final name = await _getUsernameUseCase();
      final cmt =
          Comment(postId: postId, name: name!, email: email!, body: comment);
      await _addCommentUseCase(cmt);
      // adiocinado novo comentário, porém só funciona localmente. a Api do jsonplaceholder nao aceita comentários.
      _comments.add(cmt);
      emit(PostDetailLoaded(_comments));
    } catch (e) {
      emit(PostDetailError('Erro ao adicionar comentário.'));
    }
  }
}
