import 'package:flutter/foundation.dart' show immutable;
import 'package:training_note_app/services/crud_services/cloud/cloud_note.dart';

@immutable
abstract class CrudState {
  final Exception? exception;
  const CrudState({this.exception});
}

class CrudStateInitialized extends CrudState {
  const CrudStateInitialized();
}

class CrudStateLoading extends CrudState {
  final String text;
  const CrudStateLoading({required this.text});
}

class CrudStateGetOrCreateProperty extends CrudState {
  final CloudNote property;
  const CrudStateGetOrCreateProperty(
      {required this.property, Exception? exception})
      : super(exception: exception);
}

class CrudStateDeleteNote extends CrudState {
  const CrudStateDeleteNote({Exception? exception})
      : super(exception: exception);
}

class CrudStateUpdateNote extends CrudState {
  const CrudStateUpdateNote({Exception? exception})
      : super(exception: exception);
}
