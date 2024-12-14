import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorited;
  final Function onToggleFavorite;

  const FavoriteButton({
    super.key,
    required this.isFavorited,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorited ? Icons.favorite : Icons.favorite_border,
        color: isFavorited ? Colors.red : null,
      ),
      onPressed: () => onToggleFavorite(),
    );
  }
}
