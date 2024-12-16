import 'package:blog/modules/home/domain/datasources/remote_datasource.dart';
import 'package:blog/shared/domain/entities/post.dart';
import 'package:blog/core/domain/usecases/usecase.dart';

class GetPostByIdUseCase implements UseCase<int, Post> {
  final PostRemoteDataSource postRemoteDataSource;

  GetPostByIdUseCase({required this.postRemoteDataSource});
  @override
  Future<Post> call(int id) async {
    return await postRemoteDataSource.getPostById(id);
  }
}
