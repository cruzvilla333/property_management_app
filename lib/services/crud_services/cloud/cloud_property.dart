import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_storage_constants.dart';
import 'package:flutter/cupertino.dart';

@immutable
class CloudProperty {
  final String documentId;
  final String ownerUserId;
  final String title;
  final String address;

  const CloudProperty({
    required this.documentId,
    required this.ownerUserId,
    required this.title,
    required this.address,
  });

  CloudProperty.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        title = snapshot.data()[titleFieldName] as String,
        address = snapshot.data()[addressFieldName] as String;
}
