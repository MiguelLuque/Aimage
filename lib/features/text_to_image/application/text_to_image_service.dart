import 'package:aimage/features/text_to_image/repositories/text_to_image_repository.dart';
import 'package:aimage/features/text_to_image/domain/entities/text_to_image_request.dart';

class TextToImageServiceImpl {
  TextToImageRepository textToImageRepository = TextToImageRepository();

  Future<List<String>> textToImage(TextToImageRequest request) async {
    try {
      return await textToImageRepository.textToImage(request);
    } catch (e) {
      return List.empty();
    }
  }
}
