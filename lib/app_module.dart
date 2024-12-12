import 'package:blog/core/config/config.dart';
import 'package:blog/core/data/datasources/remote_datasource_impl.dart';
import 'package:blog/modules/home/presentation/screen/home_screen.dart';
import 'package:blog/modules/login/domain/usecase/save_secure_storage_usecase.dart';
import 'package:blog/modules/login/presentation/bloc/login_bloc.dart';
import 'package:blog/modules/login/presentation/screen/login_screen.dart';
import 'package:blog/modules/splash/domain/usecase/get_secure_storage_usecase.dart';
import 'package:blog/modules/splash/presentation/bloc/splash_bloc.dart';
import 'package:blog/modules/splash/presentation/screen/splash_screen.dart';
import 'package:blog/shared/data/datasource/secure_storage_datasource.dart';
import 'package:blog/shared/domain/datasource/firebase_auth_datasource.dart';
import 'package:blog/shared/domain/datasource/secure_storage_datasource.dart';
import 'package:blog/shared/domain/usecases/usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:blog/core/domain/usecases/get_posts_usecase.dart';
import 'package:blog/core/network/http_client.dart';
import 'package:blog/modules/login/domain/usecase/login_usecase.dart';
import 'package:blog/shared/data/datasource/firebase_auth_datasource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    // Network
    i.addLazySingleton<HttpClient>(
        () => HttpClient(baseUrl: Config.apiBaseUrl));

    // Firebase
    i.addLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

    // Storage
    i.addLazySingleton<FlutterSecureStorage>(
        () => const FlutterSecureStorage());

    // Data sources
    i.addLazySingleton<PostRemoteDataSourceImpl>(
        () => PostRemoteDataSourceImpl(client: i()));
    i.addLazySingleton<FirebaseAuthDatasource>(
        () => FirebaseAuthDatasourceImpl(firebaseAuth: i()));
    i.addLazySingleton<SecureStorageDatasource>(
        () => SecureStorageDatasourceImpl(i()));

    // Use cases
    i.addLazySingleton<GetPostsUseCase>(
        () => GetPostsUseCase(postRemoteDataSource: i()));
    i.addLazySingleton<LoginUseCase>(() => LoginUseCase(datasource: i()));
    i.addLazySingleton<GetSecureStorageUseCase>(
        () => GetSecureStorageUseCase(i()));
    i.addLazySingleton<SaveSecureStorageUseCase>(
        () => SaveSecureStorageUseCase(i()));

    // Blocs
    i.addLazySingleton<LoginBloc>(
        () => LoginBloc(loginUseCase: i(), saveSecureStorageUseCase: i()));
    i.addLazySingleton<SplashBloc>(
        () => SplashBloc(getSecureStorageUseCase: i()));
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const SplashScreen());
    r.child(LoginScreen.routeName, child: (context) => const LoginScreen());
    r.child(HomeScreen.routeName, child: (context) => const HomeScreen());
  }
}
