class ImageToImageRequest {
  String key;
  String modelId;
  String prompt;
  String negativePrompt;
  String width;
  String height;
  String samples;
  String safetyChecker;
  String numInferenceSteps;
  String enhancePrompt;
  String scheduler;
  dynamic seed;
  double guidanceScale;
  dynamic webhook;
  dynamic trackId;
  String tomesd;
  String multiLingual;
  String useKarrasSigmas;
  String upscale;
  dynamic vae;
  String selfAttention;
  dynamic loraModel;
  dynamic loraStrength;
  dynamic embeddingsModel;
  int clipSkip;

  ImageToImageRequest(
      {this.key = "your_api_key",
      this.modelId = "epicrealism-natural-sin-r",
      this.prompt = "",
      this.negativePrompt =
          "deformed, distorted, disfigured, doll, poorly drawn, bad anatomy, wrong anatomy, nudity, nude, sex, porn,",
      this.width = "512",
      this.height = "768",
      this.samples = "4",
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

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'model_id': modelId,
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
