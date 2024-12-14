import 'package:blog/shared/domain/datasource/secure_storage_datasource.dart';
import 'package:blog/core/domain/usecases/usecase.dart';

class GetTokenUseCase implements UseCase<void, String?> {
  final SecureStorageDatasource _secureStorageDatasource;

  GetTokenUseCase(this._secureStorageDatasource);

  @override
  Future<String?> call([void input]) async {
    return await _secureStorageDatasource.getToken();
  }
}
