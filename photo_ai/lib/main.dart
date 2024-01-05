import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_ai/config/theme/theme.dart';
import 'package:photo_ai/features/auth/auth_provider.dart';
import 'package:photo_ai/features/auth/utils/modal_utils.dart';
import 'package:photo_ai/features/common/layouts/narrow_layout.dart';
import 'package:photo_ai/features/common/layouts/wide_layout.dart';
import 'package:photo_ai/features/text_to_image/photo_providers.dart';
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
  @override
  void initState() {
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
          print("hace log out");
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
          print("usuario borrado");
          await supabase.auth.signOut();
          break;
        default:
      }
      setState(
        () {},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                    child: ElevatedButton(
                      child: Text("Login"),
                      onPressed: () {
                        showLoginDialog(context);
                      },
                    ),
                  ),
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return const WideLayout();
          } else {
            return const NarrowLayout();
          }
        }));
  }
}
