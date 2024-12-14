import 'package:blog/shared/domain/datasource/secure_storage_datasource.dart';
import 'package:blog/core/domain/usecases/usecase.dart';

class DeleteTokenUseCase implements UseCase<void, void> {
  final SecureStorageDatasource _secureStorageDatasource;

  DeleteTokenUseCase(this._secureStorageDatasource);

  @override
  Future<void> call([void input]) async {
    await _secureStorageDatasource.deleteToken();
  }
}
