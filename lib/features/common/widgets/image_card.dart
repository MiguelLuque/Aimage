import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final double proportion;

  const ImageCard(
      {super.key, required this.imageUrl, required this.proportion});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: (MediaQuery.of(context).size.height * 0.8) / 1.5,
        height: (MediaQuery.of(context).size.height * 0.8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                imageUrl,
              ),
            )),
      ),
    );
  }
}
