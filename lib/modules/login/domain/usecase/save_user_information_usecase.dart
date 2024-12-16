import 'package:blog/core/domain/usecases/usecase.dart';
import 'package:blog/modules/login/domain/usecase/save_email_usecase.dart';
import 'package:blog/modules/login/domain/usecase/save_secure_storage_usecase.dart';
import 'package:blog/modules/login/domain/usecase/save_username_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SaveUserInformationUseCase implements UseCase<UserCredential, void> {
  final SaveSecureStorageUseCase saveSecureStorageUseCase;
  final SaveEmailUseCase saveEmailUseCase;
  final SaveUsernameUseCase saveUsernameUseCase;

  SaveUserInformationUseCase({
    required this.saveSecureStorageUseCase,
    required this.saveEmailUseCase,
    required this.saveUsernameUseCase,
  });

  @override
  Future<void> call(UserCredential userCredential) async {
    await saveSecureStorageUseCase(userCredential.user!.uid);
    await saveEmailUseCase(userCredential.user!.email ?? '');
    if (userCredential.user!.displayName == null) {
      await saveUsernameUseCase(userCredential.user!.email!.split('@')[0]);
    } else {
      await saveUsernameUseCase(userCredential.user!.displayName ?? '');
    }
  }
}
