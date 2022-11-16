import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_storage_constants.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final collections = FirebaseFirestore.instance;
  late final properties = collections.collection(propertiesDocument);

  Future<void> deleteProperty({required String documentId}) async {
    try {
      await properties.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeletePropertyException();
    }
  }

  Future<void> deleteAllProperties({required String ownerUserId}) async {
    try {
      await properties.doc(ownerUserId).delete();
    } catch (e) {
      throw CouldNotDeletePropertyException();
    }
  }

  Future<void> updateProperty({
    required String documentId,
    required String title,
    required String address,
  }) async {
    try {
      properties.doc(documentId).update({
        titleFieldName: title,
        addressFieldName: address,
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

  Future<CloudProperty> createProperty({required String ownerUserId}) async {
    try {
      final document = await properties.add({
        ownerUserIdFieldName: ownerUserId,
        titleFieldName: '',
        addressFieldName: '',
      });
      final newNote = await document.get();
      return CloudProperty(
        documentId: newNote.id,
        ownerUserId: ownerUserId,
        title: '',
        address: '',
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
