import 'package:flutter/material.dart';
import 'package:photo_ai/features/common/widgets/image_card.dart';

class ImageDetailedScreen extends StatelessWidget {
  final String imageUrl;

  const ImageDetailedScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ImageCard(imageUrl: imageUrl, proportion: 0.5),
      appBar: AppBar(),
    );
  }
}
