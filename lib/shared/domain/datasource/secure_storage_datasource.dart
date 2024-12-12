abstract class SecureStorageDatasource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
}
