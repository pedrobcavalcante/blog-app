// ignore_for_file: use_build_context_synchronously

import 'package:blog/modules/app_drawer/presentation/bloc/drawer_bloc.dart';
import 'package:blog/modules/app_drawer/presentation/bloc/drawer_event.dart';
import 'package:blog/modules/app_drawer/presentation/bloc/drawer_state.dart';
import 'package:blog/modules/login/presentation/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<DrawerBloc>();
    return BlocProvider(
      create: (context) => bloc,
      child: Drawer(
        backgroundColor: Colors.blueAccent,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
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
              const Text(
                'Usuário',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              BlocConsumer<DrawerBloc, DrawerState>(
                listener: (context, state) async {
                  if (state is DeleteTokenSuccess) {
                    await Modular.to.pushNamed(LoginScreen.routeName);
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
