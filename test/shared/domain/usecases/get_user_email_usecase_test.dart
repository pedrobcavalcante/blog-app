import 'package:blog/shared/domain/usecases/get_user_email_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:blog/shared/domain/datasource/simples_storage_datasource.dart';

class MockSimpleStorageDatasource extends Mock
    implements SimpleStorageDatasource {}

void main() {
  late MockSimpleStorageDatasource mockSimpleStorageDatasource;
  late GetUserEmailUseCase getUserEmailUseCase;

  setUp(() {
    mockSimpleStorageDatasource = MockSimpleStorageDatasource();
    getUserEmailUseCase = GetUserEmailUseCase(mockSimpleStorageDatasource);
  });

  test('should return the email from SimpleStorageDatasource', () async {
    const email = 'test@example.com';

    when(() => mockSimpleStorageDatasource.getEmail())
        .thenAnswer((_) async => email);

    final result = await getUserEmailUseCase.call();

    verify(() => mockSimpleStorageDatasource.getEmail()).called(1);
    expect(result, email);
  });

  test('should return null if no email is found', () async {
    when(() => mockSimpleStorageDatasource.getEmail())
        .thenAnswer((_) async => null);

    final result = await getUserEmailUseCase.call();

    verify(() => mockSimpleStorageDatasource.getEmail()).called(1);
    expect(result, isNull);
  });

  test('should throw an exception if getEmail fails', () async {
    when(() => mockSimpleStorageDatasource.getEmail())
        .thenThrow(Exception('Failed to get email'));

    expect(() => getUserEmailUseCase.call(), throwsA(isA<Exception>()));
  });
}
