import 'package:flutter/foundation.dart' show immutable;
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';

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

class CrudStatesSeePropertyDetails extends CrudState {
  final CloudProperty property;
  const CrudStatesSeePropertyDetails({required this.property});
}

class CrudStateCreateOrUpdateProperty extends CrudState {
  const CrudStateCreateOrUpdateProperty({Exception? exception})
      : super(exception: exception);
}
