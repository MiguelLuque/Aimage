import 'package:flutter/material.dart';

class ImageDetailedScreen extends StatelessWidget {
  final String imageUrl;

  const ImageDetailedScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: (MediaQuery.of(context).size.height * 0.8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                fit: BoxFit.contain,
                image: NetworkImage(
                  imageUrl,
                ),
              )),
        ),
      ),
      appBar: AppBar(),
    );
  }
}
