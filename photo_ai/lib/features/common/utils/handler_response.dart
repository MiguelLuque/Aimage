import 'package:flutter/material.dart';
import 'package:photo_ai/features/inpainting/infraestructure/inpainting_service.dart';
import 'package:photo_ai/features/text_to_image/domain/entities/text_to_image_request.dart';
import 'package:photo_ai/features/text_to_image/infraestructure/text_to_image_service.dart';

// class HandlerResponse {
//   TextToImageServiceImpl textToImageService = TextToImageServiceImpl();
//   InpaintingServiceImpl inpaintingServiceImpl = InpaintingServiceImpl();

//   HandleResponse(BuildContext context, TextToImageRequest request) {
//     textToImageService.textToImage(request).then((value) {
//       ref.read(textToImageNotifierProvider.notifier).updateValue(value);
//       if (value.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(showSnackBarError(context));
//       }
//     });
//   }
// }
