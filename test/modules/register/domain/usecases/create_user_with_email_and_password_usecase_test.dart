import 'package:blog/shared/domain/datasource/firebase_auth_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:blog/modules/register/domain/usecases/create_user_with_email_and_password_usecase.dart';

class MockFirebaseAuthDatasource extends Mock
    implements FirebaseAuthDatasource {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockFirebaseAuthDatasource mockDatasource;
  late CreateUserWithEmailAndPasswordUseCase usecase;

  setUp(() {
    mockDatasource = MockFirebaseAuthDatasource();
    usecase = CreateUserWithEmailAndPasswordUseCase(mockDatasource);

    registerFallbackValue(
        const Params(email: 'test@test.com', password: '123456'));
  });

  group('CreateUserWithEmailAndPasswordUseCase', () {
    const tEmail = 'test@test.com';
    const tPassword = '123456';
    const tParams = Params(email: tEmail, password: tPassword);
    final tUserCredential = MockUserCredential();

    test('deve retornar UserCredential quando criar o usuário com sucesso',
        () async {
      when(() =>
              mockDatasource.createUserWithEmailAndPassword(tEmail, tPassword))
          .thenAnswer((_) async => tUserCredential);

      final result = await usecase(tParams);

      expect(result, equals(tUserCredential));
      verify(() =>
              mockDatasource.createUserWithEmailAndPassword(tEmail, tPassword))
          .called(1);
    });

    test('deve lançar exceção quando retornar null', () async {
      when(() =>
              mockDatasource.createUserWithEmailAndPassword(tEmail, tPassword))
          .thenAnswer((_) async => null);

      final call = usecase(tParams);

      await expectLater(call, throwsA(isA<Exception>()));
      verify(() =>
              mockDatasource.createUserWithEmailAndPassword(tEmail, tPassword))
          .called(1);
    });
  });
}
