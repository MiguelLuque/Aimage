import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimage/features/common/widgets/loading_widget.dart';
import 'package:aimage/features/image_to_image/presentation/screens/image_to_image_screen.dart';
import 'package:aimage/features/inpainting/presentation/screens/inpainting_screen.dart';
import 'package:aimage/features/text_to_image/photo_providers.dart';
import 'package:aimage/features/text_to_image/presentation/screens/text_to_image_screen.dart';
import 'package:aimage/features/common/widgets/image_settings_form.dart';

class WideLayout extends ConsumerStatefulWidget {
  const WideLayout({super.key});

  @override
  WideLayoutState createState() => WideLayoutState();
}

class WideLayoutState extends ConsumerState<WideLayout>
    with SingleTickerProviderStateMixin {
  final List<String> elements = [
    'Texto to Image',
    'Image to image',
    'Inpainting'
  ];

  late TabController tabController;

  // const WideLayout({
  //   super.key, this.s
  // });

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: elements.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(spinnerNotifierProvider);
    return Row(
      children: [
        const ImageSettingsForm(
          isMobile: false,
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              TabBar(
                  controller: tabController,
                  tabs: [
                    for (final element in elements)
                      Tab(
                        text: element,
                      ),
                  ],
                  onTap: (value) => ref
                      .read(featureNotifierProvider.notifier)
                      .updateValue(value)),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    LoadingWidget(
                        isLoading: isLoading, child: const ImageListScreen()),
                    LoadingWidget(
                        isLoading: isLoading,
                        child: const ImageToImageScreen()),
                    LoadingWidget(
                        isLoading: isLoading, child: const InpaintingScreen()),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
