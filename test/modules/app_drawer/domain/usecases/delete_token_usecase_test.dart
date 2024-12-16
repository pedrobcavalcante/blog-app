import 'package:blog/modules/app_drawer/domain/usecases/delete_token_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:blog/shared/domain/datasource/secure_storage_datasource.dart';

class MockSecureStorageDatasource extends Mock
    implements SecureStorageDatasource {}

void main() {
  late MockSecureStorageDatasource mockSecureStorageDatasource;
  late DeleteTokenUseCase deleteTokenUseCase;

  setUp(() {
    mockSecureStorageDatasource = MockSecureStorageDatasource();
    deleteTokenUseCase = DeleteTokenUseCase(mockSecureStorageDatasource);

    when(() => mockSecureStorageDatasource.deleteToken())
        .thenAnswer((_) async => Future.value());
  });

  test('should call deleteToken on SecureStorageDatasource', () async {
    await deleteTokenUseCase.call();

    verify(() => mockSecureStorageDatasource.deleteToken()).called(1);
  });

  test('should throw an exception if deleteToken fails', () async {
    when(() => mockSecureStorageDatasource.deleteToken())
        .thenThrow(Exception('Failed to delete token'));

    expect(() => deleteTokenUseCase.call(), throwsA(isA<Exception>()));
  });
}
