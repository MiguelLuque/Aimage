import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_ai/features/common/domain/inpainting_state.dart';
import 'package:photo_ai/features/inpainting/application/utils/inpainting_utils.dart';
import 'package:photo_ai/features/inpainting/domain/entities/drawing_point.dart';
import 'package:photo_ai/features/common/screens/empty_editing_screen.dart';
import 'package:photo_ai/features/text_to_image/photo_providers.dart';

import '../../domain/entities/drawing_painter.dart';

class InpaintingScreen extends ConsumerStatefulWidget {
  const InpaintingScreen({super.key});

  @override
  InpaintingScreenState createState() => InpaintingScreenState();
}

class InpaintingScreenState extends ConsumerState<InpaintingScreen> {
  Color selectedColor = Colors.black;
  double strokeWidth = 20;
  List<DrawingPoint> drawingPoints = [];
  String? imageUrlSelected;

  BoxConstraints? imageConstranints;
  List<Color> colors = [
    Colors.black,
    Colors.white,
  ];

  bool keepPainted = false;

  @override
  Widget build(BuildContext context) {
    imageUrlSelected = ref.watch(selectedImageNotifierProvider);

    return imageUrlSelected == null
        ? EmptyEditingScreen()
        : FutureBuilder<Size>(
            future: calculateImageDimension(imageUrlSelected),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: _buildEditionTools(snapshot.data!.height,
                            snapshot.data!.width, imageConstranints),
                      ),
                      SizedBox(height: 15),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio:
                              snapshot.data!.width / snapshot.data!.height,
                          child:
                              LayoutBuilder(builder: (context, boxConstraints) {
                            // if (imageConstranints != null &&
                            //     drawingPoints.isNotEmpty) {
                            //   drawingPoints = _scalePoints(
                            //       List.of(drawingPoints),
                            //       imageConstranints!.maxHeight /
                            //           boxConstraints.maxHeight,
                            //       false);
                            // }

                            _onConstraintsChanged(boxConstraints);

                            return GestureDetector(
                              onPanStart: (details) {
                                if (isPointWithinImage(
                                    details.localPosition, boxConstraints)) {
                                  setState(() {
                                    drawingPoints.add(
                                      DrawingPoint(
                                        details.localPosition,
                                        Paint()
                                          ..color = selectedColor
                                          ..isAntiAlias = true
                                          ..strokeWidth = strokeWidth
                                          ..strokeCap = StrokeCap.round,
                                      ),
                                    );
                                  });
                                }
                              },
                              onPanUpdate: (details) {
                                setState(() {
                                  if (isPointWithinImage(
                                      details.localPosition, boxConstraints)) {
                                    drawingPoints.add(
                                      DrawingPoint(
                                        details.localPosition,
                                        Paint()
                                          ..color = selectedColor
                                          ..isAntiAlias = true
                                          ..strokeWidth = strokeWidth
                                          ..strokeCap = StrokeCap.round,
                                      ),
                                    );
                                  }
                                });
                              },
                              onPanEnd: (details) {
                                setState(() {
                                  drawingPoints.add(DrawingPoint(
                                      Offset(0, 0), Paint(), true));

                                  // actualizamos la info del provider con la lista de puntos, y las constraints asi como el tamaño de la imagen original
                                  ref
                                      .read(inpaintingImageNotifierProvider
                                          .notifier)
                                      .updateValue(InpaintingState(
                                          keepPainted: keepPainted,
                                          drawingPoints: drawingPoints,
                                          constraints: boxConstraints,
                                          width: snapshot.data!.width,
                                          height: snapshot.data!.height));
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              NetworkImage(imageUrlSelected!),
                                          fit: BoxFit.contain)),
                                  child: CustomPaint(
                                    painter: DrawingPainter(drawingPoints),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  )),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text('Loading...')),
                    CircularProgressIndicator()
                  ],
                );
              }
            });
  }

  _onConstraintsChanged(constraints) {
    // Recibe las BoxConstraints del widget hijo
    imageConstranints = constraints;
  }

  List<Widget> _buildEditionTools(
      double height, double width, BoxConstraints? constraints) {
    List<Widget> res = [
      Slider(
        min: 20,
        max: 60,
        value: strokeWidth,
        onChanged: (val) => setState(() => strokeWidth = val),
      ),
      const SizedBox(width: 5),
      ElevatedButton.icon(
        onPressed: () => setState(() {
          drawingPoints = [];
          ref
              .read(inpaintingImageNotifierProvider.notifier)
              .updateValue(InpaintingState(
                keepPainted: keepPainted,
                drawingPoints: drawingPoints,
              ));
        }),
        icon: Icon(Icons.clear),
        label: Text("Clear Board"),
      ),
      const SizedBox(width: 5),
      ElevatedButton.icon(
        onPressed: () => setState(() {
          drawingPoints = [];
          ref.read(selectedImageNotifierProvider.notifier).resetAll();
          ref.read(inpaintingImageNotifierProvider.notifier).reset();
        }),
        icon: Icon(Icons.image_search_outlined),
        label: Text("Change Image"),
      ),
      const Spacer(),
      Text(
        "Keep Painted",
        style: TextStyle(color: Theme.of(context).hintColor),
      ),
      const SizedBox(width: 5),
      Switch(
        // This bool value toggles the switch.
        value: keepPainted,
        onChanged: (bool value) {
          // This is called when the user toggles the switch.
          setState(() {
            keepPainted = value;
            ref
                .read(inpaintingImageNotifierProvider.notifier)
                .updateValue(InpaintingState(
                  keepPainted: keepPainted,
                ));
          });
        },
      ),
    ];
    for (var color in colors) {
      res.insert(0, _buildColorChose(color));
    }
    res.insert(1, SizedBox(width: 15));
    return res;
  }

  Widget _buildColorChose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        height: isSelected ? 47 : 40,
        width: isSelected ? 47 : 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
      ),
    );
  }

//TODO remover esto
  // List<DrawingPoint> _scalePoints(
  //     List<DrawingPoint> points, double scaleFactor, bool keepPainted) {
  //   return points.map((point) {
  //     var res = DrawingPoint.copy(point);
  //     res.offset = res.offset.scale(scaleFactor, scaleFactor);
  //     if (keepPainted) {
  //       res.paint.color = Colors.white;
  //     } else {
  //       res.paint.color = Colors.black;
  //     }
  //     return res;
  //   }).toList();
  // }

  // Future<void> _saveDrawing(
  //     double height, double width, BoxConstraints? constraints) async {
  //   isLoading = true;
  //   try {
  //     ui.PictureRecorder recorder = ui.PictureRecorder();
  //     final canvas = Canvas(recorder);
  //     final Size size = Size(width, height);
  //     List<DrawingPoint> points = _scalePoints(
  //         List.of(drawingPoints), height / constraints!.maxHeight, true);

  //     final paint = MaskPainter(points, true);
  //     paint.paint(canvas, size);

  //     final picture = recorder.endRecording();
  //     final mask = await picture.toImage(
  //       size.width.toInt(),
  //       size.height.toInt(),
  //     );

  //     final byteData = await mask.toByteData(format: ui.ImageByteFormat.png);
  //     final uint8List = byteData?.buffer.asUint8List();

  //     final String path = await supabase.storage.from('mask').uploadBinary(
  //           'public/userid.png',
  //           uint8List!,
  //           fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
  //         );

  //     // final String url = await supabase.storage.from('bucket').getPublicUrl(
  //     //     'public/userid.png',
  //     //     transform: TransformOptions(width: 512, height: 768));

  //     setState(() {
  //       drawingPoints.clear();
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
