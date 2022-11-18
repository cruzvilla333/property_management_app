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
        emit(CrudStateGetProperty(property: event.property));
      },
    );
    on<CrudEventCreateOrUpdateProperty>(
      (event, emit) async {
        try {
          emit(const CrudStateLoading(text: 'Creating property...'));
          CloudProperty? property = event.property;
          if (property == null) {
            property = await storageProvider.createProperty(
              ownerUserId: user().id,
              title: event.title,
              address: event.address,
              monthlyPrice: event.monthlyPrice,
            );
          } else {
            await storageProvider.updateProperty(property: property);
          }
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
          final payments = await storageProvider.getPropertyPayments(
              propertyId: event.property.documentId);
          navigationStack.push(event);
          emit(CrudStatePaymentHistory(
              property: event.property, payments: payments));
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
