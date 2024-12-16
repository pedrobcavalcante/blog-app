import 'package:blog/modules/home/domain/datasources/remote_datasource.dart';
import 'package:blog/shared/domain/entities/comments.dart';
import 'package:blog/core/domain/usecases/usecase.dart';

class AddCommentUseCase implements UseCase<Comment, Comment> {
  final PostRemoteDataSource _datasource;

  const AddCommentUseCase({required PostRemoteDataSource datasource})
      : _datasource = datasource;

  @override
  Future<Comment> call(Comment comment) async {
    return await _datasource.addComment(comment);
  }
}
