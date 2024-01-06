import 'package:aimage/features/common/widgets/image_settings_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimage/features/common/utils/create_images_from_urls.dart';
import 'package:aimage/features/text_to_image/photo_providers.dart';
import 'package:aimage/features/common/screens/empty_image_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TextToImageMobileScreen extends ConsumerWidget {
  const TextToImageMobileScreen({super.key});

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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Images", style: TextStyle(fontSize: 20)),
                  Row(
                    children: [
                      const Text(
                        "All",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
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
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondary, // Color del borde
                            width: 2.0, // Ancho del borde
                          ),
                        ),
                        child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 10),
                                        child: SettingsForm(
                                          isMobile: true,
                                        ),
                                      ));
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.sliders,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            imageUrls.isEmpty
                ? Expanded(child: const EmptyImageScreen())
                : Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 10.0, // Espaciado entre los widgets
                        runSpacing:
                            15.0, // Espaciado entre las filas de widgets
                        children:
                            createMobileImagesFromList(imageUrls, context),
                      ),
                    ),
                  ),
          ],
        ));
  }
}
