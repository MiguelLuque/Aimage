import 'package:aimage/features/common/domain/inpainting_state.dart';
import 'package:aimage/features/inpainting/domain/entities/drawing_point.dart';
import 'package:aimage/features/inpainting/domain/entities/mask_painter.dart';
import 'package:aimage/features/inpainting/repositories/inpainting_repository.dart';
import 'package:aimage/features/inpainting/domain/entities/inpainting_request.dart';
import 'package:aimage/features/text_to_image/domain/entities/text_to_image_request.dart';
import 'package:aimage/main.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InpaintingServiceImpl {
  InpaintingRepository inpaintingRepository = InpaintingRepository();

  Future<List<String>> inpaint(TextToImageRequest request,
      InpaintingState settings, String selectedUrl, double strength) async {
    try {
      List<String> res = [];

      await _saveDrawing(settings).then((maskUrl) {
        InpaintingRequest inpaintRequest = InpaintingRequest(
            initImage: selectedUrl,
            maskImage: maskUrl,
            prompt: request.prompt,
            negativePrompt: request.negativePrompt,
            samples: request.samples,
            steps: request.numInferenceSteps,
            strength: strength,
            guidanceScale: request.guidanceScale,
            width: settings.width.toString(),
            height: settings.height.toString(),
            seed: request.seed);
        inpaintingRepository
            .inpaint(inpaintRequest)
            .then((value) => res = value);
      });

      return res;
    } catch (e) {
      return List.empty();
    }
  }

  List<DrawingPoint> _scalePoints(
      List<DrawingPoint> points, double scaleFactor, bool keepPainted) {
    return points.map((point) {
      var res = DrawingPoint.copy(point);
      res.offset = res.offset.scale(scaleFactor, scaleFactor);
      if (keepPainted) {
        res.paint.color = Colors.white;
      } else {
        res.paint.color = Colors.black;
      }
      return res;
    }).toList();
  }

  Future<String> _saveDrawing(InpaintingState settings) async {
    try {
      ui.PictureRecorder recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final Size size = Size(settings.width!, settings.height!);
      List<DrawingPoint> points = _scalePoints(List.of(settings.drawingPoints!),
          settings.height! / settings.constraints!.maxHeight, true);

      final paint = MaskPainter(points, true);
      paint.paint(canvas, size);

      final picture = recorder.endRecording();
      final mask = await picture.toImage(
        size.width.toInt(),
        size.height.toInt(),
      );

      final byteData = await mask.toByteData(format: ui.ImageByteFormat.png);
      final uint8List = byteData?.buffer.asUint8List();

      var folderName = supabase.auth.currentUser!.id;

      await supabase.storage.from('mask').uploadBinary(
            '$folderName/mask.png',
            uint8List!,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      final String url = await supabase.storage
          .from('mask')
          .getPublicUrl('$folderName/mask.png');

      return url;

      // setState(() {
      //   drawingPoints.clear();
      // });
    } catch (e) {
      throw Exception("Error processing the mask");
    }
  }
}
