import 'package:blog/shared/data/datasource/secure_storage_datasource_impl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late SecureStorageDatasourceImpl datasource;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    datasource = SecureStorageDatasourceImpl(mockSecureStorage);
  });

  group('SecureStorageDatasourceImpl Tests', () {
    const tokenKey = 'user_token';
    const tokenValue = 'mock_token';

    test('should call write to save the token', () async {
      when(() => mockSecureStorage.write(key: tokenKey, value: tokenValue))
          .thenAnswer((_) async {});

      await datasource.saveToken(tokenValue);

      verify(() => mockSecureStorage.write(key: tokenKey, value: tokenValue))
          .called(1);
    });

    test('should return the token when getToken is called', () async {
      when(() => mockSecureStorage.read(key: tokenKey))
          .thenAnswer((_) async => tokenValue);

      final result = await datasource.getToken();

      expect(result, tokenValue);
      verify(() => mockSecureStorage.read(key: tokenKey)).called(1);
    });

    test('should call delete to remove the token', () async {
      when(() => mockSecureStorage.delete(key: tokenKey))
          .thenAnswer((_) async {});

      await datasource.deleteToken();

      verify(() => mockSecureStorage.delete(key: tokenKey)).called(1);
    });
  });
}
