import 'package:aimage/features/common/widgets/loading_widget.dart';
import 'package:aimage/features/image_to_image/presentation/screens/image_to_image_screen.dart';
import 'package:aimage/features/inpainting/presentation/screens/inpainting_screen.dart';
import 'package:aimage/features/text_to_image/photo_providers.dart';
import 'package:aimage/features/text_to_image/presentation/screens/text_to_image_mobile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NarrowLayout extends ConsumerWidget {
  const NarrowLayout({super.key});

  @override
  Widget build(BuildContext context, ref) {
    var tab = ref.watch(featureNotifierProvider);
    bool isLoading = ref.watch(spinnerNotifierProvider);
    return SafeArea(
      child: loadFeature(tab, isLoading),
    );
  }

  Widget loadFeature(int tab, bool isLoading) {
    switch (tab) {
      case 1:
        return LoadingWidget(
            isLoading: isLoading, child: const ImageToImageScreen());
      case 2:
        return LoadingWidget(
            isLoading: isLoading, child: const InpaintingScreen());

      default:
        return LoadingWidget(
            isLoading: isLoading, child: const TextToImageMobileScreen());
    }
  }
}
