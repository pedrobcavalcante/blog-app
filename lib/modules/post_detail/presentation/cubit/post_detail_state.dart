import 'package:blog/shared/domain/entities/comments.dart';

import 'package:equatable/equatable.dart';

abstract class PostDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostDetailInitial extends PostDetailState {}

class PostDetailLoading extends PostDetailState {}

class PostDetailLoaded extends PostDetailState {
  final List<Comment> comments;

  PostDetailLoaded(this.comments);

  @override
  List<Object?> get props => [comments];
}

class PostDetailError extends PostDetailState {
  final String message;

  PostDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
