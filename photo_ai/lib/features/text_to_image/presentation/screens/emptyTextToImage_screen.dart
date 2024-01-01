import 'package:flutter/material.dart';

class EmptyTextToImageScreen extends StatelessWidget {
  const EmptyTextToImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: MaterialButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      enableFeedback: false,
      onPressed: null,
      child: Text(
        "No images yet. Start creating now!",
        style: TextStyle(fontSize: 20),
      ),
    ));
  }
}
