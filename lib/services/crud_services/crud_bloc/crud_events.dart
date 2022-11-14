import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class CrudEvent {
  const CrudEvent();
}

class CrudEventInitialize extends CrudEvent {
  const CrudEventInitialize();
}
