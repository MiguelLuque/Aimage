import 'package:flutter/foundation.dart';
import 'package:aimage/features/inpainting/domain/entities/inpainting_request.dart';
import 'package:aimage/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InpaintingRepository {
  Future<List<String>> inpaint(InpaintingRequest request) async {
    try {
      List<String> res = List.empty();
      int count = 0;

      var existError = false;

      Map<String, dynamic> response = <String, dynamic>{};

      do {
        await supabase.functions
            .invoke('inpainting',
                method: HttpMethod.post, body: request.toJson())
            .then((value) {
          response = value.data;
        }).catchError((error) {
          if (kDebugMode) {
            print(error);
          }
          response = <String, dynamic>{};
        });

        if (response.isNotEmpty) {
          existError = false;
        } else {
          count++;
        }
        if (count > 10) {
          break;
        }
      } while (existError);

      if (response['status'] == 'processing') {}
      switch (response['status']) {
        case 'processing':
          var images = response['future_links'] as List<dynamic>;
          res = images.map((dynamic item) => item.toString()).toList();
          break;
        case 'success':
          var images = response['output'] as List<dynamic>;
          res = images.map((dynamic item) => item.toString()).toList();
          break;
        default:
          //TODO: mostrar un error y devolver una lista vacia
          print(response.toString());
          break;
      }
      return res;
    } catch (e) {
      return List.empty();
    }
  }
}
