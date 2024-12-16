abstract class SimpleStorageDatasource {
  Future<void> saveName(String name);

  Future<String?> getName();

  Future<void> deleteName();

  Future<void> saveEmail(String email);

  Future<String?> getEmail();

  Future<void> deleteEmail();
}
