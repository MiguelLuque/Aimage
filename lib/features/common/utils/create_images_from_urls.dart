import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aimage/features/text_to_image/presentation/screens/image_detailed_screen.dart';

List<Widget> createImagesFromList(List<String> urls, context) {
  // Crear una lista de widgets basada en la lista de strings
  List<Widget> widgets = [];

  for (String url in urls) {
    widgets.add(
      // Puedes personalizar el widget según tus necesidades
      SizedBox(
        width: (MediaQuery.of(context).size.height * 0.55) / 1.5,
        height: (MediaQuery.of(context).size.height * 0.55),
        child: ImageLoaderCard(
          url: url,
          boxFit: BoxFit.cover,
        ),
      ),
    );
  }
  return widgets;
}

List<Widget> createMobileImagesFromList(List<String> urls, context) {
  // Crear una lista de widgets basada en la lista de strings
  List<Widget> widgets = [];

  for (String url in urls) {
    widgets.add(
      // Puedes personalizar el widget según tus necesidades
      SizedBox(
        width: (MediaQuery.of(context).size.height * 0.18),
        height: (MediaQuery.of(context).size.height * 0.18),
        child: ImageLoaderCard(
          url: url,
          boxFit: BoxFit.contain,
        ),
      ),
    );
  }
  return widgets;
}

class ImageLoaderCard extends StatelessWidget {
  const ImageLoaderCard({
    super.key,
    required this.url,
    required this.boxFit,
  });

  final String url;
  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: waitForImage(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras se obtiene la imagen.
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (snapshot.hasError || snapshot.data == "") {
          // Maneja el error si ocurre.
          return Center(
              child: Column(
            children: [
              Text("Error during generation"),
              SizedBox(height: 5),
              const Icon(Icons.error),
            ],
          ));
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
                    fit: boxFit,
                    image: NetworkImage(
                      url,
                    ),
                  )),
            ),
          );
        }
      },
    );
  }
}

Future<String> waitForImage(String url) async {
  var response = await http.get(Uri.parse(url));
  var counter = 0;
  if (response.statusCode != 200) {
    while (true) {
      if (counter == 50) {
        return "";
      }
      await Future.delayed(const Duration(seconds: 5));
      response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        break;
      } else {
        counter++;
      }
    }
  }
  return url;
}
