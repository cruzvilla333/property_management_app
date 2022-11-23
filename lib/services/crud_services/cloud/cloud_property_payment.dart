import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_storage_constants.dart';
import 'package:training_note_app/services/crud_services/cloud/firebase_cloud_storage.dart';

class CloudPropertyPayment extends FirebaseCloudObject {
  String documentId;
  String propertyId;
  int paymentAmount;
  String paymentMethod;
  DateTime paymentDate;

  CloudPropertyPayment({
    required this.paymentAmount,
    required this.paymentMethod,
    required this.documentId,
    required this.propertyId,
    required this.paymentDate,
  });

  CloudPropertyPayment.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        propertyId = snapshot.data()[propertyIdFieldName] as String,
        paymentAmount = snapshot.data()[paymentAmountFieldName] as int,
        paymentMethod = snapshot.data()[paymentMethodFieldName] as String,
        paymentDate =
            (snapshot.data()[paymentDateFieldName] as Timestamp).toDate();
}
