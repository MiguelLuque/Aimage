import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimage/features/common/utils/create_images_from_urls.dart';
import 'package:aimage/features/text_to_image/photo_providers.dart';
import 'package:aimage/features/common/screens/empty_image_screen.dart';

class ImageListScreen extends ConsumerWidget {
  const ImageListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> imageUrls = [];

    imageUrls.addAll(ref.watch(textToImageNotifierProvider));
    bool showAllImages = ref.watch(appSettingsNotifierProvider);

    if (showAllImages) {
      imageUrls.addAll(ref.watch(imageToImageNotifierProvider));
      imageUrls
          .addAll(ref.watch(inpaintingImageNotifierProvider).generatedImages!);
    }

    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: imageUrls.isEmpty
            ? const EmptyImageScreen()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("Show all creations"),
                        Switch(
                          // This bool value toggles the switch.
                          value: showAllImages,
                          onChanged: (bool value) {
                            // This is called when the user toggles the switch.
                            ref
                                .watch(appSettingsNotifierProvider.notifier)
                                .updateValue(value);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Wrap(
                        spacing: 15.0, // Espaciado entre los widgets
                        runSpacing:
                            15.0, // Espaciado entre las filas de widgets
                        children: createImagesFromList(imageUrls, context),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
