import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showlLogOutDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out?',
    optionsBuilder: () => {
      'Log out': true,
      'Cancel': false,
    },
  ).then((value) => value ?? false);
}
