import 'package:flutter/foundation.dart' show immutable;
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property_payment.dart';

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
  const CrudStatePropertiesView();
}

class CrudStateLoading extends CrudState {
  final String text;
  const CrudStateLoading({required this.text});
}

class CrudStateGetProperty extends CrudState {
  final CloudProperty? property;
  const CrudStateGetProperty({required this.property, Exception? exception})
      : super(exception: exception);
}

class CrudStateDeleteProperty extends CrudState {
  const CrudStateDeleteProperty({Exception? exception})
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
  final Iterable<CloudPropertyPayment> payments;
  final CloudProperty property;
  const CrudStatePaymentHistory(
      {required this.property, required this.payments, exception})
      : super(exception: exception);
}
