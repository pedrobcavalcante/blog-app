import 'package:blog/modules/login/domain/usecase/login_usecase.dart';
import 'package:blog/modules/login/domain/usecase/save_secure_storage_usecase.dart';
import 'package:blog/modules/login/presentation/bloc/login_bloc.dart';
import 'package:blog/modules/login/presentation/bloc/login_event.dart';
import 'package:blog/modules/login/presentation/bloc/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockSaveSecureStorageUseCase extends Mock
    implements SaveSecureStorageUseCase {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockSaveSecureStorageUseCase mockSaveSecureStorageUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockSaveSecureStorageUseCase = MockSaveSecureStorageUseCase();

    registerFallbackValue(LoginParams(email: 'fallback', password: 'fallback'));
  });

  group('LoginBloc Tests', () {
    const email = 'test@example.com';
    const password = 'password123';
    const userId = 'mock_uid';

    blocTest<LoginBloc, LoginState>(
      'should emit [LoginInProgress, LoginSuccess] on successful login',
      build: () {
        final mockUser = MockUser();
        final mockUserCredential = MockUserCredential();

        when(() => mockUser.uid).thenReturn(userId);
        when(() => mockUserCredential.user).thenReturn(mockUser);
        when(() => mockLoginUseCase.call(any()))
            .thenAnswer((_) async => mockUserCredential);
        when(() => mockSaveSecureStorageUseCase.call(userId))
            .thenAnswer((_) async {});

        return LoginBloc(
          loginUseCase: mockLoginUseCase,
          saveSecureStorageUseCase: mockSaveSecureStorageUseCase,
        );
      },
      act: (bloc) => bloc.add(LoginRequested(email: email, password: password)),
      expect: () => [
        LoginInProgress(),
        LoginSuccess(),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase.call(any())).called(1);
        verify(() => mockSaveSecureStorageUseCase.call(userId)).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [LoginInProgress, LoginFailure] when FirebaseAuthException occurs',
      build: () {
        when(() => mockLoginUseCase.call(any())).thenThrow(
          FirebaseAuthException(code: 'user-not-found'),
        );

        return LoginBloc(
          loginUseCase: mockLoginUseCase,
          saveSecureStorageUseCase: mockSaveSecureStorageUseCase,
        );
      },
      act: (bloc) => bloc.add(LoginRequested(email: email, password: password)),
      expect: () => [
        LoginInProgress(),
        const LoginFailure(
            errorMessage: 'Nenhum usuário encontrado para este email.'),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase.call(any())).called(1);
        verifyNever(() => mockSaveSecureStorageUseCase.call(any()));
      },
    );

    blocTest<LoginBloc, LoginState>(
      'should emit [LoginInProgress, LoginFailure] on unexpected error',
      build: () {
        when(() => mockLoginUseCase.call(any()))
            .thenThrow(Exception('Unexpected'));

        return LoginBloc(
          loginUseCase: mockLoginUseCase,
          saveSecureStorageUseCase: mockSaveSecureStorageUseCase,
        );
      },
      act: (bloc) => bloc.add(LoginRequested(email: email, password: password)),
      expect: () => [
        LoginInProgress(),
        const LoginFailure(
            errorMessage: 'Erro inesperado ao tentar fazer login.'),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase.call(any())).called(1);
        verifyNever(() => mockSaveSecureStorageUseCase.call(any()));
      },
    );
  });
}
