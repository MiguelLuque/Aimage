import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NarrowLayout extends ConsumerWidget {
  const NarrowLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return Center(
      child: Text("Hola age"),
    );
  }
}
