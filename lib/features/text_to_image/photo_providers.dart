//riverpod provider flutter

import 'package:aimage/features/common/utils/error_utils.dart';
import 'package:aimage/features/image_to_image/domain/entities/image_to_image_request.dart';
import 'package:aimage/features/image_to_image/infraestructure/image_to_image_service.dart';
import 'package:aimage/features/inpainting/application/inpainting_service.dart';
import 'package:aimage/features/text_to_image/application/text_to_image_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimage/features/common/domain/inpainting_state.dart';
import 'package:aimage/features/text_to_image/domain/entities/text_to_image_request.dart';

//texto to image controller
final settingsFormNotifierProvider =
    NotifierProvider<TextToImageFormNotifier, TextToImageRequest>(
  TextToImageFormNotifier.new,
);

class TextToImageFormNotifier extends Notifier<TextToImageRequest> {
  @override
  TextToImageRequest build() => TextToImageRequest();

  void updateValue(TextToImageRequest value) {
    state = value;
  }

  void reset() {
    state = TextToImageRequest();
  }
}

//Feature controller
final featureNotifierProvider = NotifierProvider<FeatureNotifier, int>(
  FeatureNotifier.new,
);

// Controller o Notifier
class FeatureNotifier extends Notifier<int> {
  @override
  int build() => 0;

  TextToImageServiceImpl textToImageService = TextToImageServiceImpl();
  ImageToImageServiceImpl imageToImageService = ImageToImageServiceImpl();
  InpaintingServiceImpl inpaintingService = InpaintingServiceImpl();

  void updateValue(int value) {
    state = value;
  }

  void reset() {
    state = 0;
  }

  Future<void> generateImage(
      BuildContext context, TextToImageRequest request, double strength) async {
    switch (state) {
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
            .catchError(
                (onError) => showErrorCustom(context, "Error creating image"))
            .whenComplete(() =>
                ref.read(spinnerNotifierProvider.notifier).updateValue(false));

        break;
      case 1:
        var selectedUrl = ref.read(selectedImageNotifierProvider);

        if (selectedUrl != null) {
          ref.read(spinnerNotifierProvider.notifier).updateValue(true);
          await imageToImageService
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
        // inpaint image
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

          inpaintingService
              .inpaint(request, settings, selectedUrl, strength)
              .then((value) {
            ref
                .read(inpaintingImageNotifierProvider.notifier)
                .updateValue(InpaintingState(generatedImages: value));

            if (value.isEmpty) {
              showGenericError(context);
            }
          }).catchError((error) {
            showErrorCustom(context, error.message);
          }).whenComplete(() => ref
                  .read(spinnerNotifierProvider.notifier)
                  .updateValue(false));
        } else {
          showErrorCustom(context, "It is necessary to draw a mask");
        }

        break;
    }
  }
}

//Text to image generated list controller
final textToImageNotifierProvider =
    NotifierProvider<TextToImageNotifier, List<String>>(
  TextToImageNotifier.new,
);

class TextToImageNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => [];

  void updateValue(List<String> value) {
    state = value;
  }

  void reset() {
    state = List.empty();
  }
}

//Text to image generated list controller
final imageToImageNotifierProvider =
    NotifierProvider<ImageToImageNotifier, List<String>>(
  ImageToImageNotifier.new,
);

class ImageToImageNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => [];

  void updateValue(List<String> value) {
    state = value;
  }

  void reset() {
    state = List.empty();
  }
}

//Control if there is any process and the app must show a spinner
final spinnerNotifierProvider = NotifierProvider<SpinnerNotifier, bool>(
  SpinnerNotifier.new,
);

class SpinnerNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void updateValue(bool value) {
    state = value;
  }

  void reset() {
    state = false;
  }
}

//Control app settings and preferences
final appSettingsNotifierProvider = NotifierProvider<AppSettingsNotifier, bool>(
  AppSettingsNotifier.new,
);

class AppSettingsNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void updateValue(bool value) {
    state = value;
  }

  void reset() {
    state = false;
  }
}

//Inpainting generated list controller
final inpaintingImageNotifierProvider =
    NotifierProvider<InpaintingImageNotifier, InpaintingState>(
  InpaintingImageNotifier.new,
);

class InpaintingImageNotifier extends Notifier<InpaintingState> {
  @override
  InpaintingState build() => InpaintingState();

  void updateValue(InpaintingState value) {
    state = state.copyWith(value);
  }

  void reset() {
    state = InpaintingState(generatedImages: state.generatedImages);
  }
}

//Selected image controller
final selectedImageNotifierProvider =
    NotifierProvider<SelectedImageNotifier, String?>(
  SelectedImageNotifier.new,
);

class SelectedImageNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void updateSelectedImage(String? value) {
    state = value;
  }

  void updateEditedImage(String? value) {
    state = value;
  }

  void reset() {
    state = null;
  }
}
