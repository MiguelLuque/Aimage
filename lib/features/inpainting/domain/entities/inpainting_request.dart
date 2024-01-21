class InpaintingRequest {
  String key;
  String modelId;
  String prompt;
  String negativePrompt;
  String initImage;
  String maskImage;
  String width;
  String height;
  String samples;
  String steps;
  String safetyChecker;
  String enhancePrompt;
  double guidanceScale;
  String scheduler;
  dynamic seed;
  String? algorithmType;
  dynamic webhook;
  dynamic trackId;
  String tomesd;
  String useKarrasSigmas;
  String upscale;
  dynamic vae;
  double strength;

  dynamic loraModel;
  dynamic loraStrength;
  int clipSkip;

  InpaintingRequest(
      {this.key = "your_api_key",
      this.modelId = "epicrealism-natural-sin-r",
      this.prompt = "",
      this.negativePrompt =
          "deformed, distorted, disfigured, doll, poorly drawn, bad anatomy, wrong anatomy, nudity, nude, sex, porn,",
      required this.initImage,
      required this.maskImage,
      this.width = "512",
      this.height = "768",
      this.samples = "1",
      this.safetyChecker = "no",
      this.steps = "20",
      this.enhancePrompt = "no",
      this.scheduler = "DPMSolverMultistepScheduler",
      this.seed,
      this.guidanceScale = 7.0,
      this.webhook,
      this.trackId,
      this.tomesd = "yes",
      this.useKarrasSigmas = "yes",
      this.upscale = "no",
      this.vae,
      this.loraModel,
      this.loraStrength,
      this.algorithmType,
      this.strength = 1,
      this.clipSkip = 1});

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'model_id': modelId,
      'prompt': prompt,
      'negative_prompt': negativePrompt,
      'width': width,
      'height': height,
      'init_image': initImage,
      'mask_image': maskImage,
      'samples': samples,
      'safety_checker': safetyChecker,
      'steps': steps,
      'enhance_prompt': enhancePrompt,
      'scheduler': scheduler,
      'seed': seed,
      'guidance_scale': guidanceScale,
      'webhook': webhook,
      'track_id': trackId,
      'tomesd': tomesd,
      'use_karras_sigmas': useKarrasSigmas,
      'upscale': upscale,
      'vae': vae,
      'lora_model': loraModel,
      'lora_strength': loraStrength,
      'algorithm_type': algorithmType,
      'strength': strength,
      'clip_skip': clipSkip,
    };
  }
}
