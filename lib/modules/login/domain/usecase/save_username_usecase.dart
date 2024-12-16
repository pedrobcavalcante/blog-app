import 'package:blog/core/domain/usecases/usecase.dart';
import 'package:blog/shared/domain/datasource/simples_storage_datasource.dart';

class SaveUsernameUseCase implements UseCase<String, String> {
  final SimpleStorageDatasource _datasource;

  SaveUsernameUseCase(this._datasource);

  @override
  Future<String> call(String name) async {
    await _datasource.saveName(name);
    return name;
  }
}
