import 'package:flutter/foundation.dart' show immutable;
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';

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
  final CloudProperty? property;
  final String title;
  final String address;
  final int monthlyPrice;
  final int moneyDue;
  const CrudEventCreateOrUpdateProperty({
    required this.property,
    required this.title,
    required this.address,
    required this.monthlyPrice,
    required this.moneyDue,
  });
}

class CrudEventSeePropertyDetails extends CrudEvent {
  final CloudProperty property;
  const CrudEventSeePropertyDetails({required this.property});
}

class CrudEventDeleteProperty extends CrudEvent {
  final CloudProperty property;
  const CrudEventDeleteProperty({required this.property});
}
