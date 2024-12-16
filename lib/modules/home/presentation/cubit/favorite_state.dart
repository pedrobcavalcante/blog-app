import 'package:blog/modules/home/domain/entities/favorite_state.dart';

abstract class FavoriteCubitState {}

class FavoriteInitial extends FavoriteCubitState {}

class FavoriteLoading extends FavoriteCubitState {}

class FavoriteLoaded extends FavoriteCubitState {
  final List<FavoriteState> favorites;

  FavoriteLoaded(this.favorites);
}

class FavoriteError extends FavoriteCubitState {
  final String message;

  FavoriteError(this.message);
}
