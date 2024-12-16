import 'package:blog/core/domain/usecases/usecase.dart';
import 'package:blog/modules/app_drawer/domain/usecases/delete_email_usecase.dart';
import 'package:blog/modules/app_drawer/domain/usecases/delete_token_usecase.dart';
import 'package:blog/modules/app_drawer/domain/usecases/delete_user_name_usecase.dart';

class DeleteUserDataUseCase implements UseCase<void, void> {
  final DeleteTokenUseCase _deleteTokenUseCase;
  final DeleteUserEmailUseCase _deleteUserEmailUseCase;
  final DeleteUserNameUseCase _deleteUserNameUseCase;

  DeleteUserDataUseCase({
    required DeleteTokenUseCase deleteTokenUseCase,
    required DeleteUserEmailUseCase deleteUserEmailUseCase,
    required DeleteUserNameUseCase deleteUserNameUseCase,
  })  : _deleteTokenUseCase = deleteTokenUseCase,
        _deleteUserEmailUseCase = deleteUserEmailUseCase,
        _deleteUserNameUseCase = deleteUserNameUseCase;

  @override
  Future<void> call([void input]) async {
    await Future.wait([
      _deleteTokenUseCase(),
      _deleteUserEmailUseCase(),
      _deleteUserNameUseCase(),
    ]);
  }
}
