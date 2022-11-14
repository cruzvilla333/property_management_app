import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/auth/auth_provider.dart';
import 'package:training_note_app/services/auth/bloc/auth_states.dart';
import 'package:training_note_app/services/auth/bloc/auth_events.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_events.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';

class CrudBloc extends Bloc<CrudEvent, CrudState> {
  CrudBloc()
      : super(
          const CrudStateUninitialized(),
        ) {
    on<CrudEventInitialize>(
      (event, emit) async {},
    );
  }
}
