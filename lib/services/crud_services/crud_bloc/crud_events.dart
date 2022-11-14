import 'package:flutter/foundation.dart' show immutable;
import 'package:training_note_app/services/crud_services/cloud/cloud_note.dart';

@immutable
abstract class CrudEvent {
  const CrudEvent();
}

class CrudEventGetOrCreateProperty extends CrudEvent {
  final CloudNote? property;
  const CrudEventGetOrCreateProperty({this.property});
}

class CrudEventUpdateProperty extends CrudEvent {
  final CloudNote property;
  final String text;
  const CrudEventUpdateProperty({required this.property, required this.text});
}

class CrudEventDeleteProperty extends CrudEvent {
  final CloudNote property;
  const CrudEventDeleteProperty({required this.property});
}
