import 'package:blog/shared/domain/entities/comments.dart';
import 'package:blog/shared/domain/entities/post.dart';

abstract class PostRemoteDataSource {
  Future<List<Post>> getPosts();
  Future<Post> getPostById(int id);
  Future<List<Comment>> getCommentsByPostId(int postId);
  Future<Comment> addComment(Comment comment);
}

