import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
  double strokeWidth = 5;
  List<DrawingPoint?> drawingPoints = [];
  List<Color> colors = [
    const Color.fromRGBO(0, 0, 0, 1),
    Color.fromARGB(255, 161, 101, 216),
  ];

  // Future<void> _saveDrawing() async {
  //   ui.PictureRecorder recorder = ui.PictureRecorder();
  //   final canvas = Canvas(recorder);
  //   final size = context.size!;
  //   final paint = _DrawingPainter(this.drawingPoints);

  //   paint.paint(canvas, size);

  //   final picture = recorder.endRecording();
  //   final img = await picture.toImage(
  //     size.width.toInt(),
  //     size.height.toInt(),
  //   );

  //   final ByteData? byteData =
  //       await img.toByteData(format: ui.ImageByteFormat.png);
  //   final Uint8List? uint8List = byteData?.buffer.asUint8List();

  //   // Guarda los bytes en un archivo (puedes ajustar la ubicación según tus necesidades)
  //   final File file = File('ruta/de/destino/pintura.png');
  //   await file.writeAsBytes(uint8List!);

  //   print('Pintura guardada en: ${file.path}');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage('https://picsum.photos/250?image=9'),
                fit: BoxFit.fill)),
        child: Stack(
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
              child: CustomPaint(
                painter: _DrawingPainter(drawingPoints),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  // decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image:
                  //             NetworkImage('https://picsum.photos/250?image=9'),
                  //         fit: BoxFit.fitHeight)),
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
              PointMode.points, offsetsList, drawingPoints[i]!.paint);
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
