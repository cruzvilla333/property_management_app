import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/auth/auth_tools.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_tenant.dart';
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
      (event, emit) async {
        emit(const CrudStateLoading(text: 'Getting properties'));
        navigationStack.clear();
        navigationStack.push(event);
        final currProperties =
            await storageProvider.getProperties(ownerUserId: user().id);
        for (CloudProperty property in currProperties) {
          await storageProvider.adjustMoneyDue(property: property);
        }
        final properties = storageProvider.propertyStream();
        emit(CrudStatePropertiesView(properties: properties));
      },
    );
    on<CrudEventTenantsView>(
      (event, emit) async {
        emit(const CrudStateLoading(text: 'Getting tenants'));
        navigationStack.clear();
        navigationStack.push(event);
        final tenants = storageProvider.tenantStream();
        emit(CrudStateTenantsView(tenants: tenants));
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
        final availableTenants = await storageProvider.getTenantsWhere();
        Iterable<CloudTenant> currentTenants = [];
        if (event.property != null) {
          currentTenants = await storageProvider.getTenantsWhere(
              where: event.property!.propertyId);
        }
        navigationStack.push(event);
        emit(CrudStateGetProperty(
          property: event.property,
          availableTenants: availableTenants.toList(),
          currentTenants: currentTenants.toList(),
        ));
      },
    );
    on<CrudEventGetTenant>(
      (event, emit) async {
        emit(CrudStateLoading(
            text: event.tenant != null
                ? 'Getting tenant...'
                : 'Creating tenant...'));
        navigationStack.push(event);
        emit(CrudStateGetTenant(tenant: event.tenant));
      },
    );
    on<CrudEventCreateOrUpdateProperty>(
      (event, emit) async {
        try {
          emit(const CrudStateLoading(text: 'Creating property...'));
          CloudProperty property = event.property;
          if (property.propertyId.isEmpty) {
            property = await storageProvider.createProperty(
              ownerUserId: user().id,
              title: event.property.title,
              address: event.property.address,
              monthlyPrice: event.property.monthlyPrice,
            );
          } else {
            await storageProvider.updateProperty(property: property);
          }
          if (event.context != null) {
            if (event.removedTenants != null) {
              for (CloudTenant tenant in event.removedTenants!) {
                tenant.propertyId = '';
                await storageProvider.updateTenant(tenant: tenant);
              }
            }
            if (event.currentTenants != null) {
              for (CloudTenant tenant in event.currentTenants!) {
                tenant.propertyId = property.propertyId;
                await storageProvider.updateTenant(tenant: tenant);
              }
            }
          }
        } on Exception catch (e) {
          emit(CrudStateCreateOrUpdateProperty(exception: e));
        }
      },
    );
    on<CrudEventCreateOrUpdateTenant>(
      (event, emit) async {
        try {
          emit(const CrudStateLoading(text: 'Creating tenant...'));
          CloudTenant tenant = event.tenant;
          if (tenant.tenantId.isEmpty) {
            tenant = await storageProvider.createTenant(
              ownerUserId: user().id,
              firstName: event.tenant.firstName,
              lastName: event.tenant.lastName,
              sex: event.tenant.sex,
              age: event.tenant.age,
            );
          } else {
            await storageProvider.updateTenant(tenant: tenant);
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
            propertyId: event.property.propertyId);
        await storageProvider.deleteProperty(
            documentId: event.property.propertyId);
      } on Exception catch (e) {
        emit(CrudStateDeleteProperty(exception: e));
      }
      emit(const CrudStateDisableLoading());
    });
    on<CrudEventDeleteTenant>((event, emit) async {
      emit(const CrudStateLoading(text: 'Deleting tenant'));
      try {
        await storageProvider.deleteTenant(tenantId: event.tenant.tenantId);
      } on Exception catch (e) {
        emit(CrudStateDeleteTenant(exception: e));
      }
      emit(const CrudStateDisableLoading());
    });
    on<CrudEventPropertyInfo>(
      (event, emit) {
        navigationStack.push(event);
        emit(CrudStatePropertyInfo(property: event.property));
      },
    );
    on<CrudEventMakePayment>(
      (event, emit) async {
        emit(const CrudStateLoading(text: 'Making payment...'));
        try {
          if (event.resetMoneyDue == true) {
            event.property.resetMoneyDue();
          } else {
            event.property.makePayment(amount: event.amount);
            storageProvider.createPayment(
              propertyId: event.property.propertyId,
              paymentAmount: event.amount,
              paymentMethod: event.paymentMethod,
            );
          }
          await storageProvider.updateProperty(property: event.property);
        } on Exception catch (e) {
          emit(CrudStatePropertyInfo(
            property: event.property,
            exception: e,
          ));
        }
        emit(const CrudStateDisableLoading());
      },
    );
    on<CrudEventPaymentHistory>(
      (event, emit) async {
        emit(const CrudStateLoading(text: 'Getting payment history'));
        try {
          final payments = storageProvider.paymentStream(
              propertyId: event.property.propertyId);
          navigationStack.push(event);
          emit(CrudStatePaymentHistory(payments: payments));
        } on Exception catch (e) {
          emit(CrudStatePropertyInfo(property: event.property, exception: e));
        }
      },
    );
    on<CrudEventDeletePayment>((event, emit) async {
      emit(const CrudStateLoading(text: 'Deleting payment'));
      try {
        await storageProvider.deletePayment(
            documentId: event.payment.paymentId);
      } on Exception catch (e) {
        emit(CrudStateDeletePayment(exception: e));
      }
      emit(const CrudStateDisableLoading());
    });
  }
}
