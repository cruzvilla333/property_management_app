import 'package:flutter/cupertino.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property_payment.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_tenant.dart';

@immutable
abstract class CrudEvent {
  const CrudEvent();
}

class CrudEventPropertiesView extends CrudEvent {
  const CrudEventPropertiesView();
}

class CrudEventTenantsView extends CrudEvent {
  const CrudEventTenantsView();
}

class CrudEventLoading extends CrudEvent {
  final String text;
  const CrudEventLoading({required this.text});
}

class CrudEventGetProperty extends CrudEvent {
  final CloudProperty? property;
  const CrudEventGetProperty({this.property});
}

class CrudEventGetTenant extends CrudEvent {
  final CloudTenant? tenant;
  const CrudEventGetTenant({this.tenant});
}

class CrudEventCreateOrUpdateProperty extends CrudEvent {
  final CloudProperty property;
  final BuildContext? context;
  final List<CloudTenant>? currentTenants;
  final List<CloudTenant>? removedTenants;
  const CrudEventCreateOrUpdateProperty({
    required this.property,
    this.context,
    this.currentTenants,
    this.removedTenants,
  });
}

class CrudEventCreateOrUpdateTenant extends CrudEvent {
  final CloudTenant tenant;

  const CrudEventCreateOrUpdateTenant({
    required this.tenant,
  });
}

class CrudEventMakePayment extends CrudEvent {
  final int amount;
  final bool? resetMoneyDue;
  final CloudProperty property;
  final String paymentMethod;

  const CrudEventMakePayment({
    required this.amount,
    required this.property,
    this.resetMoneyDue,
    required this.paymentMethod,
  });
}

class CrudEventPropertyInfo extends CrudEvent {
  final CloudProperty property;
  const CrudEventPropertyInfo({required this.property});
}

class CrudEventPaymentHistory extends CrudEvent {
  final CloudProperty property;
  const CrudEventPaymentHistory({required this.property});
}

class CrudEventDeleteProperty extends CrudEvent {
  final CloudProperty property;
  const CrudEventDeleteProperty({required this.property});
}

class CrudEventDeleteTenant extends CrudEvent {
  final CloudTenant tenant;
  const CrudEventDeleteTenant({required this.tenant});
}

class CrudEventDeletePayment extends CrudEvent {
  final CloudPropertyPayment payment;
  const CrudEventDeletePayment({required this.payment});
}
