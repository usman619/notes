import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:notes/services/crud/crud_exceptions.dart';

class NotesService {
  Database? _db;

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);

    final updatesCount = await db.update(noteTable, {
      textColumn: text,
      isSynchedWithCloudColumn: 0,
    });

    if (updatesCount == 0) {
      throw CouldNoteUpdateNote();
    } else {
      return await getNote(id: note.id);
    }
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);

    return notes.map((noteRow) => DatabaseNote.fromMap(noteRow));
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      return DatabaseNote.fromMap(notes.first);
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deleteCount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();

    // Making sure owner exists in the database with the correct id
    final dbUser = getUser(email: owner.emaill);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }

    const text = '';
    // Creating the note
    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSynchedWithCloudColumn: 1,
    });

    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSynchedWithCloud: true,
    );

    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      userTable,
      limit: 1,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromMap(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isNotEmpty) {
      throw UserAlreadyExists;
    }

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(
      id: userId,
      emaill: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
    final _db = _getDatabaseOrThrow();
    final deletedCount = await _db.delete(
      userTable,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (deletedCount != 1) {
      throw CouldNotDeleteUser;
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpen();
    }
    await _db!.close();
    _db = null;
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseIsAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      // Create user and note tables if they don't exist
      await db.execute(createUserTable);
      await db.execute(createNotesTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String emaill;

  const DatabaseUser({
    required this.id,
    required this.emaill,
  });

  DatabaseUser.fromMap(Map<String, dynamic> map)
      : id = map[idColumn] as int,
        emaill = map[emailColumn] as String;
  @override
  String toString() => 'DatabaseUser(id: $id, emaill: $emaill)';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSynchedWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSynchedWithCloud,
  });

  DatabaseNote.fromMap(Map<String, dynamic> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSynchedWithCloud =
            (map[isSynchedWithCloudColumn]) == 1 ? true : false;

  @override
  String toString() =>
      'DatabaseNote(id: $id, userId: $userId, isSynchedWithCloud: $isSynchedWithCloud, text: $text)';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const userTable = 'user';
const noteTable = 'note';
const idColumn = 'id';
const userIdColumn = 'userId';
const emailColumn = 'emaill';
const textColumn = 'text';
const isSynchedWithCloudColumn = 'isSynchedWithCloud';

const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
          "id"	INTEGER NOT NULL,
          "email"	TEXT NOT NULL UNIQUE,
          PRIMARY KEY("id" AUTOINCREMENT)
        );''';

const createNotesTable = '''CREATE TABLE IT NOT EXISTS "note" (
          "id"	INTEGER NOT NULL,
          "user_id"	INTEGER NOT NULL,
          "text"	TEXT,
          "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
          PRIMARY KEY("id" AUTOINCREMENT),
          FOREIGN KEY("user_id") REFERENCES "user"("id")
        );''';
