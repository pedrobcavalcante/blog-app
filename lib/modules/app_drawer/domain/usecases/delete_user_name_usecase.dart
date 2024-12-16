import 'package:blog/core/domain/usecases/usecase.dart';
import 'package:blog/shared/domain/datasource/simples_storage_datasource.dart';

class DeleteUserNameUseCase implements UseCase<void, void> {
  final SimpleStorageDatasource _simpleStorageDatasource;

  DeleteUserNameUseCase(this._simpleStorageDatasource);

  @override
  Future<void> call([void input]) async {
    return await _simpleStorageDatasource.deleteName();
  }
}
