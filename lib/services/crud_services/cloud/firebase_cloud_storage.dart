import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property_payment.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_storage_constants.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final collections = FirebaseFirestore.instance;
  late final payments = collections.collection(paymentsCollection);
  late final properties = collections.collection(propertiesCollection);

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
    try {
      final payment = await payments.add({
        propertyIdFieldName: propertyId,
        paymentAmountFieldName: paymentAmount,
        paymentMethodFieldName: paymentMethod,
      });
      final newPayment = await payment.get();
      return CloudPropertyPayment(
        documentId: newPayment.id,
        propertyId: propertyId,
        paymentAmount: paymentAmount,
        paymentMethod: paymentMethod,
      );
    } catch (e) {
      throw CouldNotCreatePaymentException();
    }
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

  Stream<Iterable<CloudProperty>> allProperties(
          {required String ownerUserId}) =>
      properties.snapshots().map((event) => event.docs
          .map((doc) => CloudProperty.fromSnapshot(doc))
          .where((property) => property.ownerUserId == ownerUserId));

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

  // Future<CloudProperty> createEmptyProperty(
  //     {required String ownerUserId}) async {
  //   try {
  //     final document = await properties.add({
  //       ownerUserIdFieldName: ownerUserId,
  //       titleFieldName: '',
  //       addressFieldName: '',
  //       monthlyPriceFieldName: 0,
  //       moneyDueFieldName: 0,
  //     });
  //     final newProperty = await document.get();
  //     return CloudProperty(
  //       documentId: newProperty.id,
  //       ownerUserId: ownerUserId,
  //       title: '',
  //       address: '',
  //       monthlyPrice: 0,
  //     );
  //   } catch (e) {
  //     throw CouldNotCreatePropertyException();
  //   }
  // }

  Future<CloudProperty> createProperty({
    required String ownerUserId,
    required String title,
    required String address,
    required int monthlyPrice,
  }) async {
    try {
      final document = await properties.add({
        ownerUserIdFieldName: ownerUserId,
        titleFieldName: title,
        addressFieldName: address,
        monthlyPriceFieldName: monthlyPrice,
        moneyDueFieldName: monthlyPrice,
      });
      final newNote = await document.get();
      return CloudProperty(
        documentId: newNote.id,
        ownerUserId: ownerUserId,
        title: title,
        address: address,
        monthlyPrice: monthlyPrice,
      );
    } catch (e) {
      throw CouldNotCreatePropertyException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;
}
