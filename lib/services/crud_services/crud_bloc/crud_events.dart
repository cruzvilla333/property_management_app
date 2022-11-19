import 'package:flutter/foundation.dart' show immutable;
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property_payment.dart';

@immutable
abstract class CrudEvent {
  const CrudEvent();
}

class CrudEventPropertiesView extends CrudEvent {
  const CrudEventPropertiesView();
}

class CrudEventLoading extends CrudEvent {
  final String text;
  const CrudEventLoading({required this.text});
}

class CrudEventGetProperty extends CrudEvent {
  final CloudProperty? property;
  const CrudEventGetProperty({this.property});
}

class CrudEventCreateOrUpdateProperty extends CrudEvent {
  final CloudProperty property;

  const CrudEventCreateOrUpdateProperty({
    required this.property,
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

class CrudEventDeletePayment extends CrudEvent {
  final CloudPropertyPayment payment;
  const CrudEventDeletePayment({required this.payment});
}
