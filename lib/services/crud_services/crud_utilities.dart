import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property_payment.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_tenant.dart';

import '../../utilities/dialogs/delete_dialog.dart';
import 'crud_bloc/crud_bloc.dart';
import 'crud_bloc/crud_events.dart';

Future<bool> attemptPaymentDeletion(
    {required BuildContext context,
    required CloudPropertyPayment payment}) async {
  const mounted = true;
  final shouldDelete = await showDeletePaymentDialog(context);
  if (shouldDelete && mounted) {
    context.read<CrudBloc>().add(CrudEventDeletePayment(payment: payment));
  }
  return shouldDelete;
}

Future<bool> attemptPropertyDeletion(
    {required BuildContext context, required CloudProperty property}) async {
  const mounted = true;
  final shouldDelete = await showDeletePropertyDialog(context);
  if (shouldDelete && mounted) {
    context.read<CrudBloc>().add(CrudEventDeleteProperty(property: property));
  }
  return shouldDelete;
}

Future<bool> attemptTenantDeletion(
    {required BuildContext context, required CloudTenant tenant}) async {
  const mounted = true;
  final shouldDelete = await showDeleteTenantDialog(context);
  if (shouldDelete && mounted) {
    context.read<CrudBloc>().add(CrudEventDeleteTenant(tenant: tenant));
  }
  return shouldDelete;
}
