import 'package:blog/core/network/interface/http_client_interface.dart';
import 'package:blog/modules/home/domain/datasources/remote_datasource.dart';
import 'package:blog/modules/home/domain/entities/comments.dart';
import 'package:blog/modules/home/domain/entities/post.dart';

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final HttpClientInterface client;

  PostRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Post>> getPosts() async {
    try {
      final response = await client.get('/posts');
      final List<dynamic> json = response.data;
      return json.map((post) => Post.fromJson(post)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts');
    }
  }

  @override
  Future<Post> getPostById(int id) async {
    try {
      final response = await client.get('/posts/$id');
      return Post.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch post');
    }
  }

  @override
  Future<List<Comment>> getCommentsByPostId(int postId) async {
    try {
      final response = await client.get('/comments?postId=$postId');
      final List<dynamic> json = response.data;
      return json.map((comment) => Comment.fromJson(comment)).toList();
    } catch (e) {
      throw Exception('Failed to fetch comments');
    }
  }
}
