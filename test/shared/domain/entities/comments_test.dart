import 'package:flutter_test/flutter_test.dart';
import 'package:blog/shared/domain/entities/comments.dart';

void main() {
  group('Comment', () {
    test(
        'toJson should return a valid map representation of the Comment object',
        () {
      const comment = Comment(
        postId: 1,
        id: 2,
        name: 'Test User',
        email: 'test@example.com',
        body: 'This is a test comment.',
      );

      final result = comment.toJson();

      expect(result, {
        'postId': 1,
        'id': 2,
        'name': 'Test User',
        'email': 'test@example.com',
        'body': 'This is a test comment.',
      });
    });
  });
}
