abstract class HomeEvent {}

class LoadPostsEvent extends HomeEvent {}

class ToggleFavoritePostEvent extends HomeEvent {
  final int postId;
  final bool isFavorited;

  ToggleFavoritePostEvent({required this.postId, required this.isFavorited});
}
