import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_ai/config/theme/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  //usePathUrlStrategy();
  await Supabase.initialize(
    url: '',
    anonKey: '',
  );
  runApp(const ProviderScope(child: MyApp()));
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo AI',
      theme: AppTheme().getTheme(),
      home: PhotoScreen(),
    );
  }
}

class PhotoScreen extends ConsumerWidget {
  const PhotoScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('PhotoAI'),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return WideLayout();
          } else {
            return NarrowLayout();
          }
        }));
  }
}

class WideLayout extends ConsumerStatefulWidget {
  @override
  WideLayoutState createState() => WideLayoutState();
}

class WideLayoutState extends ConsumerState<WideLayout>
    with SingleTickerProviderStateMixin {
  String selectedChip = '';

  final List<String> elements = [
    'Texto to Image',
    'Image to image',
    'Inpainting'
  ];
  String selectedElement = '';

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
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Scrollbar(
              child: Column(
                children: [Expanded(child: SettingsForm())],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              TabBar(controller: tabController, tabs: [
                for (final element in elements)
                  Tab(
                    text: element,
                  ),
              ]),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    Text('1'),
                    Text('2'),
                    Text('3'),
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

class SettingsForm extends StatelessWidget {
  final TextEditingController promptController = TextEditingController();
  final TextEditingController negativePromptController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Instrucciones',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: promptController,
          maxLines: null, // Permite múltiples líneas
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            labelText: 'Prompt',
            hintText: 'Ingrese su prompt aquí...',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.0),
        TextField(
          controller: negativePromptController,
          maxLines: null, // Permite múltiples líneas
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            labelText: 'Negative Prompt',
            hintText: 'Ingrese su negative prompt aquí...',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            // Acción a realizar al presionar el botón (puedes guardar los valores, validar, etc.)
            print('Prompt: ${promptController.text}');
            print('Negative Prompt: ${negativePromptController.text}');
          },
          child: Text(
            'Enviar',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class NarrowLayout extends ConsumerWidget {
  const NarrowLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return Center();
  }
}
