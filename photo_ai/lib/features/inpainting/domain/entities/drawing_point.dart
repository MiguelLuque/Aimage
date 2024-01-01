import 'dart:ui';

class DrawingPoint {
  Offset offset;
  Paint paint;
  bool ignore;

  DrawingPoint(this.offset, this.paint, [this.ignore = false]);

  // Constructor de copia
  DrawingPoint.copy(DrawingPoint other)
      : offset = Offset(other.offset.dx, other.offset.dy),
        paint = Paint()
          ..color = other.paint.color
          ..isAntiAlias = other.paint.isAntiAlias
          ..strokeWidth = other.paint.strokeWidth
          ..strokeCap = other.paint.strokeCap,
        // Copia de la pintura
        ignore = other.ignore;
}
