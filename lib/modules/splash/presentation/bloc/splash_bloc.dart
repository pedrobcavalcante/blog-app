import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final duration = const Duration(seconds: 3);

  SplashBloc() : super(SplashInitial()) {
    on<CheckAuthentication>((event, emit) async {
      emit(SplashLoading());

      final startTime = DateTime.now().millisecondsSinceEpoch;
      // String? token = await _storage.read(key: 'auth_token');
      final endTime = DateTime.now().millisecondsSinceEpoch;
      final timeElapsed = endTime - startTime;
      if (timeElapsed < duration.inMilliseconds) {
        await Future.delayed(duration - Duration(milliseconds: timeElapsed));
      }
      emit(SplashUnauthenticated());
    });
  }
}
