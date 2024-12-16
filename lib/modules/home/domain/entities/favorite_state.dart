import 'package:blog/modules/home/domain/entities/post.dart';

class FavoriteState extends Post {
  final bool isLoading;

  FavoriteState({
    this.isLoading = false,
    required super.id,
    required super.title,
    required super.body,
    super.isFavorited,
  });

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
