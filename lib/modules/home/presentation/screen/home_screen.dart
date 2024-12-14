import 'package:blog/modules/app_drawer/presentation/screen/app_drawer.dart';
import 'package:blog/modules/home/presentation/bloc/home_event.dart';
import 'package:blog/modules/home/presentation/bloc/home_state.dart';
import 'package:blog/modules/home/presentation/widgets/favorite_button.dart';
import 'package:blog/modules/home/presentation/bloc/home_bloc.dart';
import 'package:blog/modules/home/presentation/widgets/post_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
        create: (context) => Modular.get<HomeBloc>()..add(LoadPostsEvent()),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeError) {
              return Center(child: Text(state.message));
            }

            if (state is HomeLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  Modular.get<HomeBloc>().add(LoadPostsEvent());
                },
                child: ListView.builder(
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
                                  Modular.get<HomeBloc>().getComments(post.id),
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
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      post.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  FavoriteButton(
                                    isFavorited: post.isFavorited,
                                    onToggleFavorite: () {
                                      Modular.get<HomeBloc>().add(
                                          ToggleFavoritePostEvent(
                                              isFavorited: !post.isFavorited,
                                              postId: post.id));
                                    },
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                post.body,
                                style: const TextStyle(fontSize: 14),
                              ),
                              tileColor: const Color(0xFFF5F5F5),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return const Center(child: Text('Nenhum post encontrado.'));
          },
        ),
      ),
    );
  }
}
