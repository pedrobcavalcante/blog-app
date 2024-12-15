import 'package:blog/shared/domain/datasource/secure_storage_datasource.dart';
import 'package:blog/shared/domain/usecases/get_secure_storage_usecase.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorageDatasource extends Mock
    implements SecureStorageDatasource {}

void main() {
  late GetTokenUseCase useCase;
  late MockSecureStorageDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockSecureStorageDatasource();
    useCase = GetTokenUseCase(mockDatasource);
  });

  group('GetTokenUseCase Tests', () {
    test('should return the token when getToken is successful', () async {
      const token = 'mock_token';

      when(() => mockDatasource.getToken()).thenAnswer((_) async => token);

      final result = await useCase.call();

      expect(result, equals(token));
      verify(() => mockDatasource.getToken()).called(1);
    });

    test('should return null when no token is found', () async {
      when(() => mockDatasource.getToken()).thenAnswer((_) async => null);

      final result = await useCase.call();

      expect(result, isNull);
      verify(() => mockDatasource.getToken()).called(1);
    });

    test('should throw an exception when getToken fails', () async {
      when(() => mockDatasource.getToken())
          .thenThrow(Exception('Failed to get token'));

      expect(() => useCase.call(), throwsA(isA<Exception>()));
      verify(() => mockDatasource.getToken()).called(1);
    });
  });
}
