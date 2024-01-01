import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_ai/features/inpainting/domain/entities/drawing_point.dart';
import 'dart:ui' as ui;

class MaskPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;
  final bool usePaint;

  MaskPainter(this.drawingPoints, this.usePaint);

  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) {
    var color = usePaint ? Colors.black : Colors.white;
    canvas.drawRect(
        Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)),
        Paint()..color = color);

    try {
      for (int i = 0; i < drawingPoints.length - 1; i++) {
        if (!drawingPoints[i].ignore && !drawingPoints[i + 1].ignore) {
          canvas.drawLine(drawingPoints[i].offset, drawingPoints[i + 1]!.offset,
              drawingPoints[i].paint);
        } else if (drawingPoints[i + 1].ignore) {
          offsetsList.clear();
          offsetsList.add(drawingPoints[i].offset);

          canvas.drawPoints(
              ui.PointMode.points, offsetsList, drawingPoints[i].paint);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('El error es: $e');
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
