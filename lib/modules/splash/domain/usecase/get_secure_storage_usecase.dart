import 'package:blog/shared/domain/datasource/secure_storage_datasource.dart';
import 'package:blog/shared/domain/usecases/usecase.dart';

class GetSecureStorageUseCase implements UseCase<void, String?> {
  final SecureStorageDatasource _secureStorageDatasource;

  GetSecureStorageUseCase(this._secureStorageDatasource);

  @override
  Future<String?> call(void input) async {
    return await _secureStorageDatasource.getToken();
  }
}
