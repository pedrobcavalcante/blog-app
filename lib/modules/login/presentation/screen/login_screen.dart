import 'package:blog/modules/login/presentation/bloc/login_bloc.dart';
import 'package:blog/modules/login/presentation/bloc/login_event.dart';
import 'package:blog/modules/login/presentation/bloc/login_state.dart';
import 'package:blog/modules/login/presentation/widgets/login_button.dart';
import 'package:blog/modules/login/presentation/widgets/login_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:blog/modules/home/presentation/screen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void dispose() {
    Modular.dispose<LoginBloc>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController(text: 'teste@email.com');
    final passwordController = TextEditingController(text: '12345678');
    final bloc = Modular.get<LoginBloc>();
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: const Center(
                child: Text(
                  'Blog App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(10, 15),
                    ),
                  ],
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            LoginTextField(
                              controller: emailController,
                              hintText: "E-mail",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira seu email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            LoginTextField(
                              hintText: "Senha",
                              controller: passwordController,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira sua senha';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            BlocConsumer<LoginBloc, LoginState>(
                              listener: (context, state) {
                                if (state is LoginSuccess) {
                                  Modular.to.pushNamed(
                                    HomeScreen.routeName,
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is LoginInProgress) {
                                  return const CircularProgressIndicator();
                                }
                                return Column(
                                  children: [
                                    LoginButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          bloc.add(
                                            LoginRequested(
                                              email: emailController.text,
                                              password: passwordController.text,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    state is LoginFailure
                                        ? Text(
                                            state.errorMessage,
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 16),
                                          )
                                        : const SizedBox(),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
