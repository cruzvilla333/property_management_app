class ClodStorageException implements Exception {
  const ClodStorageException();
}

class CouldNotCreateNoteException extends ClodStorageException {}

class CouldNotGetAllNotesException extends ClodStorageException {}

class CouldNotUpdateNoteException extends ClodStorageException {}

class CouldNotDeleteNoteException extends ClodStorageException {}
