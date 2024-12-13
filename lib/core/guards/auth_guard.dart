import 'package:blog/modules/login/presentation/screen/login_screen.dart';
import 'package:blog/modules/splash/domain/usecase/get_secure_storage_usecase.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthGuard extends RouteGuard {
  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    try {
      final token = await Modular.get<GetTokenUseCase>().call();
      if (token != null && token.isNotEmpty) {
        return true;
      }
    } catch (_) {}
    Modular.to.pushNamed(LoginScreen.routeName);
    return false;
  }
}
