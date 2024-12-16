import 'package:blog/modules/home/domain/datasources/remote_datasource.dart';
import 'package:blog/shared/domain/entities/post.dart';
import 'package:blog/core/domain/usecases/usecase.dart';

class GetPostsUseCase implements UseCase<List<Post>, void> {
  final PostRemoteDataSource datasource;

  GetPostsUseCase({required this.datasource});

  @override
  Future<List<Post>> call([void input]) async {
    return await datasource.getPosts();
  }
}
