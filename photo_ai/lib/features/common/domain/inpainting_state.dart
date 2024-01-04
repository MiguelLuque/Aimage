import 'package:flutter/material.dart';
import 'package:photo_ai/features/inpainting/domain/entities/drawing_point.dart';

class InpaintingState {
  String? imageSelected;
  List<String>? generatedImages;
  BoxConstraints? constraints;
  double? height;
  double? width;
  List<DrawingPoint>? drawingPoints;
  bool keepPainted;

  InpaintingState({
    this.imageSelected,
    this.generatedImages = const [],
    this.constraints,
    this.height,
    this.width,
    this.drawingPoints,
    this.keepPainted = false,
  });

  InpaintingState copyWith(InpaintingState state) {
    return InpaintingState(
      imageSelected: state.imageSelected ?? imageSelected,
      generatedImages: state.generatedImages ?? generatedImages,
      constraints: state.constraints ?? constraints,
      height: state.height ?? height,
      width: state.width ?? width,
      keepPainted: state.keepPainted,
      drawingPoints: state.drawingPoints ?? drawingPoints,
    );
  }

  @override
  String toString() {
    return 'InpaintingState{'
        'imageSelected: $imageSelected, '
        'generatedImages: $generatedImages, '
        'constraints: $constraints, '
        'keepPainted: $keepPainted, '
        'height: $height, '
        'width: $width, '
        'drawingPoints: $drawingPoints}';
  }
}
