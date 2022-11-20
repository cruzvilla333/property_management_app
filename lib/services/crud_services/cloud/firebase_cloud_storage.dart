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
      final date = DateTime.now();
      final payment = await payments.add({
        propertyIdFieldName: propertyId,
        paymentAmountFieldName: paymentAmount,
        paymentMethodFieldName: paymentMethod,
        paymentDateFieldName: date,
      });
      final newPayment = await payment.get();
      return CloudPropertyPayment(
        paymentDate: date,
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
      properties.snapshots().map((event) => event.docs.map((doc) {
            return CloudProperty.fromSnapshot(doc);
          }).where((property) => property.ownerUserId == ownerUserId));

  Stream<Iterable<CloudPropertyPayment>> paymentStream(
          {required String propertyId}) =>
      payments.orderBy(paymentDateFieldName, descending: true).snapshots().map(
          (event) => event.docs
              .map((doc) => CloudPropertyPayment.fromSnapshot(doc))
              .where((payment) => payment.propertyId == propertyId));

  // Future<void> adjustMoneyDue({
  //   required Map<String, dynamic> data,
  //   required String propertyId,
  // }) async {
  //   final currDate = DateTime.now();
  //   final propertyDate =
  //       (data[propertyCurrentDateFieldName] as Timestamp).toDate();
  //   final months = ((currDate.year - propertyDate.year) * 12) -
  //       (propertyDate.month - currDate.month);

  //   await updatePropertyField(
  //     propertyId: propertyId,
  //     moneyDue: (data[moneyDueFieldName] as int) +
  //         ((data[monthlyPriceFieldName] as int) * months),
  //     currentDate: currDate,
  //   );
  // }
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
        propertyCurrentDateFieldName: DateTime.now(),
      });
      final newNote = await document.get();
      return CloudProperty(
        documentId: newNote.id,
        ownerUserId: ownerUserId,
        title: title,
        address: address,
        monthlyPrice: monthlyPrice,
        moneyDue: monthlyPrice,
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
