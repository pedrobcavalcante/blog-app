import 'package:blog/modules/home/domain/entities/post.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Post> posts;

  HomeLoaded(this.posts);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
