import 'package:aimage/config/menu/menu_items.dart';
import 'package:aimage/features/common/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aimage/config/theme/theme.dart';
import 'package:aimage/features/auth/auth_provider.dart';
import 'package:aimage/features/auth/utils/auth_modal_utils.dart';
import 'package:aimage/features/common/layouts/narrow_layout.dart';
import 'package:aimage/features/common/layouts/wide_layout.dart';
import 'package:aimage/features/text_to_image/photo_providers.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //usePathUrlStrategy();
  await Supabase.initialize(
    url: 'https://qreyzlrsuyxlzinmskbb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFyZXl6bHJzdXl4bHppbm1za2JiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDI0MDk1MzIsImV4cCI6MjAxNzk4NTUzMn0.YMPoEOk0iNE3KK6GAlRdoocbGWkKVh42986HYIx4u2k',
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
      debugShowCheckedModeBanner: false,
      title: 'AImage',
      theme: AppTheme().getTheme(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  List<MenuItem> menuItems = [];

  @override
  void initState() {
    menuItems = appMenuItems;
    _setupAuthListener();
    super.initState();
  }

  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) async {
      final event = data.event;

      switch (event) {
        case AuthChangeEvent.initialSession:
          ref.read(authNotifierProvider.notifier).updateValue(data.session);
          break;
        case AuthChangeEvent.signedIn:
          ref.read(authNotifierProvider.notifier).updateValue(data.session);
          break;
        case AuthChangeEvent.signedOut:
          ref.read(authNotifierProvider.notifier).updateValue(data.session);
          ref.read(settingsFormNotifierProvider.notifier).reset();
          ref.read(featureNotifierProvider.notifier).reset();
          ref.read(textToImageNotifierProvider.notifier).reset();
          ref.read(imageToImageNotifierProvider.notifier).reset();
          ref.read(spinnerNotifierProvider.notifier).reset();
          ref.read(appSettingsNotifierProvider.notifier).reset();
          ref.read(inpaintingImageNotifierProvider.notifier).reset();
          ref.read(selectedImageNotifierProvider.notifier).reset();
          break;
        case AuthChangeEvent.userDeleted:
          await supabase.auth.signOut();
          break;
        default:
      }
      setState(
        () {},
      );
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      ref.read(featureNotifierProvider.notifier).updateValue(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('AImage'),
          actions: [
            ref.read(authNotifierProvider) != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons
                          .logout), // Puedes usar otro icono según tus necesidades
                      onPressed: () {
                        showLogOutDialog(context);
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GradientButton(
                      child: Text(
                        'Login',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      onPressed: () {
                        showLoginDialog(context);
                      },
                    ),
                  ),
          ],
        ),
        body: constraints.maxWidth > 600
            ? const WideLayout()
            : const NarrowLayout(),
        bottomNavigationBar: constraints.maxWidth < 600
            ? BottomNavigationBar(
                items: menuItems
                    .map(
                      (item) => BottomNavigationBarItem(
                        icon: Icon(item.icon),
                        label: item.title,
                      ),
                    )
                    .toList(),
                currentIndex: ref.read(featureNotifierProvider),
                onTap: _onItemTapped,
              )
            : null,
      );
    });
  }
}
