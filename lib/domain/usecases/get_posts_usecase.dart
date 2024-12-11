import 'package:blog/data/datasources/interface/remote_datasource.dart';
import 'package:blog/domain/entities/post.dart';

class GetPostsUseCase {
  final PostRemoteDataSource postRemoteDataSource;

  GetPostsUseCase({required this.postRemoteDataSource});

  Future<List<Post>> execute() async {
    return await postRemoteDataSource.getPosts();
  }
}
