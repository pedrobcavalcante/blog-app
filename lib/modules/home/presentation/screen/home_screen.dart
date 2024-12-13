import 'package:flutter/material.dart';
import 'package:blog/modules/home/presentation/bloc/post_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog/modules/home/presentation/bloc/post_event.dart';
import 'package:blog/modules/home/presentation/bloc/post_state.dart';
import 'package:blog/modules/home/presentation/widgets/post_detail.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Posts',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
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
                padding: const EdgeInsets.all(8),
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
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              post.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              post.body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                            tileColor: const Color(0xFFF5F5F5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
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
