import 'dart:async';
import 'package:blog/modules/splash/domain/usecase/get_secure_storage_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final GetTokenUseCase _getSecureStorageUseCase;
  final duration = const Duration(seconds: 3);

  SplashBloc({required GetTokenUseCase getSecureStorageUseCase})
      : _getSecureStorageUseCase = getSecureStorageUseCase,
        super(SplashInitial()) {
    on<CheckAuthentication>((event, emit) async {
      emit(SplashLoading());

      final startTime = DateTime.now().millisecondsSinceEpoch;
      final token = await _getSecureStorageUseCase.call(null);
      if (dotenv.isInitialized == false) await dotenv.load();
      final endTime = DateTime.now().millisecondsSinceEpoch;
      final timeElapsed = endTime - startTime;
      if (timeElapsed < duration.inMilliseconds) {
        await Future.delayed(duration - Duration(milliseconds: timeElapsed));
      }

      if (token != null) {
        emit(SplashAuthenticated());
      } else {
        emit(SplashUnauthenticated());
      }
    });
  }
}
