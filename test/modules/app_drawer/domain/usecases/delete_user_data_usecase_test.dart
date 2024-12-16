import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:blog/modules/app_drawer/domain/usecases/delete_email_usecase.dart';
import 'package:blog/modules/app_drawer/domain/usecases/delete_token_usecase.dart';
import 'package:blog/modules/app_drawer/domain/usecases/delete_user_name_usecase.dart';
import 'package:blog/modules/app_drawer/domain/usecases/delete_user_data_usecase.dart';

class MockDeleteTokenUseCase extends Mock implements DeleteTokenUseCase {}

class MockDeleteUserEmailUseCase extends Mock
    implements DeleteUserEmailUseCase {}

class MockDeleteUserNameUseCase extends Mock implements DeleteUserNameUseCase {}

void main() {
  late MockDeleteTokenUseCase mockDeleteTokenUseCase;
  late MockDeleteUserEmailUseCase mockDeleteUserEmailUseCase;
  late MockDeleteUserNameUseCase mockDeleteUserNameUseCase;
  late DeleteUserDataUseCase deleteUserDataUseCase;

  setUp(() {
    mockDeleteTokenUseCase = MockDeleteTokenUseCase();
    mockDeleteUserEmailUseCase = MockDeleteUserEmailUseCase();
    mockDeleteUserNameUseCase = MockDeleteUserNameUseCase();
    deleteUserDataUseCase = DeleteUserDataUseCase(
      deleteTokenUseCase: mockDeleteTokenUseCase,
      deleteUserEmailUseCase: mockDeleteUserEmailUseCase,
      deleteUserNameUseCase: mockDeleteUserNameUseCase,
    );

    when(() => mockDeleteTokenUseCase())
        .thenAnswer((_) async => Future.value());
    when(() => mockDeleteUserEmailUseCase())
        .thenAnswer((_) async => Future.value());
    when(() => mockDeleteUserNameUseCase())
        .thenAnswer((_) async => Future.value());
  });

  test('should call delete methods for token, email, and username', () async {
    await deleteUserDataUseCase.call();

    verify(() => mockDeleteTokenUseCase()).called(1);
    verify(() => mockDeleteUserEmailUseCase()).called(1);
    verify(() => mockDeleteUserNameUseCase()).called(1);
  });

  test('should throw an exception if any delete method fails', () async {
    when(() => mockDeleteUserEmailUseCase())
        .thenThrow(Exception('Failed to delete email'));

    expect(() => deleteUserDataUseCase.call(), throwsA(isA<Exception>()));
  });
}
