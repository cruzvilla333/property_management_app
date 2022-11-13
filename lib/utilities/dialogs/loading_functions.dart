import 'package:flutter/cupertino.dart';
import 'package:training_note_app/services/auth/bloc/auth_states.dart';

import '../../helpers/loading/loading_screen.dart';

void handleLoading({
  required BuildContext context,
  required AuthState state,
}) {
  if (state.isLoading) {
    LoadingScreen().show(
      context: context,
      text: state.loadingText ?? 'Please wait a moment',
    );
  } else {
    LoadingScreen().hide();
  }
}
