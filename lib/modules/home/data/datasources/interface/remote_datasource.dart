import 'package:blog/modules/home/domain/entities/comments.dart';
import 'package:blog/modules/home/domain/entities/post.dart';

abstract class PostRemoteDataSource {
  Future<List<Post>> getPosts();
  Future<Post> getPostById(int id);
  Future<List<Comment>> getCommentsByPostId(int postId);
}
