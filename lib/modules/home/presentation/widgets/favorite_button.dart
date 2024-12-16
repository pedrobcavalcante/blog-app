import 'package:blog/modules/home/domain/entities/favorite_state.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final bool isLoading;
  final FavoriteState post;
  final Future<void> Function(int postId, bool isFavorited) toggleFavorite;

  const FavoriteButton({
    super.key,
    required this.isLoading,
    required this.post,
    required this.toggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48, 
      width: 48,
      child: Center(
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : IconButton(
                icon: Icon(
                  post.isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: post.isFavorited ? Colors.red : null,
                ),
                onPressed: () {
                  if (!isLoading) {
                    toggleFavorite(post.id, !post.isFavorited);
                  }
                },
              ),
      ),
    );
  }
}
