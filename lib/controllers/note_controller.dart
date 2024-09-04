import 'package:sqflite_crud/model/note_model.dart';

import '../helpers/database_helper.dart';

class NoteController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> addNote(Note note) async {
    await _dbHelper.insert(note);
  }

  Stream<List<Note>> getNotesStream() {
    return Stream.periodic(Duration(seconds: 1))
        .asyncMap((_) => _dbHelper.getNotes());
  }

  Future<void> deleteNote(int id) async {
    await _dbHelper.delete(id);
  }
}
