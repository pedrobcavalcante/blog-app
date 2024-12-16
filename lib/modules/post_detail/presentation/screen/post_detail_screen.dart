import 'package:blog/modules/post_detail/presentation/cubit/post_detail_state.dart';
import 'package:blog/shared/domain/entities/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog/modules/post_detail/presentation/cubit/post_detail_cubit.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PostDetailScreen extends StatefulWidget {
  static const routeName = '/post-detail';
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController bodyController = TextEditingController();
  final cubit = Modular.get<PostDetailCubit>();

  @override
  void dispose() {
    Modular.dispose<PostDetailCubit>();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostDetailCubit>(
      create: (_) => cubit..initializeComments(widget.post.id),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Comentários",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'post-${widget.post.id}',
                child: Material(
                  child: Container(
                    color: const Color(0xFFF5F5F5),
                    child: Text(
                      widget.post.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.post.body,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey[800],
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<PostDetailCubit, PostDetailState>(
                builder: (context, state) {
                  if (state is PostDetailLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PostDetailError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is PostDetailLoaded) {
                    final comments = state.comments;
                    if (comments.isEmpty) {
                      return const Center(
                          child: Text('Nenhum comentário disponível.'));
                    }
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.only(bottom: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comment.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    comment.email,
                                    style: TextStyle(
                                      color: Colors.blueGrey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(comment.body),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bodyController,
                decoration: const InputDecoration(
                  labelText: 'Comentário',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  final commentText = bodyController.text;
                  if (commentText.isNotEmpty) {
                    cubit.addComment(commentText, widget.post.id);
                    bodyController.clear();
                  }
                },
                child: const Text('Adicionar Comentário'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
