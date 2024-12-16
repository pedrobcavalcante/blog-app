import 'package:blog/core/domain/usecases/usecase.dart';
import 'package:blog/shared/domain/datasource/simples_storage_datasource.dart';

class DeleteUserEmailUseCase implements UseCase<void, void> {
  final SimpleStorageDatasource _simpleStorageDatasource;

  DeleteUserEmailUseCase(this._simpleStorageDatasource);

  @override
  Future<void> call([void input]) async {
    await _simpleStorageDatasource.deleteEmail();
  }
}
