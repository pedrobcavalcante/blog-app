import '../../../domain/entities/post.dart';

abstract class PostRemoteDataSource {
  Future<List<Post>> getPosts();
  Future<Post> getPostById(int id);
}
