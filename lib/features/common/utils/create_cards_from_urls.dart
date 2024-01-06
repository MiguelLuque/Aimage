import 'package:aimage/features/common/utils/create_images_from_urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<Widget> createCardsFromList(List<String> urls, context, Function f) {
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
                  setState() {
                    urls.indexOf(url);
                  }
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
