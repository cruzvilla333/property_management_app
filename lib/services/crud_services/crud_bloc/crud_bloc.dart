import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/auth/auth_tools.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_events.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';
import '../../../utilities/navigation/navigation_utilities.dart';
import '../cloud/cloud_property.dart';
import '../cloud/firebase_cloud_storage.dart';

class CrudBloc extends Bloc<CrudEvent, CrudState> {
  CrudBloc(FirebaseCloudStorage storageProvider)
      : super(
          const CrudStateUninitialized(),
        ) {
    on<CrudEventPropertiesView>(
      (event, emit) {
        emit(const CrudStateLoading(text: 'Getting properties'));
        navigationStack.push(event);
        final properties =
            storageProvider.allProperties(ownerUserId: user().id);
        emit(CrudStatePropertiesView(properties: properties));
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
        navigationStack.push(event);
        emit(CrudStateGetProperty(property: event.property));
      },
    );
    on<CrudEventCreateOrUpdateProperty>(
      (event, emit) async {
        try {
          emit(const CrudStateLoading(text: 'Creating property...'));
          CloudProperty property = event.property;
          if (property.documentId.isEmpty) {
            property = await storageProvider.createProperty(
              ownerUserId: user().id,
              title: event.property.title,
              address: event.property.address,
              monthlyPrice: event.property.monthlyPrice,
            );
          } else {
            await storageProvider.updateProperty(property: property);
          }
        } on Exception catch (e) {
          emit(CrudStateCreateOrUpdateProperty(exception: e));
        }
      },
    );
    on<CrudEventDeleteProperty>((event, emit) async {
      emit(const CrudStateLoading(text: 'Deleting property'));
      try {
        storageProvider.deleteAllPayments(
            propertyId: event.property.documentId);
        await storageProvider.deleteProperty(
            documentId: event.property.documentId);
        emit(const CrudStateDisableLoading());
      } on Exception catch (e) {
        emit(CrudStateDeleteProperty(exception: e));
      }
    });
    on<CrudEventPropertyInfo>(
      (event, emit) {
        navigationStack.push(event);
        emit(CrudStatePropertyInfo(property: event.property));
      },
    );
    on<CrudEventMakePayment>(
      (event, emit) async {
        try {
          emit(const CrudStateLoading(text: 'Making payment...'));
          if (event.resetMoneyDue == true) {
            event.property.resetMoneyDue();
          } else {
            event.property.makePayment(amount: event.amount);
            storageProvider.createPayment(
              propertyId: event.property.documentId,
              paymentAmount: event.amount,
              paymentMethod: event.paymentMethod,
            );
          }
          await storageProvider.updateProperty(property: event.property);
          emit(CrudStatePropertyInfo(property: event.property));
        } on Exception catch (e) {
          emit(CrudStatePropertyInfo(
            property: event.property,
            exception: e,
          ));
        }
      },
    );
    on<CrudEventPaymentHistory>(
      (event, emit) async {
        emit(const CrudStateLoading(text: 'Getting payment history'));
        try {
          final payments = storageProvider.allPayments(
              propertyId: event.property.documentId);
          navigationStack.push(event);
          emit(CrudStatePaymentHistory(payments: payments));
        } on Exception catch (e) {
          emit(CrudStatePropertyInfo(property: event.property, exception: e));
        }
      },
    );
    on<CrudEventDeletePayment>((event, emit) async {
      try {
        await storageProvider.deletePayment(
            documentId: event.payment.documentId);
      } on Exception catch (e) {
        emit(CrudStateDeletePayment(exception: e));
      }
    });
  }
}
