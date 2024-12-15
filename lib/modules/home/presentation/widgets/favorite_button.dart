import 'package:blog/modules/home/presentation/cubit/favority_cubit.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final ButtonState buttonState;
  final FavoriteState post;
  final Future<void> Function(int postId, bool isFavorited) toggleFavorite;

  const FavoriteButton({
    super.key,
    required this.buttonState,
    required this.post,
    required this.toggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (buttonState == ButtonState.loading) {
      return const CircularProgressIndicator();
    }

    return IconButton(
      icon: Icon(
        post.isFavorited ? Icons.favorite : Icons.favorite_border,
        color: post.isFavorited ? Colors.red : null,
      ),
      onPressed: () {
        if (buttonState != ButtonState.loading) {
          toggleFavorite(post.id, !post.isFavorited);
        }
      },
    );
  }
}
