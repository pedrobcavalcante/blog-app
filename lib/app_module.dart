import 'package:blog/core/config/config.dart';
import 'package:blog/data/datasources/remote_datasource_impl.dart';
import 'package:blog/modules/splash/presentation/screens/splash_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:blog/login_screen.dart';
import 'package:blog/domain/usecases/get_posts_usecase.dart';
import 'package:blog/core/network/http_client.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton<HttpClient>(
        () => HttpClient(baseUrl: Config.apiBaseUrl));
    i.addLazySingleton<PostRemoteDataSourceImpl>(
        () => PostRemoteDataSourceImpl(client: i()));
    i.addLazySingleton<GetPostsUseCase>(
        () => GetPostsUseCase(postRemoteDataSource: i()));
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const SplashScreen());
    r.child(LoginScreen.routeName, child: (context) => const LoginScreen());
  }
}
