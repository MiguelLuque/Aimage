import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimage/features/common/screens/empty_editing_screen.dart';

class ImageToImageMobileScreen extends ConsumerWidget {
  const ImageToImageMobileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
        padding: EdgeInsets.all(20.0), child: EmptyEditingScreen());
  }
}
