import 'package:blog/modules/home/data/datasources/interface/remote_datasource.dart';
import 'package:blog/modules/home/domain/entities/post.dart';
import 'package:blog/shared/domain/usecases/usecase.dart';

class GetPostByIdUseCase implements UseCase<int, Post> {
  final PostRemoteDataSource postRemoteDataSource;

  GetPostByIdUseCase({required this.postRemoteDataSource});
  @override
  Future<Post> call(int id) async {
    return await postRemoteDataSource.getPostById(id);
  }
}