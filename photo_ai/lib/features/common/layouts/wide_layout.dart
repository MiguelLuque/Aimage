import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_ai/features/inpainting/presentation/screens/inpainting_screen.dart';
import 'package:photo_ai/features/text_to_image/photo_providers.dart';
import 'package:photo_ai/features/text_to_image/presentation/screens/text_to_image_screen.dart';
import 'package:photo_ai/features/common/widgets/image_settings_form.dart';

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
    print("is loading watched as : $isLoading");
    return Row(
      children: [
        const ImageSettingsForm(),
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
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ImageListScreen(),
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Text('2'),
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : InpaintingScreen(),
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
