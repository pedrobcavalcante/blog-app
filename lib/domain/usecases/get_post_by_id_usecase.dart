import 'package:blog/data/datasources/interface/remote_datasource.dart';
import 'package:blog/domain/entities/post.dart';

class GetPostByIdUseCase {
  final PostRemoteDataSource postRemoteDataSource;

  GetPostByIdUseCase({required this.postRemoteDataSource});

  Future<Post> execute(int id) async {
    return await postRemoteDataSource.getPostById(id);
  }
}
