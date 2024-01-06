// Función para mostrar el modal
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:aimage/main.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

void showLogOutDialog(BuildContext context) {
  showAdaptiveDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog.adaptive(
        title: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Log out'),
            onPressed: () {
              supabase.auth
                  .signOut()
                  .whenComplete(() => Navigator.pop(context));
            },
          ),
        ],
      );
    },
  );
}

void showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      final screenSize = MediaQuery.of(context).size;
      final dialogWidth =
          screenSize.height * 0.5 / 1.5; // Ajusta según tus necesidades
      final dialogHeight =
          screenSize.height * 0.5; // Ajusta según tus necesidades

      return AlertDialog(
        content: Padding(
          padding: const EdgeInsets.all(1.0),
          child: SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Log in to AImage",
                  style: TextStyle(
                    fontSize:
                        30.0, 
                    fontWeight: FontWeight.bold, 
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SupaEmailAuth(
                  redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
                  onSignInComplete: (response) {
                    Navigator.pop(context);
                  },
                  onSignUpComplete: (response) {
                    Navigator.pop(context);
                  },
                  metadataFields: [
                    MetaDataField(
                      prefixIcon: const Icon(Icons.person),
                      label: 'Username',
                      key: 'username',
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'This field can not be empty';
                        }
                        return null;
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
