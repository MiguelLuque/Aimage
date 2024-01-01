import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_ai/config/theme/theme.dart';
import 'package:photo_ai/features/common/layouts/narrow_layout.dart';
import 'package:photo_ai/features/common/layouts/wide_layout.dart';
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
      title: 'Photo AI',
      theme: AppTheme().getTheme(),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('PhotoAI'),
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
