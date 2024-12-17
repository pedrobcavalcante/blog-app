import 'package:blog/modules/register/domain/usecases/create_user_with_email_and_password_usecase.dart';
import 'package:blog/modules/register/presentation/bloc/register_event.dart';
import 'package:blog/modules/register/presentation/bloc/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final CreateUserWithEmailAndPasswordUseCase createUserUseCase;

  RegisterBloc({required this.createUserUseCase}) : super(RegisterInitial()) {
    on<RegisterRequested>((event, emit) async {
      emit(RegisterInProgress());

      if (event.email.isEmpty || event.password.isEmpty) {
        emit(const RegisterFailure('Preencha email e senha corretamente.'));
        return;
      }

      if (event.password != event.confirmPassword) {
        emit(const RegisterFailure('As senhas não coincidem.'));
        return;
      }

      try {
        await createUserUseCase(Params(
          email: event.email,
          password: event.password,
        ));
        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterFailure(e.toString()));
      }
    });
  }
}
