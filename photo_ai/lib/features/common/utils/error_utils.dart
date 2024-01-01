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

SnackBar showSnackBarError(BuildContext context) {
  return SnackBar(
    backgroundColor: Theme.of(context).colorScheme.error,
    content: const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Error creating, please try in a few minutes'),
      ],
    ),
  );
}

SnackBar showSnackBarCustomMessage(BuildContext context, String message) {
  return SnackBar(
    backgroundColor: Colors.deepPurple.shade100,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
      ],
    ),
  );
}
