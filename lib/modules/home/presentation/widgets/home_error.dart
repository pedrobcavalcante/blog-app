import 'package:flutter/material.dart';

class HomeErrorWidget extends StatelessWidget {
  final String message;

  const HomeErrorWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
