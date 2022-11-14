class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateNoteException extends CloudStorageException {
  @override
  String toString() {
    return 'Could not create property';
  }
}

class CouldNotGetAllNotesException extends CloudStorageException {
  @override
  String toString() {
    return 'Could not get all properties';
  }
}

class CouldNotUpdateNoteException extends CloudStorageException {
  @override
  String toString() {
    return 'Could not update property';
  }
}

class CouldNotDeleteNoteException extends CloudStorageException {
  @override
  String toString() {
    return 'Could not delete property';
  }
}

class CouldNotFindNoteExcepiton extends CloudStorageException {
  @override
  String toString() {
    return 'Could not find property';
  }
}

class CouldNotDelteAllNotesException extends CloudStorageException {
  @override
  String toString() {
    return 'Could not delete all properties';
  }
}
