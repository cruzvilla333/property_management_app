import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property_payment.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_storage_constants.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_storage_exceptions.dart';
import 'package:training_note_app/services/crud_services/cloud/crud_creations.dart';

import 'cloud_tenant.dart';

abstract class FirebaseCloudObject {
  const FirebaseCloudObject();
}

class FirebaseCloudStorage {
  final collections = FirebaseFirestore.instance;
  late final payments = collections.collection(paymentsCollection);
  late final properties = collections.collection(propertiesCollection);
  late final tenants = collections.collection(tenantsCollection);

  Future<void> deleteTenant({required String tenantId}) async {
    try {
      await tenants.doc(tenantId).delete();
    } catch (e) {
      throw CouldNotDeleteTenantException();
    }
  }

  Future<void> updateTenant({required CloudTenant tenant}) async {
    try {
      tenants.doc(tenant.tenantId).update({
        tenantFirstNameFieldName: tenant.firstName,
        tenantLastNameFieldName: tenant.lastName,
        sexFieldName: tenant.sex,
        ageFieldName: tenant.age,
        propertyIdFieldName: tenant.propertyId,
      });
    } catch (e) {
      throw CouldNotUpdateTenantException();
    }
  }

  Future<CloudTenant> createTenant({
    required String firstName,
    required String lastName,
    required int age,
    required String sex,
    required String ownerUserId,
    propertyId = '',
  }) async {
    return await tryCreateTenant(
        ownerUserId: ownerUserId,
        tenants: tenants,
        firstName: firstName,
        lastName: lastName,
        age: age,
        sex: sex);
  }

  Future<Iterable<CloudTenant>> getPropertyTenants({
    required String propertyId,
  }) async {
    try {
      return await tenants
          .where(
            propertyIdFieldName,
            isEqualTo: propertyId,
          )
          .get()
          .then((value) =>
              value.docs.map((doc) => CloudTenant.fromSnapshot(doc)));
    } catch (e) {
      throw CouldNotGetAllTenantsException();
    }
  }

  Future<void> deleteProperty({required String documentId}) async {
    try {
      await properties.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeletePropertyException();
    }
  }

  Future<void> deletePayment({required String documentId}) async {
    try {
      await payments.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeletePaymentException();
    }
  }

  Future<CloudPropertyPayment> createPayment({
    required String propertyId,
    required int paymentAmount,
    required String paymentMethod,
  }) async {
    return await tryCreatePayment(
        payments: payments,
        propertyId: propertyId,
        paymentAmount: paymentAmount,
        paymentMethod: paymentMethod);
  }

  Future<Iterable<CloudPropertyPayment>> getPropertyPayments({
    required String propertyId,
  }) async {
    try {
      return await payments
          .where(
            propertyIdFieldName,
            isEqualTo: propertyId,
          )
          .get()
          .then((value) =>
              value.docs.map((doc) => CloudPropertyPayment.fromSnapshot(doc)));
    } catch (e) {
      throw CouldNotGetAllPaymentsException();
    }
  }

  Future<void> deleteAllProperties({required String ownerUserId}) async {
    try {
      await properties.doc(ownerUserId).delete();
    } catch (e) {
      throw CouldNotDeletePropertyException();
    }
  }

  Future<void> deleteAllPayments({required String propertyId}) async {
    try {
      await payments.get().then((value) async {
        for (var document in value.docs) {
          await payments.doc(document.id).delete();
        }
      });
    } catch (e) {
      throw CouldNotDeletePaymentException();
    }
  }

  Future<void> updateProperty({required CloudProperty property}) async {
    try {
      properties.doc(property.documentId).update({
        titleFieldName: property.title,
        addressFieldName: property.address,
        monthlyPriceFieldName: property.monthlyPrice,
        moneyDueFieldName: property.moneyDue,
      });
    } catch (e) {
      throw CouldNotUpdatePropertyException();
    }
  }

  Future<void> updatePropertyField(
      {required String propertyId,
      int? monthlyPrice,
      String? title,
      String? address,
      int? moneyDue,
      DateTime? currentDate}) async {
    try {
      if (title != null) {
        properties.doc(propertyId).update({titleFieldName: title});
      }
      if (address != null) {
        properties.doc(propertyId).update({addressFieldName: address});
      }
      if (monthlyPrice != null) {
        properties
            .doc(propertyId)
            .update({monthlyPriceFieldName: monthlyPrice});
      }
      if (moneyDue != null) {
        properties.doc(propertyId).update({moneyDueFieldName: moneyDue});
      }
      if (currentDate != null) {
        properties
            .doc(propertyId)
            .update({propertyCurrentDateFieldName: currentDate});
      }
    } catch (e) {
      throw CouldNotUpdatePropertyException();
    }
  }

  Stream<Iterable<CloudProperty>> propertyStream(
          {required String ownerUserId}) =>
      properties
          .orderBy(moneyDueFieldName, descending: true)
          .snapshots()
          .map((event) => event.docs.map((doc) {
                return CloudProperty.fromSnapshot(doc);
              }).where((property) => property.ownerUserId == ownerUserId));

  Stream<Iterable<CloudTenant>> tenantStream({required String ownerUserId}) =>
      tenants
          .orderBy(tenantFirstNameFieldName, descending: true)
          .snapshots()
          .map((event) => event.docs.map((doc) {
                return CloudTenant.fromSnapshot(doc);
              }).where((tenant) => tenant.ownerUserId == ownerUserId));

  Stream<Iterable<CloudPropertyPayment>> paymentStream(
          {required String propertyId}) =>
      payments.orderBy(paymentDateFieldName, descending: true).snapshots().map(
          (event) => event.docs
              .map((doc) => CloudPropertyPayment.fromSnapshot(doc))
              .where((payment) => payment.propertyId == propertyId));

  Future<void> adjustMoneyDue({
    required CloudProperty property,
  }) async {
    final currDate = DateTime.now();
    final propertyDate = property.currentDate!;
    final months = ((currDate.year - propertyDate.year) * 12) -
        (propertyDate.month - currDate.month);

    if (months > 0) {
      await updatePropertyField(
        propertyId: property.documentId,
        moneyDue: property.moneyDue + (property.monthlyPrice * months),
        currentDate: currDate,
      );
    }
  }

  Future<CloudProperty> getProperty({
    required String documentId,
  }) async {
    try {
      final property = await properties.doc(documentId).get();
      final owner = property.data()!;
      return CloudProperty(
        documentId: property.id,
        ownerUserId: owner[ownerUserIdFieldName],
        title: owner[titleFieldName],
        address: owner[addressFieldName],
        monthlyPrice: owner[monthlyPriceFieldName],
        moneyDue: owner[moneyDueFieldName],
      );
    } catch (e) {
      throw CouldNotFindPropertyExcepiton();
    }
  }

  Future<Iterable<CloudProperty>> getProperties(
      {required String ownerUserId}) async {
    try {
      return await properties
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then((value) =>
              value.docs.map((doc) => CloudProperty.fromSnapshot(doc)));
    } catch (e) {
      throw CouldNotGetAllPropertiesException();
    }
  }

  Future<CloudProperty> createProperty({
    required String ownerUserId,
    required String title,
    required String address,
    required int monthlyPrice,
  }) async {
    return await tryCreateProperty(
        properties: properties,
        ownerUserId: ownerUserId,
        title: title,
        address: address,
        monthlyPrice: monthlyPrice);
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;
}
