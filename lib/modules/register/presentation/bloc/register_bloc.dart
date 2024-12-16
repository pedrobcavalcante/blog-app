import 'package:blog/modules/register/presentation/bloc/register_event.dart';
import 'package:blog/modules/register/presentation/bloc/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterRequested>((event, emit) async {
      emit(RegisterInProgress());
      // Simulação de espera (chamada ao usecase para registrar)
      await Future.delayed(const Duration(seconds: 2));

      // Exemplo de validação simples
      if (event.password != event.confirmPassword) {
        emit(const RegisterFailure('As senhas não coincidem.'));
      } else if (event.email.isEmpty || event.password.isEmpty) {
        emit(const RegisterFailure('Preencha todos os campos corretamente.'));
      } else {
        // Supondo sucesso
        emit(RegisterSuccess());
      }
    });
  }
}
