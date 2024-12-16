import 'package:blog/modules/app_drawer/domain/usecases/delete_email_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:blog/shared/domain/datasource/simples_storage_datasource.dart';

class MockSimpleStorageDatasource extends Mock
    implements SimpleStorageDatasource {}

void main() {
  late MockSimpleStorageDatasource mockSimpleStorageDatasource;
  late DeleteUserEmailUseCase deleteUserEmailUseCase;

  setUp(() {
    mockSimpleStorageDatasource = MockSimpleStorageDatasource();
    deleteUserEmailUseCase =
        DeleteUserEmailUseCase(mockSimpleStorageDatasource);
  });

  test('should call deleteEmail on SimpleStorageDatasource', () async {
    when(() => mockSimpleStorageDatasource.deleteEmail())
        .thenAnswer((_) async => Future.value());
    await deleteUserEmailUseCase();

    verify(() => mockSimpleStorageDatasource.deleteEmail()).called(1);
  });

  test('should throw an exception if deleteEmail fails', () async {
    when(() => mockSimpleStorageDatasource.deleteEmail())
        .thenThrow(Exception('Failed to delete'));

    expect(() => deleteUserEmailUseCase.call(), throwsA(isA<Exception>()));
  });
}
