import 'package:blog/modules/home/domain/datasources/remote_datasource.dart';
import 'package:blog/shared/domain/entities/comments.dart';
import 'package:blog/core/domain/usecases/usecase.dart';

class GetCommentsUseCase implements UseCase<int, List<Comment>> {
  final PostRemoteDataSource _datasource;

  const GetCommentsUseCase({required PostRemoteDataSource datasource})
      : _datasource = datasource;

  @override
  Future<List<Comment>> call(int postId) async {
    return await _datasource.getCommentsByPostId(postId);
  }
}
