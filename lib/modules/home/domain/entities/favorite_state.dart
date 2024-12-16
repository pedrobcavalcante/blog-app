import 'package:blog/modules/home/domain/entities/post.dart';
import 'package:equatable/equatable.dart';

class FavoriteState extends Post with EquatableMixin {
  final bool isLoading;

  FavoriteState({
    this.isLoading = false,
    required super.id,
    required super.title,
    required super.body,
    super.isFavorited,
  });

  @override
  List<Object?> get props => [id, title, body, isFavorited, isLoading];

  FavoriteState copyWith({
    bool? isLoading,
    int? id,
    String? title,
    String? body,
    bool? isFavorited,
  }) {
    return FavoriteState(
      isLoading: isLoading ?? this.isLoading,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }
}
