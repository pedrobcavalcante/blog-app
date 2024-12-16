import 'package:blog/modules/app_drawer/presentation/screen/app_drawer.dart';
import 'package:blog/modules/home/presentation/bloc/home_event.dart';
import 'package:blog/modules/home/presentation/bloc/home_state.dart';
import 'package:blog/modules/home/presentation/bloc/home_bloc.dart';
import 'package:blog/modules/home/presentation/widgets/home_error.dart';
import 'package:blog/modules/home/presentation/widgets/post_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void dispose() {
    Modular.dispose<HomeBloc>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Modular.get<HomeBloc>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Posts',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: BlocProvider(
        create: (context) => bloc..add(LoadPostsEvent()),
        child: RefreshIndicator(
          onRefresh: () async {
            bloc.add(LoadPostsEvent());
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is HomeError) {
                return HomeErrorWidget(message: state.message);
              }

              if (state is HomeLoaded) {
                return PostList(
                  posts: state.posts,
                );
              }
              return const HomeErrorWidget(message: 'Nenhum post encontrado.');
            },
          ),
        ),
      ),
    );
  }
}
