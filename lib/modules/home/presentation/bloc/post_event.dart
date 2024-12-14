abstract class PostEvent {}

class LoadPostsEvent extends PostEvent {}

class ToggleFavoritePostEvent extends PostEvent {
  final int postId;
  final bool isFavorited;

  ToggleFavoritePostEvent({required this.postId, required this.isFavorited});
}
