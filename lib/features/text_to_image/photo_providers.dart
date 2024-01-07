//riverpod provider flutter

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

  void updateValue(int value) {
    state = value;
  }

  void reset() {
    state = 0;
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
