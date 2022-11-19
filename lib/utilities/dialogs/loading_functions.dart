import 'package:flutter/cupertino.dart';
import 'package:training_note_app/services/auth/auth_bloc/auth_states.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';

import '../../helpers/loading/loading_screen.dart';

void handleLoading({
  required BuildContext context,
  required Object state,
}) {
  if (state is AuthStateLoading) {
    LoadingScreen().show(
      context: context,
      text: state.text,
    );
  } else if (state is CrudStateLoading) {
    LoadingScreen().show(
      context: context,
      text: state.text,
    );
  } else {
    LoadingScreen().hide();
  }
}
