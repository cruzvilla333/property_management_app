import 'package:flutter/foundation.dart' show immutable;
import 'package:training_note_app/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_note.dart';

@immutable
abstract class CrudState {
  const CrudState();
}

class CrudStateInitialized extends CrudState {
  const CrudStateInitialized();
}

class CrudStateGoToGetOrCreateProperty extends CrudState {
  final CloudNote? property;
  const CrudStateGoToGetOrCreateProperty({this.property});
}
