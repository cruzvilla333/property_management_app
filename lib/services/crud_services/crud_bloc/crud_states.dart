import 'package:flutter/foundation.dart' show immutable;
import 'package:training_note_app/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class CrudState {
  const CrudState();
}

class CrudStateUninitialized extends CrudState {
  const CrudStateUninitialized();
}
