import 'package:blog/modules/home/domain/entities/comments.dart';
import 'package:blog/modules/home/domain/entities/post.dart';
import 'package:blog/modules/home/presentation/cubit/favorite_cubit.dart';
import 'package:blog/modules/home/presentation/cubit/favorite_state.dart';
import 'package:blog/modules/home/presentation/widgets/favorite_button.dart';
import 'package:blog/modules/home/presentation/widgets/post_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PostList extends StatefulWidget {
  const PostList({
    required this.posts,
    required this.future,
    super.key,
  });

  final Future<List<Comment>> Function(int) future;
  final List<Post> posts;

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final _cubit = Modular.get<FavoriteCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.addFavorites(widget.posts);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoriteCubit>.value(
      value: _cubit,
      child: BlocBuilder<FavoriteCubit, FavoriteCubitState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoriteError) {
            return Center(child: Text(state.message));
          } else if (state is FavoriteLoaded) {
            final favorites = state.favorites;

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final post = favorites[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetail(
                          post: post,
                          future: widget.future(post.id),
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
                                isLoading: post.isLoading,
                                post: post,
                                toggleFavorite: _cubit.toggleFavorite,
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
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
