import 'package:aimage/features/common/utils/create_images_from_urls.dart';
import 'package:aimage/features/common/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimage/features/common/screens/empty_image_screen.dart';
import 'package:aimage/features/text_to_image/photo_providers.dart';

class EmptyEditingScreen extends ConsumerStatefulWidget {
  const EmptyEditingScreen({super.key});

  @override
  ConsumerState<EmptyEditingScreen> createState() => _EmptyEditingScreenState();
}

class _EmptyEditingScreenState extends ConsumerState<EmptyEditingScreen> {
  int? selectedImage;

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = [];

    imageUrls.addAll(ref.watch(textToImageNotifierProvider));
    bool showAllImages = ref.watch(appSettingsNotifierProvider);

    if (showAllImages) {
      imageUrls.addAll(ref.watch(imageToImageNotifierProvider));
      imageUrls
          .addAll(ref.watch(inpaintingImageNotifierProvider).generatedImages!);
    }

    return imageUrls.isEmpty
        ? const EmptyImageScreen()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GradientButton(
                      onPressed: selectedImage == null
                          ? null
                          : () => ref
                              .read(selectedImageNotifierProvider.notifier)
                              .updateSelectedImage(imageUrls[selectedImage!]),
                      child: Text(
                        "Select image",
                        style: Theme.of(context).textTheme.labelLarge,
                      )),
                  Row(
                    children: [
                      const Text("Show all creations"),
                      Switch(
                        // This bool value toggles the switch.
                        value: showAllImages,
                        onChanged: (bool value) {
                          // This is called when the user toggles the switch.
                          ref
                              .read(appSettingsNotifierProvider.notifier)
                              .updateValue(value);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Center(
                  child: Wrap(
                    spacing: 15.0, // Espaciado entre los widgets
                    runSpacing: 15.0, // Espaciado entre las filas de widgets
                    children:
                        _createSelectableCardsFromList(imageUrls, context),
                  ),
                ),
              ))
            ],
          );
  }

  List<Widget> _createSelectableCardsFromList(List<String> urls, context) {
    // Crear una lista de widgets basada en la lista de strings
    List<Widget> widgets = [];

    for (int i = 0; i < urls.length; i++) {
      widgets.add(
          // Puedes personalizar el widget según tus necesidades
          SizedBox(
              width: (MediaQuery.of(context).size.height * 0.55),
              height: (MediaQuery.of(context).size.height * 0.55),
              child: FutureBuilder(
                  future: waitForImage(urls[i]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Muestra un indicador de carga mientras se obtiene la imagen.
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    } else if (snapshot.hasError) {
                      // Maneja el error si ocurre.
                      return const Center(
                          child: Column(
                        children: [
                          Text("Error during generation"),
                          SizedBox(height: 5),
                          Icon(Icons.error),
                        ],
                      ));
                    } else {
                      // Muestra la imagen si se ha cargado correctamente.
                      return InkWell(
                          onTap: () {
                            setState(() {
                              selectedImage = i;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                //shape: selectedImage != i? null: BoxBorder.lerp(a, b, t),
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(
                                    urls[i],
                                  ),
                                )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    if (selectedImage == i)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                          size: 32.0,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ));
                    }
                  })));
    }

    return widgets;
  }
}
