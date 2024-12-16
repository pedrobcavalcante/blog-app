import 'package:blog/modules/login/domain/usecase/login_usecase.dart';
import 'package:blog/modules/login/domain/usecase/save_user_information_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final SaveUserInformationUseCase _saveUserInformationUseCase;

  LoginBloc({
    required this.loginUseCase,
    required SaveUserInformationUseCase saveUserInformationUseCase,
  })  : _saveUserInformationUseCase = saveUserInformationUseCase,
        super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }
  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<LoginState> emit) async {
    emit(LoginInProgress());

    try {
      final userCredential = await loginUseCase(LoginParams(
        email: event.email,
        password: event.password,
      ));

      await _saveUserInformationUseCase(userCredential!);

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(errorMessage: _getErrorMessage(e.code)));
    } catch (_) {
      emit(const LoginFailure(
          errorMessage: "Erro inesperado ao tentar fazer login."));
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'O email fornecido é inválido.';
      case 'user-disabled':
        return 'Este usuário foi desativado.';
      case 'user-not-found':
        return 'Nenhum usuário encontrado para este email.';
      default:
        return 'Erro ao tentar fazer login. Por favor, tente novamente.';
    }
  }
}
