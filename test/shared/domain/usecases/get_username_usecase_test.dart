import 'package:blog/shared/domain/usecases/get_username_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:blog/shared/domain/datasource/simples_storage_datasource.dart';

class MockSimpleStorageDatasource extends Mock
    implements SimpleStorageDatasource {}

void main() {
  late MockSimpleStorageDatasource mockSimpleStorageDatasource;
  late GetUsernameUseCase getUsernameUseCase;

  setUp(() {
    mockSimpleStorageDatasource = MockSimpleStorageDatasource();
    getUsernameUseCase = GetUsernameUseCase(mockSimpleStorageDatasource);
  });

  test('should return the username from SimpleStorageDatasource', () async {
    const username = 'testUser';

    when(() => mockSimpleStorageDatasource.getName())
        .thenAnswer((_) async => username);

    final result = await getUsernameUseCase.call();

    verify(() => mockSimpleStorageDatasource.getName()).called(1);
    expect(result, username);
  });

  test('should return null if no username is found', () async {
    when(() => mockSimpleStorageDatasource.getName())
        .thenAnswer((_) async => null);

    final result = await getUsernameUseCase.call();

    verify(() => mockSimpleStorageDatasource.getName()).called(1);
    expect(result, isNull);
  });

  test('should throw an exception if getName fails', () async {
    when(() => mockSimpleStorageDatasource.getName())
        .thenThrow(Exception('Failed to get username'));

    expect(() => getUsernameUseCase.call(), throwsA(isA<Exception>()));
  });
}
