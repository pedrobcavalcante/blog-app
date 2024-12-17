import 'package:blog/modules/login/presentation/bloc/login_bloc.dart';
import 'package:blog/modules/login/presentation/bloc/login_event.dart';
import 'package:blog/modules/login/presentation/bloc/login_state.dart';
import 'package:blog/shared/presentation/widgets/blog_button.dart';
import 'package:blog/shared/presentation/widgets/blog_text_field.dart';
import 'package:blog/modules/register/presentation/screen/register_screen.dart';
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
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: 'teste@email.com');
  final passwordController = TextEditingController(text: '12345678');
  final bloc = Modular.get<LoginBloc>();

  @override
  void dispose() {
    Modular.dispose<LoginBloc>();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height * 0.3,
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            'Blog App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.blue,
      body: Container(
        alignment: Alignment.center,
        height: size.height,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                BlogTextField(
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
                BlogTextField(
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
                  bloc: bloc,
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      Modular.to.pushReplacementNamed(HomeScreen.routeName);
                    }
                  },
                  builder: (context, state) {
                    if (state is LoginInProgress) {
                      return const CircularProgressIndicator();
                    }
                    return Column(
                      children: [
                        BlogButton(
                          text: "Login",
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              bloc.add(LoginRequested(
                                email: emailController.text,
                                password: passwordController.text,
                              ));
                            }
                          },
                        ),
                        if (state is LoginFailure)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              state.errorMessage,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        const SizedBox(height: 40),
                        TextButton(
                          onPressed: () {
                            Modular.to.pushNamed(RegisterScreen.routeName);
                          },
                          child: const Text(
                            'Ainda não possui uma conta? Registre-se',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
