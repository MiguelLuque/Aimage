//riverpod provider flutter

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_ai/features/text_to_image/domain/entities/text_to_image_request.dart';

//texto to image controller
final textToImageFormNotifierProvider =
    StateNotifierProvider<TextToImageFormNotifier, TextToImageRequest>(
  (ref) => TextToImageFormNotifier(),
);

class TextToImageFormNotifier extends StateNotifier<TextToImageRequest> {
  TextToImageFormNotifier() : super(TextToImageRequest());

  void updateValue(TextToImageRequest value) {
    state = value;
  }

  void resetFilters() {
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

  void resetFilters() {
    state = 0;
  }
}

//Text to image generated list controller
final textToImageNotifierProvider =
    StateNotifierProvider<TextToImageNotifier, List<String>>(
  (ref) => TextToImageNotifier(),
);

class TextToImageNotifier extends StateNotifier<List<String>> {
  TextToImageNotifier() : super(List.empty());

  void updateValue(List<String> value) {
    state = value;
  }

  void resetFilters() {
    state = List.empty();
  }
}

//Inpainting selected image controller
final inpaintingSelectedImageNotifierProvider =
    StateNotifierProvider<InpaintingSelectedImageNotifier, String?>(
  (ref) => InpaintingSelectedImageNotifier(),
);

class InpaintingSelectedImageNotifier extends StateNotifier<String?> {
  InpaintingSelectedImageNotifier() : super(null);

  void updateValue(String? value) {
    state = value;
  }

  void resetFilters() {
    state = null;
  }
}
