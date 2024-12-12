import 'package:blog/core/data/datasources/interface/remote_datasource.dart';
import 'package:blog/core/domain/entities/post.dart';
import 'package:blog/shared/domain/usecases/usecase.dart';

class GetPostsUseCase implements UseCase<List<Post>, void> {
  final PostRemoteDataSource postRemoteDataSource;

  GetPostsUseCase({required this.postRemoteDataSource});

  @override
  Future<List<Post>> call([void input]) async {
    return await postRemoteDataSource.getPosts();
  }
}
