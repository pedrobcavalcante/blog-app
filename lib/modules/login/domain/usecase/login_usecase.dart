import 'package:blog/shared/domain/datasource/firebase_auth_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blog/shared/domain/usecases/usecase.dart';

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}

class LoginUseCase implements UseCase<LoginParams, UserCredential?> {
  final FirebaseAuthDatasource datasource;

  LoginUseCase({required this.datasource});

  @override
  Future<UserCredential?> call(LoginParams params) async {
    return await datasource.loginWithEmailAndPassword(
      params.email,
      params.password,
    );
  }
}
