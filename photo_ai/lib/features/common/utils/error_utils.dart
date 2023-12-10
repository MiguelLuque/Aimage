
  import 'package:flutter/material.dart';

SnackBar showSnackBarLoginError(BuildContext context) {
    return SnackBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Invalid email or password'),
        ],
      ),
    );
  }