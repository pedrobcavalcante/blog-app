import 'package:blog/modules/home/presentation/screen/home_screen.dart';
import 'package:blog/modules/login/presentation/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog/modules/splash/presentation/bloc/splash_bloc.dart';
import 'package:blog/modules/splash/presentation/bloc/splash_state.dart';
import 'package:blog/modules/splash/presentation/bloc/splash_event.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          Modular.get<SplashBloc>()..add(CheckAuthentication()),
      child: const SplashScreenView(),
    );
  }
}

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: BlocConsumer<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is SplashAuthenticated) {
              Modular.to.pushReplacementNamed(HomeScreen.routeName);
            } else if (state is SplashUnauthenticated) {
              Modular.to.pushReplacementNamed(LoginScreen.routeName);
            }
          },
          builder: (context, state) {
            if (state is SplashLoading) {
              return const Center(
                child: Text(
                  'Blog App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
