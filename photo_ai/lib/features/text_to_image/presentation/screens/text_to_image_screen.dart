import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_ai/features/common/utils/create_images_from_urls.dart';
import 'package:photo_ai/features/text_to_image/photo_providers.dart';
import 'package:photo_ai/features/text_to_image/presentation/screens/emptyTextToImage_screen.dart';

class ImageListScreen extends ConsumerWidget {
  const ImageListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> imageUrls = ref.watch(textToImageNotifierProvider);

    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: imageUrls.isEmpty
            ? const EmptyTextToImageScreen()
            : SingleChildScrollView(
                child: Center(
                  child: Wrap(
                    spacing: 15.0, // Espaciado entre los widgets
                    runSpacing: 15.0, // Espaciado entre las filas de widgets
                    children: createImagesFromList(imageUrls, context),
                  ),
                ),
              ));
  }
}
