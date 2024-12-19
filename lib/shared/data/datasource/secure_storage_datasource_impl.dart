import 'package:blog/shared/domain/datasource/secure_storage_datasource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageDatasourceImpl implements SecureStorageDatasource {
  final FlutterSecureStorage _secureStorage;
  final String _tokenKey = 'user_token';

  SecureStorageDatasourceImpl(this._secureStorage);

  @override
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }
  
  @override
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }
}
