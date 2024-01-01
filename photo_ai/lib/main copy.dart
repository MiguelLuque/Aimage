import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  //usePathUrlStrategy();
  await Supabase.initialize(
    url: 'https://udzdbvgsihsprvsfbclr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVkemRidmdzaWhzcHJ2c2ZiY2xyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODMwNDE3MzksImV4cCI6MTk5ODYxNzczOX0.vRUE_eBsWNnI8jz-E7naOIad1ZYsuKDMfbhMRqfnsRM',
  );
  runApp(const ProviderScope(child: MyApp()));
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DrawingBoard(),
    );
  }
}

class DrawingBoard extends StatefulWidget {
  @override
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  Color selectedColor = Colors.black;
  final GlobalKey widgetKey = GlobalKey();
  double strokeWidth = 5;
  List<DrawingPoint?> drawingPoints = [];
  Image? imageTest = null;
  List<Color> colors = [
    const Color.fromRGBO(0, 0, 0, 1),
    Color.fromARGB(255, 161, 101, 216),
  ];

  Future<void> _saveDrawing() async {
    try {
      ui.PictureRecorder recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final Size size = Size.square(500);
      final paint = _DrawingPainter(drawingPoints);
      paint.paint(canvas, size);

      final picture = recorder.endRecording();
      final img = await picture.toImage(
        size.width.toInt(),
        size.height.toInt(),
      );

      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final uint8List = byteData?.buffer.asUint8List();

      var image = Image.memory(uint8List!);

      final String path = await supabase.storage
          .from('announcement')
          .uploadBinary(
            'public/avatar2.png',
            uint8List,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      this.setState(() {
        imageTest = image;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: imageTest ??
            Stack(
              children: [
                GestureDetector(
                  onPanStart: (details) {
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
                  },
                  onPanUpdate: (details) {
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
                  },
                  onPanEnd: (details) {
                    setState(() {
                      drawingPoints.add(null);
                    });
                  },
                  child: Container(
                    height: 500,
                    width: 500,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://raw.githubusercontent.com/CompVis/stable-diffusion/main/data/inpainting_examples/overture-creations-5sI6fQgYIuo.png'),
                            fit: BoxFit.fill)),
                    child: CustomPaint(
                      painter: _DrawingPainter(drawingPoints),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 30,
                  child: Row(
                    children: [
                      Slider(
                        min: 0,
                        max: 40,
                        value: strokeWidth,
                        onChanged: (val) => setState(() => strokeWidth = val),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _saveDrawing(),
                        icon: const Icon(Icons.save),
                        label: Text("Save"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => setState(() => drawingPoints = []),
                        icon: Icon(Icons.clear),
                        label: Text("Clear Board"),
                      )
                    ],
                  ),
                ),
              ],
            ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.grey[200],
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              colors.length,
              (index) => _buildColorChose(colors[index]),
            ),
          ),
        ),
      ),
    );
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
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;

  _DrawingPainter(this.drawingPoints);

  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) {
    try {
      for (int i = 0; i < drawingPoints.length - 1; i++) {
        if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
          canvas.drawLine(drawingPoints[i]!.offset,
              drawingPoints[i + 1]!.offset, drawingPoints[i]!.paint);
        } else if (drawingPoints[i + 1] == null) {
          offsetsList.clear();
          offsetsList.add(drawingPoints[i]!.offset);

          canvas.drawPoints(
              ui.PointMode.points, offsetsList, drawingPoints[i]!.paint);
        }
      }
    } catch (e) {
      print('El error es: $e');
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}
