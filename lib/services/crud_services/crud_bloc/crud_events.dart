import 'package:flutter/foundation.dart' show immutable;
import 'package:training_note_app/services/crud_services/cloud/cloud_note.dart';

@immutable
abstract class CrudEvent {
  const CrudEvent();
}

class CrudEventGoToGetOrCreateProperty extends CrudEvent {
  final CloudNote? property;
  const CrudEventGoToGetOrCreateProperty({this.property});
}
