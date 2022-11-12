import 'package:flutter/cupertino.dart';
import 'package:training_note_app/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content: 'We have sent you a password reset email',
    optionsBuilder: () => {'': false},
  );
}
