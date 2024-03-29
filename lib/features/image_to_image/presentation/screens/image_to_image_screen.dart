import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimage/features/common/screens/empty_editing_screen.dart';

class ImageToImageScreen extends ConsumerWidget {
  const ImageToImageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const EmptyEditingScreen();
  }
}
