import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_note.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_storage_constants.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection(notesDocument);

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> deleteAllNotes({required String ownerUserId}) async {
    try {
      await notes.doc(ownerUserId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  Future<CloudNote> getNote({
    required String documentId,
  }) async {
    try {
      final note = await notes.doc(documentId).get();
      final owner = note.data()!;
      return CloudNote(
        documentId: note.id,
        ownerUserId: owner[ownerUserIdFieldName],
        text: owner[textFieldName],
      );
    } catch (e) {
      throw CouldNotFindNoteExcepiton();
    }
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
              (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNote({required String ownerUserId}) async {
    try {
      final document = await notes.add({
        ownerUserIdFieldName: ownerUserId,
        textFieldName: '',
      });
      final newNote = await document.get();
      return CloudNote(
        documentId: newNote.id,
        ownerUserId: ownerUserId,
        text: '',
      );
    } catch (e) {
      throw CouldNotCreateNoteException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;
}