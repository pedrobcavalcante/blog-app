import 'package:blog/core/config/config.dart';
import 'package:blog/core/guards/auth_guard.dart';
import 'package:blog/core/network/http_client.dart';
import 'package:blog/core/network/interface/http_client_interface.dart';
import 'package:blog/modules/app_drawer/domain/usecases/delete_email_usecase.dart';
import 'package:blog/modules/app_drawer/domain/usecases/delete_token_usecase.dart';
import 'package:blog/modules/app_drawer/domain/usecases/delete_user_data_usecase.dart';
import 'package:blog/modules/app_drawer/domain/usecases/delete_user_name_usecase.dart';
import 'package:blog/modules/app_drawer/presentation/bloc/drawer_bloc.dart';
import 'package:blog/modules/home/data/datasources/firestore_datasource_impl.dart';
import 'package:blog/modules/home/data/datasources/post_remote_datasource_impl.dart';
import 'package:blog/modules/home/data/repository/firestore_repository_impl.dart';
import 'package:blog/modules/home/domain/datasources/firestore_datasource.dart';
import 'package:blog/modules/home/domain/datasources/remote_datasource.dart';
import 'package:blog/modules/home/domain/repository/firebase_repository.dart';
import 'package:blog/modules/post_detail/domain/usecases/add_comment_usecase.dart';
import 'package:blog/modules/post_detail/domain/usecases/get_comments_usecase.dart';
import 'package:blog/modules/home/domain/usecases/get_favorite_posts_usecase.dart';
import 'package:blog/modules/home/domain/usecases/get_post_by_id_usecase.dart';
import 'package:blog/modules/home/domain/usecases/get_posts_usecase.dart';
import 'package:blog/modules/home/domain/usecases/get_posts_with_favorites_usecase.dart';
import 'package:blog/modules/home/domain/usecases/is_post_favorited_usecase.dart';
import 'package:blog/modules/home/domain/usecases/toggle_favorite_post_usecase.dart';
import 'package:blog/modules/home/presentation/bloc/home_bloc.dart';
import 'package:blog/modules/post_detail/presentation/cubit/post_detail_cubit.dart';
import 'package:blog/modules/home/presentation/cubit/favorite_cubit.dart';
import 'package:blog/modules/home/presentation/screen/home_screen.dart';
import 'package:blog/modules/login/domain/usecase/save_email_usecase.dart';
import 'package:blog/modules/login/domain/usecase/save_secure_storage_usecase.dart';
import 'package:blog/modules/login/domain/usecase/save_user_information_usecase.dart';
import 'package:blog/modules/login/domain/usecase/save_username_usecase.dart';
import 'package:blog/modules/login/presentation/bloc/login_bloc.dart';
import 'package:blog/modules/login/presentation/screen/login_screen.dart';
import 'package:blog/modules/post_detail/presentation/screen/post_detail_screen.dart';
import 'package:blog/modules/register/presentation/bloc/register_bloc.dart';
import 'package:blog/modules/register/presentation/screen/register_screen.dart';
import 'package:blog/shared/data/datasource/data_storage_datasource.dart';
import 'package:blog/shared/domain/datasource/simples_storage_datasource.dart';
import 'package:blog/shared/domain/usecases/get_secure_storage_usecase.dart';
import 'package:blog/modules/splash/presentation/bloc/splash_bloc.dart';
import 'package:blog/modules/splash/presentation/screen/splash_screen.dart';
import 'package:blog/shared/data/datasource/firebase_auth_datasource.dart';
import 'package:blog/shared/data/datasource/secure_storage_datasource.dart';
import 'package:blog/shared/domain/datasource/firebase_auth_datasource.dart';
import 'package:blog/shared/domain/datasource/secure_storage_datasource.dart';
import 'package:blog/shared/domain/usecases/get_user_email_usecase.dart';
import 'package:blog/shared/domain/usecases/get_username_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:blog/modules/login/domain/usecase/login_usecase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    // Network
    i.addLazySingleton<HttpClientInterface>(
        () => HttpClient(baseUrl: Config.apiBaseUrl));

    // Firebase
    i.addLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    i.addLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

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
    i.addLazySingleton<FavoriteDatasource>(
        () => FavoriteDatasourceImpl(firestore: i()));
    i.addLazySingleton<SimpleStorageDatasource>(
        () => SimpleStorageDatasourceImpl(i()));

    // Repositories
    i.addLazySingleton<FavoriteRepository>(
        () => FavoriteRepositoryImpl(datasource: i()));

    // Use cases
    i.addLazySingleton<GetPostsUseCase>(() => GetPostsUseCase(datasource: i()));
    i.addLazySingleton<LoginUseCase>(() => LoginUseCase(datasource: i()));
    i.addLazySingleton<GetTokenUseCase>(() => GetTokenUseCase(i()));
    i.addLazySingleton<SaveSecureStorageUseCase>(
        () => SaveSecureStorageUseCase(i()));
    i.addLazySingleton<GetCommentsUseCase>(
        () => GetCommentsUseCase(datasource: i()));
    i.addLazySingleton<DeleteTokenUseCase>(() => DeleteTokenUseCase(i()));
    i.addLazySingleton<GetPostByIdUseCase>(
        () => GetPostByIdUseCase(postRemoteDataSource: i()));
    i.addLazySingleton<GetPostsWithFavoritesUseCase>(
        () => GetPostsWithFavoritesUseCase(
              getPostsUseCase: i(),
              getFavoritePostsUseCase: i(),
            ));
    i.addLazySingleton<IsPostFavoritedUseCase>(
        () => IsPostFavoritedUseCase(repository: i(), getTokenUseCase: i()));
    i.addLazySingleton<ToggleFavoritePostUseCase>(
        () => ToggleFavoritePostUseCase(repository: i(), getTokenUseCase: i()));
    i.addLazySingleton<GetFavoritePostsUseCase>(() => GetFavoritePostsUseCase(
          getTokenUseCase: i(),
          repository: i(),
        ));
    i.addLazySingleton<AddCommentUseCase>(() => AddCommentUseCase(
          datasource: i(),
        ));
    i.addLazySingleton<SaveEmailUseCase>(() => SaveEmailUseCase(i()));
    i.addLazySingleton<SaveUsernameUseCase>(() => SaveUsernameUseCase(i()));
    i.addLazySingleton<DeleteUserDataUseCase>(() => DeleteUserDataUseCase(
          deleteUserEmailUseCase: i(),
          deleteTokenUseCase: i(),
          deleteUserNameUseCase: i(),
        ));
    i.addLazySingleton<GetUserEmailUseCase>(() => GetUserEmailUseCase(i()));
    i.addLazySingleton<GetUsernameUseCase>(() => GetUsernameUseCase(i()));
    i.addLazySingleton<DeleteUserNameUseCase>(() => DeleteUserNameUseCase(i()));
    i.addLazySingleton<DeleteUserEmailUseCase>(
        () => DeleteUserEmailUseCase(i()));
    i.addLazySingleton<SaveUserInformationUseCase>(() =>
        SaveUserInformationUseCase(
            saveEmailUseCase: i(),
            saveSecureStorageUseCase: i(),
            saveUsernameUseCase: i()));

    // Cubits
    i.addLazySingleton<FavoriteCubit>(() => FavoriteCubit(i()));
    i.addLazySingleton<PostDetailCubit>(
      () => PostDetailCubit(
        addCommentUseCase: i(),
        getCommentsUseCase: i(),
        getUserEmailUseCase: i(),
        getUsernameUseCase: i(),
      ),
    );

    // Blocs
    i.addLazySingleton<LoginBloc>(
      () => LoginBloc(loginUseCase: i(), saveUserInformationUseCase: i()),
    );
    i.addLazySingleton<RegisterBloc>(
      () => RegisterBloc(),
    );
    i.addLazySingleton<SplashBloc>(
        () => SplashBloc(getSecureStorageUseCase: i()));
    i.addLazySingleton<HomeBloc>(
      () => HomeBloc(
        getPostsWithFavoritesUseCase: i(),
      ),
    );
    i.addLazySingleton<DrawerBloc>(
      () => DrawerBloc(
        deleteUserDataUseCase: i(),
        getUserEmailUseCase: i(),
        getUsernameUseCase: i(),
      ),
    );
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const SplashScreen());
    r.child(LoginScreen.routeName, child: (context) => const LoginScreen());
    r.child(RegisterScreen.routeName,
        child: (context) => const RegisterScreen());
    r.child(HomeScreen.routeName,
        child: (context) => const HomeScreen(), guards: [AuthGuard()]);
    r.child(
      PostDetailScreen.routeName,
      guards: [AuthGuard()],
      child: (context) => PostDetailScreen(
        post: r.args.data,
      ),
    );
  }
}
