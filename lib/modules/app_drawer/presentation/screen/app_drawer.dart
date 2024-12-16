// ignore_for_file: use_build_context_synchronously

import 'package:blog/modules/app_drawer/presentation/bloc/drawer_bloc.dart';
import 'package:blog/modules/app_drawer/presentation/bloc/drawer_event.dart';
import 'package:blog/modules/app_drawer/presentation/bloc/drawer_state.dart';

import 'package:blog/modules/login/presentation/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void dispose() {
    Modular.dispose<DrawerBloc>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<DrawerBloc>();
    return BlocProvider(
      create: (context) => bloc..add(DrawerInitialized()),
      child: Drawer(
        backgroundColor: Colors.blueAccent,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 48),
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.account_circle,
                  size: 60,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              BlocBuilder<DrawerBloc, DrawerState>(
                builder: (context, state) {
                  if (state is DrawerLoading) {
                    return const Text(
                      'Carregando...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else if (state is DrawerDataLoaded) {
                    return Column(
                      children: [
                        Text(
                          state.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          state.userEmail,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  } else if (state is DrawerFailure) {
                    return const Text(
                      'Erro ao carregar dados',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const Spacer(),
              BlocConsumer<DrawerBloc, DrawerState>(
                listener: (context, state) {
                  if (state is DeleteTokenSuccess) {
                    Modular.to.pushNamedAndRemoveUntil(
                        LoginScreen.routeName, (_) => false);
                  }
                  if (state is DeleteTokenFailure) {
                    Scaffold.of(context).closeDrawer();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                },
                builder: (context, state) {
                  return ElevatedButton.icon(
                    onPressed: () {
                      bloc.add(DeleteTokenRequested());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    icon: const Icon(Icons.exit_to_app, color: Colors.white),
                    label: const Text(
                      'Sair',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
