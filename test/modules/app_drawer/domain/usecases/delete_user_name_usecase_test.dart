import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:blog/shared/domain/datasource/simples_storage_datasource.dart';

import 'package:blog/modules/app_drawer/domain/usecases/delete_user_name_usecase.dart';

class MockSimpleStorageDatasource extends Mock
    implements SimpleStorageDatasource {}

void main() {
  late MockSimpleStorageDatasource mockSimpleStorageDatasource;
  late DeleteUserNameUseCase deleteUserNameUseCase;

  setUp(() {
    mockSimpleStorageDatasource = MockSimpleStorageDatasource();
    deleteUserNameUseCase = DeleteUserNameUseCase(mockSimpleStorageDatasource);

    when(() => mockSimpleStorageDatasource.deleteName())
        .thenAnswer((_) async => Future.value());
  });

  test('should call deleteName on SimpleStorageDatasource', () async {
    await deleteUserNameUseCase.call();

    verify(() => mockSimpleStorageDatasource.deleteName()).called(1);
  });

  test('should throw an exception if deleteName fails', () async {
    when(() => mockSimpleStorageDatasource.deleteName())
        .thenThrow(Exception('Failed to delete name'));

    expect(() => deleteUserNameUseCase.call(), throwsA(isA<Exception>()));
  });
}
