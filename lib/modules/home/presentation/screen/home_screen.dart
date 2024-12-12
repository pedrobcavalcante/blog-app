import 'package:blog/modules/home/presentation/widgets/post_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog/modules/home/presentation/bloc/post_bloc.dart';
import 'package:blog/modules/home/presentation/bloc/post_event.dart';
import 'package:blog/modules/home/presentation/bloc/post_state.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Principal'),
      ),
      body: BlocProvider(
        create: (context) => Modular.get<PostBloc>()..add(LoadPostsEvent()),
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PostError) {
              return Center(child: Text(state.message));
            }

            if (state is PostLoaded) {
              return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.body),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetail(post: post),
                        ),
                      );
                    },
                  );
                },
              );
            }

            return const Center(child: Text('Nenhum post encontrado.'));
          },
        ),
      ),
    );
  }
}
