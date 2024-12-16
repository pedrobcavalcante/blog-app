import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final int postId;
  final int? id;
  final String name;
  final String email;
  final String body;

  const Comment({
    required this.postId,
    required this.name,
    required this.email,
    required this.body,
    this.id,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      postId: json['postId'] as int? ?? 0,
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'id': id,
      'name': name,
      'email': email,
      'body': body,
    };
  }

  @override
  List<Object?> get props => [postId, id, name, email, body];
}
