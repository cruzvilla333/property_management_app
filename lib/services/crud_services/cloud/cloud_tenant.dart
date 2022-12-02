import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_storage_constants.dart';
import 'package:training_note_app/services/crud_services/cloud/firebase_cloud_storage.dart';

class CloudTenant extends FirebaseCloudObject {
  String ownerUserId;
  String tenantId;
  String propertyId;
  String firstName;
  String lastName;
  int age;
  String sex;

  CloudTenant({
    required this.tenantId,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.sex,
    required this.ownerUserId,
    this.propertyId = '',
  });

  String get fullName => '$firstName $lastName';

  CloudTenant.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : tenantId = snapshot.id,
        propertyId = snapshot.data()[propertyIdFieldName] as String,
        firstName = snapshot.data()[tenantFirstNameFieldName] as String,
        lastName = snapshot.data()[tenantLastNameFieldName] as String,
        age = snapshot.data()[ageFieldName] as int,
        sex = snapshot.data()[sexFieldName] as String,
        ownerUserId = snapshot.data()[ownerUserIdFieldName] as String;
}
