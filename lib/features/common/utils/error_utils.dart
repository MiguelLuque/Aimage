import 'package:aimage/config/theme/theme.dart';
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
        Text('An unexpected error has occurred, please try in a few minutes'),
      ],
    ),
  );
}

SnackBar snackBarErrorCustom(BuildContext context, String message) {
  return SnackBar(
    backgroundColor: Theme.of(context).colorScheme.error,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
      ],
    ),
  );
}

showErrorCustom(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
      .showSnackBar(snackBarErrorCustom(context, message));
}

showGenericError(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(showSnackBarError(context));
}

SnackBar showSnackBarCustomMessage(BuildContext context, String message) {
  return SnackBar(
    backgroundColor: AppTheme().error,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
      ],
    ),
  );
}
