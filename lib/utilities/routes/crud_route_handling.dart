import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:training_note_app/constants/routes.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';

import 'app_routes.dart';

void handleCrudRouting({
  required BuildContext context,
  required CrudState state,
}) async {
  if (state is CrudStateGoToGetOrCreateProperty) {
    context.goNamed(getOrUpdatePropertyPage);
  }
}
