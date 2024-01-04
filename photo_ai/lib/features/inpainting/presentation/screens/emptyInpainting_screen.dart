import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:photo_ai/features/text_to_image/photo_providers.dart';

class EmptyInpaintingScreen extends ConsumerStatefulWidget {
  const EmptyInpaintingScreen({super.key});

  @override
  ConsumerState<EmptyInpaintingScreen> createState() =>
      _EmptyInpaintingScreenState();
}

class _EmptyInpaintingScreenState extends ConsumerState<EmptyInpaintingScreen> {
  int? selectedImage;

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = [];

    imageUrls.addAll(ref.watch(textToImageNotifierProvider));
    imageUrls.addAll(ref.watch(imageToImageNotifierProvider));
    imageUrls
        .addAll(ref.watch(inpaintingImageNotifierProvider).generatedImages!);

    return imageUrls.isEmpty
        ? const Center(
            child: MaterialButton(
            splashColor: Color.fromARGB(0, 30, 24, 24),
            highlightColor: Colors.transparent,
            enableFeedback: false,
            onPressed: null,
            child: Text(
              "No images yet. Start creating now!",
              style: TextStyle(fontSize: 20),
            ),
          ))
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Wrap(
                  spacing: 15.0, // Espaciado entre los widgets
                  runSpacing: 15.0, // Espaciado entre las filas de widgets
                  children: _createCardsFromList(imageUrls, context),
                )
              ],
            ),
          );
  }

  List<Widget> _createCardsFromList(List<String> urls, context) {
    // Crear una lista de widgets basada en la lista de strings
    List<Widget> widgets = [];

    for (int i = 0; i < urls.length; i++) {
      widgets.add(
          // Puedes personalizar el widget según tus necesidades
          SizedBox(
              width: (MediaQuery.of(context).size.height * 0.55) / 1.5,
              height: (MediaQuery.of(context).size.height * 0.55),
              child: FutureBuilder(
                  future: waitForImage(urls[i]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Muestra un indicador de carga mientras se obtiene la imagen.
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      // Maneja el error si ocurre.
                      return const Icon(Icons.error);
                    } else {
                      // Muestra la imagen si se ha cargado correctamente.
                      return InkWell(
                          onTap: () {
                            setState(() {
                              selectedImage = i;
                            });
                          },
                          child: Card(
                            elevation: selectedImage == i
                                ? 8.0
                                : 4.0, // Ajusta la elevación según la selección
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(
                                color: selectedImage == i
                                    ? Colors.deepPurple
                                    : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Image.network(
                                      urls[i],
                                      // Ajusta la altura de la imagen según tus necesidades
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
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
    widgets.add(Center(
      child: ElevatedButton(
          onPressed: selectedImage == null
              ? null
              : () => ref
                  .read(selectedImageNotifierProvider.notifier)
                  .updateSelectedImage(urls[selectedImage!]),
          child: const Text("Set photo")),
    ));
    return widgets;
  }

  Future<void> waitForImage(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      while (true) {
        await Future.delayed(const Duration(seconds: 5));
        response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          break;
        }
      }
    }
  }
}
