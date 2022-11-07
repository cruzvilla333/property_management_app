import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showDeleteDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete note',
    content: 'Are you sure you want to delete this note?',
    optionsBuilder: () => {
      'Delete': true,
      'Cancel': false,
    },
  ).then((value) => value ?? false);
}
