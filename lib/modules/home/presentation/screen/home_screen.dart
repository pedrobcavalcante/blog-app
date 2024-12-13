import 'package:blog/modules/home/presentation/bloc/post_event.dart';
import 'package:blog/modules/home/presentation/bloc/post_state.dart';
import 'package:blog/modules/home/presentation/widgets/post_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog/modules/home/presentation/bloc/post_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
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

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetail(
                            post: post,
                            future:
                                Modular.get<PostBloc>().getComments(post.id),
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'post-${post.id}',
                      child: Material(
                        color: Colors.transparent,
                        child: ListTile(
                          title: Text(post.title),
                          subtitle: Text(post.body),
                        ),
                      ),
                    ),
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
