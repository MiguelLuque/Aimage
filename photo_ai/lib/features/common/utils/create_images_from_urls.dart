import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_ai/features/text_to_image/presentation/screens/image_detailed_screen.dart';

List<Widget> createImagesFromList(List<String> urls, context) {
  // Crear una lista de widgets basada en la lista de strings
  List<Widget> widgets = [];

  for (String url in urls) {
    widgets.add(
      // Puedes personalizar el widget según tus necesidades
      SizedBox(
        width: (MediaQuery.of(context).size.height * 0.55) / 1.5,
        height: (MediaQuery.of(context).size.height * 0.55),
        child: FutureBuilder(
          future: waitForImage(url),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Muestra un indicador de carga mientras se obtiene la imagen.
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (snapshot.hasError) {
              // Maneja el error si ocurre.
              return const Icon(Icons.error);
            } else {
              // Muestra la imagen si se ha cargado correctamente.
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageDetailedScreen(
                        imageUrl: url,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          url,
                        ),
                      )),
                ),
              );
            }
          },
        ),
      ),
    );
  }
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
