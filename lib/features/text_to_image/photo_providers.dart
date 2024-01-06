//riverpod provider flutter

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimage/features/common/domain/inpainting_state.dart';
import 'package:aimage/features/text_to_image/domain/entities/text_to_image_request.dart';

//texto to image controller
final settingsFormNotifierProvider =
    StateNotifierProvider<TextToImageFormNotifier, TextToImageRequest>(
  (ref) => TextToImageFormNotifier(),
);

class TextToImageFormNotifier extends StateNotifier<TextToImageRequest> {
  TextToImageFormNotifier() : super(TextToImageRequest());

  void updateValue(TextToImageRequest value) {
    state = value;
  }

  void reset() {
    state = TextToImageRequest();
  }
}

//Feature controller
final featureNotifierProvider = StateNotifierProvider<FeatureNotifier, int>(
  (ref) => FeatureNotifier(),
);

// Controller o Notifier
class FeatureNotifier extends StateNotifier<int> {
  FeatureNotifier() : super(0);

  void updateValue(int value) {
    state = value;
  }

  void reset() {
    state = 0;
  }
}

//Text to image generated list controller
final textToImageNotifierProvider =
    StateNotifierProvider<TextToImageNotifier, List<String>>(
  (ref) => TextToImageNotifier(),
);

class TextToImageNotifier extends StateNotifier<List<String>> {
  TextToImageNotifier()
      : super([
          "https://pub-3626123a908346a7a8be8d9295f44e26.r2.dev/generations/0-4013990b-25af-45f9-acba-28b44185be9e.png",
          "https://pub-3626123a908346a7a8be8d9295f44e26.r2.dev/generations/0-4013990b-25af-45f9-acba-28b44185be9e.png"
        ]);

  void updateValue(List<String> value) {
    state = value;
  }

  void reset() {
    state = List.empty();
  }
}

//Text to image generated list controller
final imageToImageNotifierProvider =
    StateNotifierProvider<ImageToImageNotifier, List<String>>(
  (ref) => ImageToImageNotifier(),
);

class ImageToImageNotifier extends StateNotifier<List<String>> {
  ImageToImageNotifier() : super([]);

  void updateValue(List<String> value) {
    state = value;
  }

  void reset() {
    state = List.empty();
  }
}

//Control if there is any process and the app must show a spinner
final spinnerNotifierProvider = StateNotifierProvider<SpinnerNotifier, bool>(
  (ref) => SpinnerNotifier(),
);

class SpinnerNotifier extends StateNotifier<bool> {
  SpinnerNotifier() : super(false);

  void updateValue(bool value) {
    state = value;
  }

  void reset() {
    state = false;
  }
}

//Control app settings and preferences
final appSettingsNotifierProvider =
    StateNotifierProvider<AppSettingsNotifier, bool>(
  (ref) => AppSettingsNotifier(),
);

class AppSettingsNotifier extends StateNotifier<bool> {
  AppSettingsNotifier() : super(false);

  void updateValue(bool value) {
    state = value;
  }

  void reset() {
    state = false;
  }
}

//Inpainting generated list controller
final inpaintingImageNotifierProvider =
    StateNotifierProvider<InpaintingImageNotifier, InpaintingState>(
  (ref) => InpaintingImageNotifier(),
);

class InpaintingImageNotifier extends StateNotifier<InpaintingState> {
  InpaintingImageNotifier() : super(InpaintingState());

  void updateValue(InpaintingState value) {
    state = state.copyWith(value);
  }

  void reset() {
    state = InpaintingState(generatedImages: state.generatedImages);
  }
}

//Selected image controller
final selectedImageNotifierProvider =
    StateNotifierProvider<SelectedImageNotifier, String?>(
  (ref) => SelectedImageNotifier(),
);

class SelectedImageNotifier extends StateNotifier<String?> {
  SelectedImageNotifier() : super(null);

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
