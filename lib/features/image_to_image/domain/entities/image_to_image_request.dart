import 'package:aimage/features/text_to_image/domain/entities/text_to_image_request.dart';

class ImageToImageRequest {
  String key;
  String modelId;
  String prompt;
  String negativePrompt;
  String initImage;
  String width;
  String height;
  String samples;
  String safetyChecker;
  String enhancePrompt;
  String numInferenceSteps;
  double guidanceScale;
  String tomesd;
  dynamic webhook;
  dynamic trackId;
  String multiLingual;
  String useKarrasSigmas;
  String upscale;
  dynamic vae;
  String selfAttention;
  dynamic loraModel;
  dynamic loraStrength;
  dynamic embeddingsModel;
  int clipSkip;
  String scheduler;
  dynamic seed;

  ImageToImageRequest(
      {this.key = "your_api_key",
      this.modelId = "epicrealism-natural-sin-r",
      this.initImage = "",
      this.prompt = "",
      this.negativePrompt =
          "deformed, distorted, disfigured, doll, poorly drawn, bad anatomy, wrong anatomy, nudity, nude, sex, porn,",
      this.width = "512",
      this.height = "768",
      this.samples = "1",
      this.safetyChecker = "no",
      this.numInferenceSteps = "20",
      this.enhancePrompt = "no",
      this.scheduler = "DPMSolverMultistepScheduler",
      this.seed,
      this.guidanceScale = 6.0,
      this.webhook,
      this.trackId,
      this.tomesd = "yes",
      this.multiLingual = "no",
      this.useKarrasSigmas = "yes",
      this.upscale = "no",
      this.vae,
      this.loraModel,
      this.loraStrength,
      this.embeddingsModel,
      this.clipSkip = 1,
      this.selfAttention = "yes"});

  ImageToImageRequest convertToImageToImageRequest(
      TextToImageRequest textRequest, String initImage) {
    return ImageToImageRequest(
      key: textRequest.key,
      modelId: textRequest.modelId,
      prompt: textRequest.prompt,
      negativePrompt: textRequest.negativePrompt,
      initImage:
          initImage, // Provide the appropriate value or logic for initImage
      width: textRequest.width,
      height: textRequest.height,
      samples: textRequest.samples,
      safetyChecker: textRequest.safetyChecker,
      enhancePrompt: textRequest.enhancePrompt,
      numInferenceSteps: textRequest.numInferenceSteps,
      guidanceScale: textRequest.guidanceScale,
      tomesd: textRequest.tomesd,
      webhook: textRequest.webhook,
      trackId: textRequest.trackId,
      multiLingual: textRequest.multiLingual,
      useKarrasSigmas: textRequest.useKarrasSigmas,
      upscale: textRequest.upscale,
      vae: textRequest.vae,
      selfAttention: textRequest.selfAttention,
      loraModel: textRequest.loraModel,
      loraStrength: textRequest.loraStrength,
      embeddingsModel: textRequest.embeddingsModel,
      clipSkip: textRequest.clipSkip,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'model_id': modelId,
      'init_image': initImage,
      'prompt': prompt,
      'negative_prompt': negativePrompt,
      'width': width,
      'height': height,
      'samples': samples,
      'safety_checker': safetyChecker,
      'num_inference_steps': numInferenceSteps,
      'enhance_prompt': enhancePrompt,
      'scheduler': scheduler,
      'seed': seed,
      'guidance_scale': guidanceScale,
      'webhook': webhook,
      'track_id': trackId,
      'tomesd': tomesd,
      'multi_lingual': multiLingual,
      'use_karras_sigmas': useKarrasSigmas,
      'upscale': upscale,
      'vae': vae,
      'lora_model': loraModel,
      'lora_strength': loraStrength,
      'embeddings_model': embeddingsModel,
      'clip_skip': clipSkip,
    };
  }

  String toJsonText() {
    return '{"key": $key,"model_id": $modelId,"prompt": $prompt,"negative_prompt": $negativePrompt,"width": $width,"height": $height,"samples": $samples,"safety_checker": $safetyChecker,"num_inference_steps": $numInferenceSteps,"enhance_prompt": $enhancePrompt,"scheduler": $scheduler,"seed": $seed,"guidance_scale": $guidanceScale,"webhook": $webhook,"track_id": $trackId,"tomesd": $tomesd,"multi_lingual": $multiLingual,"use_karras_sigmas": $useKarrasSigmas,"upscale": $upscale,"vae": $vae,"lora_model": $loraModel,"lora_strength": $loraStrength,"embeddings_model": $embeddingsModel,"self_attention": $selfAttention,"clip_skip": $clipSkip,}';
  }
}
