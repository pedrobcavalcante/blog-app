import 'package:blog/shared/domain/datasource/simples_storage_datasource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SimpleStorageDatasourceImpl implements SimpleStorageDatasource {
  final FlutterSecureStorage _secureStorage;
  final String _nameKey = 'user_name';
  final String _emailKey = 'user_email';

  SimpleStorageDatasourceImpl(this._secureStorage);

  @override
  Future<void> saveName(String name) async {
    await _secureStorage.write(key: _nameKey, value: name);
  }

  @override
  Future<String?> getName() async {
    return await _secureStorage.read(key: _nameKey);
  }

  @override
  Future<void> deleteName() async {
    await _secureStorage.delete(key: _nameKey);
  }

  @override
  Future<void> saveEmail(String email) async {
    await _secureStorage.write(key: _emailKey, value: email);
  }

  @override
  Future<String?> getEmail() async {
    return await _secureStorage.read(key: _emailKey);
  }

  @override
  Future<void> deleteEmail() async {
    await _secureStorage.delete(key: _emailKey);
  }
}
