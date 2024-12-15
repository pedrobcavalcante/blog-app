import 'package:blog/modules/login/domain/usecase/save_secure_storage_usecase.dart';
import 'package:blog/shared/domain/datasource/secure_storage_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorageDatasource extends Mock
    implements SecureStorageDatasource {}

void main() {
  late SaveSecureStorageUseCase useCase;
  late MockSecureStorageDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockSecureStorageDatasource();
    useCase = SaveSecureStorageUseCase(mockDatasource);
  });

  group('SaveSecureStorageUseCase Tests', () {
    test('should call saveToken with the correct token', () async {
      const testToken = 'mock_token';

      when(() => mockDatasource.saveToken(testToken)).thenAnswer((_) async {});

      await useCase.call(testToken);

      verify(() => mockDatasource.saveToken(testToken)).called(1);
    });

    test('should throw an exception when saveToken fails', () async {
      const testToken = 'mock_token';

      when(() => mockDatasource.saveToken(testToken))
          .thenThrow(Exception('Failed to save token'));

      expect(() => useCase.call(testToken), throwsA(isA<Exception>()));

      verify(() => mockDatasource.saveToken(testToken)).called(1);
    });
  });
}
