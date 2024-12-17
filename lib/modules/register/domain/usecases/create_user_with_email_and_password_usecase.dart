import 'package:blog/core/domain/usecases/usecase.dart';
import 'package:blog/shared/domain/datasource/firebase_auth_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Params extends Equatable {
  final String email;
  final String password;

  const Params({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class CreateUserWithEmailAndPasswordUseCase
    implements UseCase<Params, UserCredential> {
  final FirebaseAuthDatasource datasource;

  CreateUserWithEmailAndPasswordUseCase(this.datasource);

  @override
  Future<UserCredential> call(Params params) async {
    final credential = await datasource.createUserWithEmailAndPassword(
        params.email, params.password);
    if (credential == null) {
      throw Exception('Não foi possível criar o usuário.');
    }
    return credential;
  }
}
