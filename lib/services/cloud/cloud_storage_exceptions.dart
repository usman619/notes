class CloudStorageException implements Exception {
  const CloudStorageException();
}

//CRUD Exceptions for Firestore
class CouldNotCreateNoteException extends CloudStorageException {}

class CouldNotGetAllNotesException extends CloudStorageException {}

class CouldNotUpdateNoteException extends CloudStorageException {}

class CouldNotDeleteNoteException extends CloudStorageException {}
