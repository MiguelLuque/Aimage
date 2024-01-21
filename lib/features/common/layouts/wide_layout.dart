import 'package:aimage/config/theme/theme.dart';
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TabBar(
                      controller: tabController,
                      tabs: [
                        for (final element in elements)
                          Tab(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  border: Border.all(
                                      color: AppTheme().white, width: 1)),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(element),
                              ),
                            ),
                          ),
                      ],
                      onTap: (value) => ref
                          .read(featureNotifierProvider.notifier)
                          .updateValue(value)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        LoadingWidget(
                            isLoading: isLoading,
                            child: const ImageListScreen()),
                        LoadingWidget(
                            isLoading: isLoading,
                            child: const ImageToImageScreen()),
                        LoadingWidget(
                            isLoading: isLoading,
                            child: const InpaintingScreen()),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
