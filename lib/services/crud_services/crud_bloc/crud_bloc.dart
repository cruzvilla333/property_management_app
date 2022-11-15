import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/auth/auth_tools.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_events.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';

import '../cloud/cloud_property.dart';
import '../cloud/firebase_cloud_storage.dart';

class CrudBloc extends Bloc<CrudEvent, CrudState> {
  CrudBloc(FirebaseCloudStorage storageProvider)
      : super(
          const CrudStateInitialized(),
        ) {
    on<CrudEventGetOrCreateProperty>(
      (event, emit) async {
        emit(const CrudStateLoading(text: 'Creating property...'));
        late final CloudProperty property;
        if (event.property != null) {
          property = event.property!;
        } else {
          property =
              await storageProvider.createProperty(ownerUserId: user().id);
        }
        emit(CrudStateGetOrCreateProperty(property: property));
      },
    );
    on<CrudEventUpdateProperty>(
      (event, emit) async {
        try {
          await storageProvider.updateProperty(
              documentId: event.property.documentId, text: event.text);
        } on Exception catch (e) {
          emit(CrudStateUpdateNote(exception: e));
        }
      },
    );
    on<CrudEventDeleteProperty>((event, emit) async {
      try {
        await storageProvider.deleteProperty(
            documentId: event.property.documentId);
      } on Exception catch (e) {
        emit(CrudStateDeleteNote(exception: e));
      }
    });
  }
}
