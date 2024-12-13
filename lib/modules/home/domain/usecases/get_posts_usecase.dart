import 'package:blog/modules/home/data/datasources/interface/remote_datasource.dart';
import 'package:blog/modules/home/domain/entities/post.dart';
import 'package:blog/shared/domain/usecases/usecase.dart';

class GetPostsUseCase implements UseCase<List<Post>, void> {
  final PostRemoteDataSource datasource;

  GetPostsUseCase({required this.datasource});

  @override
  Future<List<Post>> call([void input]) async {
    return await datasource.getPosts();
  }
}
