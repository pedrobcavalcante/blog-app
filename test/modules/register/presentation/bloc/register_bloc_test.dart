import 'package:bloc_test/bloc_test.dart';
import 'package:blog/modules/register/domain/usecases/create_user_with_email_and_password_usecase.dart';
import 'package:blog/modules/register/presentation/bloc/register_bloc.dart';
import 'package:blog/modules/register/presentation/bloc/register_event.dart';
import 'package:blog/modules/register/presentation/bloc/register_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockCreateUserWithEmailAndPasswordUseCase extends Mock
    implements CreateUserWithEmailAndPasswordUseCase {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockCreateUserWithEmailAndPasswordUseCase mockUseCase;
  late RegisterBloc bloc;

  const validEmail = 'test@test.com';
  const validPassword = '123456';
  const differentPassword = '654321';
  const invalidEmail = '';
  const invalidPassword = '';

  final tUserCredential = MockUserCredential();

  setUpAll(() {
    registerFallbackValue(
        const Params(email: validEmail, password: validPassword));
  });

  setUp(() {
    mockUseCase = MockCreateUserWithEmailAndPasswordUseCase();
    bloc = RegisterBloc(createUserUseCase: mockUseCase);
  });

  tearDown(() async {
    await bloc.close();
  });

  test('initial state should be RegisterInitial', () {
    expect(bloc.state, isA<RegisterInitial>());
  });

  blocTest<RegisterBloc, RegisterState>(
    'deve emitir falha se email ou senha estiverem vazios',
    build: () => bloc,
    act: (bloc) => bloc.add(const RegisterRequested(
      email: invalidEmail,
      password: invalidPassword,
      confirmPassword: '',
    )),
    expect: () => [
      RegisterInProgress(),
      const RegisterFailure('Preencha email e senha corretamente.'),
    ],
  );

  blocTest<RegisterBloc, RegisterState>(
    'deve emitir falha se as senhas não coincidem',
    build: () => bloc,
    act: (bloc) => bloc.add(const RegisterRequested(
      email: validEmail,
      password: validPassword,
      confirmPassword: differentPassword,
    )),
    expect: () => [
      RegisterInProgress(),
      const RegisterFailure('As senhas não coincidem.'),
    ],
  );

  blocTest<RegisterBloc, RegisterState>(
      'deve emitir sucesso quando o cadastro for bem-sucedido',
      build: () {
        when(() => mockUseCase.call(any()))
            .thenAnswer((_) async => tUserCredential);
        return bloc;
      },
      act: (bloc) => bloc.add(const RegisterRequested(
            email: validEmail,
            password: validPassword,
            confirmPassword: validPassword,
          )),
      expect: () => [
            RegisterInProgress(),
            RegisterSuccess(),
          ],
      verify: (_) {
        verify(() => mockUseCase
                .call(const Params(email: validEmail, password: validPassword)))
            .called(1);
      });

  blocTest<RegisterBloc, RegisterState>(
      'deve emitir falha quando o cadastro falhar',
      build: () {
        when(() => mockUseCase.call(any()))
            .thenThrow(Exception('Erro ao criar usuário'));
        return bloc;
      },
      act: (bloc) => bloc.add(const RegisterRequested(
            email: validEmail,
            password: validPassword,
            confirmPassword: validPassword,
          )),
      expect: () => [
            RegisterInProgress(),
            isA<RegisterFailure>(),
          ],
      verify: (_) {
        verify(() => mockUseCase
                .call(const Params(email: validEmail, password: validPassword)))
            .called(1);
      });
}
