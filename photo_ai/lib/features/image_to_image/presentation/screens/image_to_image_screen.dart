import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_ai/features/common/screens/empty_editing_screen.dart';

class ImageToImageScreen extends ConsumerWidget {
  const ImageToImageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
        padding: const EdgeInsets.all(20.0), child: const EmptyEditingScreen());
  }
}
