import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseAuthDatasource {
  Future<UserCredential?> loginWithEmailAndPassword(
      String email, String password);
}
