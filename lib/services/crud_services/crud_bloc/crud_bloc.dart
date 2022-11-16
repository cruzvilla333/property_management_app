import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/auth/auth_tools.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_events.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';

import '../cloud/cloud_property.dart';
import '../cloud/firebase_cloud_storage.dart';

class CrudBloc extends Bloc<CrudEvent, CrudState> {
  CrudBloc(FirebaseCloudStorage storageProvider)
      : super(
          const CrudStateUninitialized(),
        ) {
    on<CrudEventPropertiesView>(
      (event, emit) {
        emit(const CrudStatePropertiesView());
      },
    );
    on<CrudEventLoading>((event, emit) {
      emit(CrudStateLoading(text: event.text));
    });
    on<CrudEventGetProperty>(
      (event, emit) async {
        emit(CrudStateLoading(
            text: event.property != null
                ? 'Getting property...'
                : 'Creating property...'));
        late final CloudProperty property;
        if (event.property != null) {
          property = event.property!;
        } else {
          property = const CloudProperty(
              documentId: '', ownerUserId: '', title: '', address: '');
        }
        emit(CrudStateGetProperty(property: property));
      },
    );
    on<CrudEventCreateOrUpdateProperty>(
      (event, emit) async {
        try {
          emit(const CrudStateLoading(text: 'Creating property...'));
          CloudProperty property = event.property;
          if (property.documentId.isEmpty) {
            property =
                await storageProvider.createProperty(ownerUserId: user().id);
          }
          await storageProvider.updateProperty(
            documentId: property.documentId,
            title: event.title,
            address: event.address,
          );
          emit(const CrudStatePropertiesView());
        } on Exception catch (e) {
          emit(CrudStateCreateOrUpdateProperty(exception: e));
        }
      },
    );
    on<CrudEventDeleteProperty>((event, emit) async {
      try {
        await storageProvider.deleteProperty(
            documentId: event.property.documentId);
      } on Exception catch (e) {
        emit(CrudStateDeleteProperty(exception: e));
      }
    });
  }
}
