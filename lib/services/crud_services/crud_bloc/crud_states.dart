import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property_payment.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_tenant.dart';

@immutable
abstract class CrudState {
  final Exception? exception;
  const CrudState({this.exception});
}

class CrudStateInitialized extends CrudState {
  const CrudStateInitialized();
}

class CrudStateUninitialized extends CrudState {
  const CrudStateUninitialized();
}

class CrudStatePropertiesView extends CrudState {
  final Stream<Iterable<CloudProperty>> properties;
  const CrudStatePropertiesView({required this.properties});
}

class CrudStateTenantsView extends CrudState {
  final Stream<Iterable<CloudTenant>> tenants;
  const CrudStateTenantsView({required this.tenants});
}

class CrudStateLoading extends CrudState {
  final String text;
  const CrudStateLoading({required this.text});
}

class CrudStateGetProperty extends CrudState {
  final CloudProperty? property;
  final List<CloudTenant>? availableTenants;
  final List<CloudTenant> currentTenants;
  const CrudStateGetProperty(
      {required this.property,
      Exception? exception,
      this.availableTenants,
      required this.currentTenants})
      : super(exception: exception);
}

class CrudStateGetTenant extends CrudState {
  final CloudTenant? tenant;
  const CrudStateGetTenant({required this.tenant, Exception? exception})
      : super(exception: exception);
}

class CrudStateDisableLoading extends CrudState {
  const CrudStateDisableLoading();
}

class CrudStateDeleteProperty extends CrudState {
  const CrudStateDeleteProperty({Exception? exception})
      : super(exception: exception);
}

class CrudStateDeleteTenant extends CrudState {
  const CrudStateDeleteTenant({Exception? exception})
      : super(exception: exception);
}

class CrudStateDeletePayment extends CrudState {
  const CrudStateDeletePayment({Exception? exception})
      : super(exception: exception);
}

class CrudStatePropertyInfo extends CrudState {
  final CloudProperty property;
  const CrudStatePropertyInfo({required this.property, exception})
      : super(exception: exception);
}

class CrudStateCreateOrUpdateProperty extends CrudState {
  const CrudStateCreateOrUpdateProperty({Exception? exception})
      : super(exception: exception);
}

class CrudStatePaymentHistory extends CrudState {
  final Stream<Iterable<CloudPropertyPayment>> payments;
  const CrudStatePaymentHistory({required this.payments, exception})
      : super(exception: exception);
}
