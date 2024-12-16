import 'package:blog/modules/home/domain/entities/favorite_state.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteCubitState extends Equatable {
  const FavoriteCubitState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteCubitState {}

class FavoriteLoading extends FavoriteCubitState {}

class FavoriteLoaded extends FavoriteCubitState {
  final List<FavoriteState> favorites;

  const FavoriteLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];
}

class FavoriteError extends FavoriteCubitState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object?> get props => [message];
}
