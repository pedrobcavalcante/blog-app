import 'package:blog/core/config/config.dart';
import 'package:blog/core/guards/auth_guard.dart';
import 'package:blog/core/network/interface/http_client_interface.dart';
import 'package:blog/modules/app_drawer/domain/usecases/delete_token_usecase.dart';
import 'package:blog/modules/app_drawer/presentation/bloc/drawer_bloc.dart';
import 'package:blog/modules/home/data/datasources/interface/remote_datasource.dart';
import 'package:blog/modules/home/data/datasources/remote_datasource_impl.dart';
import 'package:blog/modules/home/domain/usecases/get_comments_usecas.dart';
import 'package:blog/modules/home/presentation/bloc/post_bloc.dart';
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:blog/modules/home/domain/usecases/get_posts_usecase.dart';
import 'package:blog/core/network/http_client.dart';
import 'package:blog/modules/login/domain/usecase/login_usecase.dart';
import 'package:blog/shared/data/datasource/firebase_auth_datasource.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    // Network
    i.addLazySingleton<HttpClientInterface>(
        () => HttpClient(baseUrl: Config.apiBaseUrl));

    // Firebase
    i.addLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

    // Storage
    i.addLazySingleton<FlutterSecureStorage>(
        () => const FlutterSecureStorage());

    // Data sources
    i.addLazySingleton<PostRemoteDataSource>(
        () => PostRemoteDataSourceImpl(client: i()));
    i.addLazySingleton<FirebaseAuthDatasource>(
        () => FirebaseAuthDatasourceImpl(firebaseAuth: i()));
    i.addLazySingleton<SecureStorageDatasource>(
        () => SecureStorageDatasourceImpl(i()));

    // Use cases
    i.addLazySingleton<GetPostsUseCase>(() => GetPostsUseCase(datasource: i()));
    i.addLazySingleton<LoginUseCase>(() => LoginUseCase(datasource: i()));
    i.addLazySingleton<GetTokenUseCase>(
        () => GetTokenUseCase(i()));
    i.addLazySingleton<SaveSecureStorageUseCase>(
        () => SaveSecureStorageUseCase(i()));
    i.addLazySingleton<GetCommentsUseCase>(
        () => GetCommentsUseCase(datasource: i()));
    i.addLazySingleton<DeleteTokenUseCase>(() => DeleteTokenUseCase(i()));

    // Blocs
    i.addLazySingleton<LoginBloc>(
        () => LoginBloc(loginUseCase: i(), saveSecureStorageUseCase: i()));
    i.addLazySingleton<SplashBloc>(
        () => SplashBloc(getSecureStorageUseCase: i()));
    i.addLazySingleton<PostBloc>(
        () => PostBloc(getPostsUseCase: i(), getCommentsUseCase: i()));
    i.addLazySingleton<DrawerBloc>(() => DrawerBloc(i()));
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const SplashScreen());
    r.child(LoginScreen.routeName, child: (context) => const LoginScreen());
    r.child(HomeScreen.routeName,
        child: (context) => const HomeScreen(), guards: [AuthGuard()]);
  }
}
