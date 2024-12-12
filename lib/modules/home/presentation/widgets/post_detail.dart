import 'package:flutter/material.dart';
import 'package:blog/modules/home/domain/entities/post.dart';

class PostDetail extends StatelessWidget {
  final Post post;

  const PostDetail({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(post.body),
          ],
        ),
      ),
    );
  }
}
