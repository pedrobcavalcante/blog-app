import 'package:blog/core/domain/usecases/usecase.dart';
import 'package:blog/shared/domain/datasource/simples_storage_datasource.dart';

class GetUsernameUseCase implements UseCase<String?, void> {
  final SimpleStorageDatasource _datasource;

  GetUsernameUseCase(this._datasource);

  @override
  Future<String?> call([void input]) async {
    return await _datasource.getName();
  }
}
