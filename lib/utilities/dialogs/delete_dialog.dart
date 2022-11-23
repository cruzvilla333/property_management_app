import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showDeletePropertyDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete property',
    content: 'Are you sure you want to delete this property?',
    optionsBuilder: () => {
      'Delete': true,
      'Cancel': false,
    },
  ).then((value) => value ?? false);
}

Future<bool> showDeleteTenantDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete tenant',
    content: 'Are you sure you want to delete this tenant?',
    optionsBuilder: () => {
      'Delete': true,
      'Cancel': false,
    },
  ).then((value) => value ?? false);
}

Future<bool> showDeletePaymentDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete payment',
    content: 'Are you sure you want to delete this payment?',
    optionsBuilder: () => {
      'Delete': true,
      'Cancel': false,
    },
  ).then((value) => value ?? false);
}
