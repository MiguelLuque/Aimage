import 'package:flutter/material.dart';
import 'package:photo_ai/features/inpainting/domain/entities/drawing_painter.dart';
import 'package:photo_ai/features/inpainting/domain/entities/drawing_point.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    super.key,
    required this.imageUrlSelected,
    required this.drawingPoints,
  });

  final String? imageUrlSelected;
  final List<DrawingPoint> drawingPoints;

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: snapshot.data!.height,
      //width: snapshot.data!.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(imageUrlSelected!), fit: BoxFit.fitHeight)),
      child: CustomPaint(
        painter: DrawingPainter(drawingPoints),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
