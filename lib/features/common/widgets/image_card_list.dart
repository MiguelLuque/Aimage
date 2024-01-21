import 'package:aimage/features/common/utils/create_images_from_urls.dart';
import 'package:flutter/material.dart';

class ImageCardList extends StatelessWidget {
  const ImageCardList({
    super.key,
    required this.imageUrls,
  });

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Wrap(
          spacing: 15.0, // Espaciado entre los widgets
          runSpacing: 15.0, // Espaciado entre las filas de widgets
          children: createImagesFromList(imageUrls, context),
        ),
      ),
    );
  }
}
