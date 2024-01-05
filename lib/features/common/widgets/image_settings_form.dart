import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimage/features/auth/auth_provider.dart';
import 'package:aimage/features/auth/utils/modal_utils.dart';
import 'package:aimage/features/common/domain/inpainting_state.dart';
import 'package:aimage/features/common/utils/error_utils.dart';
import 'package:aimage/features/image_to_image/domain/entities/image_to_image_request.dart';
import 'package:aimage/features/image_to_image/infraestructure/image_to_image_service.dart';
import 'package:aimage/features/inpainting/domain/entities/drawing_point.dart';
import 'package:aimage/features/inpainting/domain/entities/inpainting_request.dart';
import 'package:aimage/features/inpainting/domain/entities/mask_painter.dart';
import 'package:aimage/features/inpainting/infraestructure/inpainting_service.dart';
import 'package:aimage/features/text_to_image/domain/entities/text_to_image_request.dart';
import 'package:aimage/features/text_to_image/infraestructure/text_to_image_service.dart';
import 'package:aimage/features/text_to_image/photo_providers.dart';
import 'package:aimage/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageSettingsForm extends StatelessWidget {
  const ImageSettingsForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(child: SettingsForm()),
          ],
        ),
      ),
    );
  }
}

class SettingsForm extends ConsumerStatefulWidget {
  const SettingsForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SettingsFormState();
}

class SettingsFormState extends ConsumerState<SettingsForm> {
  final TextEditingController promptController = TextEditingController();
  final TextEditingController negativePromptController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var strength = 0.7;

  TextToImageRequest request = TextToImageRequest();
  TextToImageServiceImpl textToImageService = TextToImageServiceImpl();
  ImageToImageServiceImpl imageToImageService = ImageToImageServiceImpl();
  InpaintingServiceImpl inpaintingService = InpaintingServiceImpl();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tab = ref.watch(featureNotifierProvider);
    bool isLoading = ref.watch(spinnerNotifierProvider);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: promptController,
                        maxLines: null, // Permite múltiples líneas
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          labelText: 'Prompt',
                          hintText: 'Ingrese su prompt aquí...',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid prompt';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: negativePromptController,
                        maxLines: null, // Permite múltiples líneas
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          labelText: 'Negative Prompt',
                          hintText: 'Ingrese su negative prompt aquí...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Divider(height: 50.0),
                      const Text('Samples'),
                      Slider(
                        value: double.parse(request.samples),
                        max: 4,
                        min: 1,
                        divisions: 3,
                        onChanged: (double value) {
                          setState(() {
                            request.samples = value.toString();
                          });
                        },
                      ),
                      Center(
                        child: Text(
                          request.samples,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text('Steps'),
                      Slider(
                        value: double.parse(request.numInferenceSteps),
                        max: 50,
                        min: 5,
                        divisions: 9,
                        onChanged: (double value) {
                          setState(() {
                            request.numInferenceSteps = value.toString();
                          });
                        },
                      ),
                      Center(
                        child: Text(
                          request.numInferenceSteps,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      if (tab == 2)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16.0),
                            const Text('Strength'),
                            Slider(
                              value: strength,
                              max: 1,
                              min: 0,
                              divisions: 10,
                              onChanged: (double value) {
                                setState(() {
                                  strength = value;
                                });
                              },
                            ),
                            Center(
                              child: Text(
                                '$strength',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16.0),
                      const Text('Guidiance Scale'),
                      Slider(
                        value: request.guidanceScale,
                        max: 30,
                        min: 1,
                        onChanged: (double value) {
                          setState(() {
                            request.guidanceScale =
                                ((value * 2).roundToDouble() / 2);
                          });
                        },
                      ),
                      Center(
                        child: Text(
                          '${request.guidanceScale}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text('Seed'),
                      Slider(
                        value: request.seed == null
                            ? 0.0
                            : request.seed!.toDouble(),
                        max: 99999,
                        onChanged: (double value) {
                          setState(() {
                            if (value == 0.0) {
                              request.seed = null;
                            } else {
                              request.seed = value.toInt();
                            }
                          });
                        },
                      ),
                      Center(
                        child: Text(
                          request.seed == null ? '0' : '${request.seed}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 14),
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        request.prompt = promptController.text;
                        request.negativePrompt += promptController.text;

                        if (ref.read(authNotifierProvider) == null) {
                          showLoginDialog(context);
                        } else {
                          generateImage(context, ref, tab);
                        }
                      }
                    },
              child: const Text('Generate'),
            ),
          ),
        ],
      ),
    );
  }

  void generateImage(BuildContext context, WidgetRef ref, int tab) {
    switch (tab) {
      case 0:
        //text to image
        ref.read(spinnerNotifierProvider.notifier).updateValue(true);
        textToImageService
            .textToImage(request)
            .then((value) {
              ref.read(textToImageNotifierProvider.notifier).updateValue(value);
              if (value.isEmpty) {
                showGenericError(context);
              }
            })
            .catchError((onError) => showErrorCustom(context, "Error cr"))
            .whenComplete(() =>
                ref.read(spinnerNotifierProvider.notifier).updateValue(false));

        break;
      case 1:
        var selectedUrl = ref.read(selectedImageNotifierProvider);

        if (selectedUrl != null) {
          ref.read(spinnerNotifierProvider.notifier).updateValue(true);
          imageToImageService
              .imageToImage(ImageToImageRequest()
                  .convertToImageToImageRequest(request, selectedUrl))
              .then((value) {
                ref
                    .read(imageToImageNotifierProvider.notifier)
                    .updateValue(value);
                if (value.isEmpty) {
                  showGenericError(context);
                }
              })
              .catchError((onError) => showErrorCustom(context, "Error cr"))
              .whenComplete(() => ref
                  .read(spinnerNotifierProvider.notifier)
                  .updateValue(false));
        } else {
          showErrorCustom(context, "select any photo to edit");
        }

        break;
      case 2:
        //inpaint image
        var settings = ref.read(inpaintingImageNotifierProvider);
        var selectedUrl = ref.read(selectedImageNotifierProvider);

        if (selectedUrl == null) {
          showErrorCustom(context, "Select and draw a mask");
          break;
        }

        if (settings.drawingPoints != null &&
            settings.drawingPoints!.isNotEmpty) {
          ref.read(spinnerNotifierProvider.notifier).updateValue(true);

          ref.read(selectedImageNotifierProvider.notifier).reset();

          _saveDrawing(settings).then((maskUrl) {
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
            inpaintingService.inpaint(inpaintRequest).then((value) {
              ref
                  .read(inpaintingImageNotifierProvider.notifier)
                  .updateValue(InpaintingState(generatedImages: value));

              if (value.isEmpty) {
                showGenericError(context);
              }
            });
          }).catchError((error) {
            showErrorCustom(context, error.message);
          }).whenComplete(() =>
              ref.read(spinnerNotifierProvider.notifier).updateValue(false));
        } else {
          showErrorCustom(context, "It is necessary to draw a mask");
        }

        break;
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

      await supabase.storage.from('mask').uploadBinary(
            'public/userid.png',
            uint8List!,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      final String url =
          await supabase.storage.from('mask').getPublicUrl('public/userid.png');

      return url;

      // setState(() {
      //   drawingPoints.clear();
      // });
    } catch (e) {
      throw Exception("Error processing the mask");
    }
  }
}
