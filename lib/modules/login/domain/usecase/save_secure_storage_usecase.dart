import 'package:blog/shared/domain/datasource/secure_storage_datasource.dart';
import 'package:blog/shared/domain/usecases/usecase.dart';

class SaveSecureStorageUseCase implements UseCase<String, void> {
  final SecureStorageDatasource _secureStorageDatasource;

  SaveSecureStorageUseCase(this._secureStorageDatasource);

  @override
  Future<void> call(String token) async {
    await _secureStorageDatasource.saveToken(token);
  }
}
