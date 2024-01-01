import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_ai/features/common/utils/error_utils.dart';
import 'package:photo_ai/features/text_to_image/domain/entities/text_to_image_request.dart';
import 'package:photo_ai/features/text_to_image/infraestructure/text_to_image_service.dart';
import 'package:photo_ai/features/text_to_image/photo_providers.dart';

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
  var _isButtonDisabled = false;

  TextToImageRequest request = TextToImageRequest();
  TextToImageServiceImpl textToImageService = TextToImageServiceImpl();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(featureNotifierProvider);
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
                      Divider(height: 50.0),
                      Text('Samples'),
                      Slider(
                        value: double.parse(request.samples),
                        max: 4,
                        min: 1,
                        divisions: 3,
                        label: request.samples,
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
                      SizedBox(height: 16.0),
                      Text('Steps'),
                      Slider(
                        value: double.parse(request.numInferenceSteps),
                        max: 50,
                        min: 5,
                        divisions: 9,
                        label: request.numInferenceSteps,
                        onChanged: (double value) {
                          setState(() {
                            request.numInferenceSteps = value.toString();
                          });
                        },
                      ),
                      Center(
                        child: Text(
                          '${request.numInferenceSteps}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text('Guidiance Scale'),
                      Slider(
                        value: request.guidanceScale,
                        max: 30,
                        min: 1,
                        label: request.guidanceScale.toString(),
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
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text('Seed'),
                      Slider(
                        value: request.seed == null
                            ? 0.0
                            : request.seed!.toDouble(),
                        max: 99999,
                        label: request.numInferenceSteps,
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
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      SizedBox(height: 16.0),
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
              onPressed: _isButtonDisabled
                  ? null
                  : () {
                      setState(() {
                        _isButtonDisabled = true; // Desactiva el botón
                      });
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            showSnackBarCustomMessage(context, "Processing"));

                        request.prompt = promptController.text;
                        request.negativePrompt += promptController.text;

                        textToImageService.textToImage(request).then((value) {
                          ref
                              .read(textToImageNotifierProvider.notifier)
                              .updateValue(value);
                          if (value.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(showSnackBarError(context));
                          }
                        });
                        handleResponse(context, ref);
                      }
                      setState(() {
                        _isButtonDisabled = false; // Vuelve a activar el botón
                      });
                    },
              child: Text('Generate'),
            ),
          ),
        ],
      ),
    );
  }

  void handleResponse(BuildContext context, WidgetRef ref) {
    switch (4) {
      case 1:
        //text to image
        break;
      case 2:
        //image to image
        break;
      case 3:
        //inpaint image
        break;
    }
  }
}
