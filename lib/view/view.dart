import 'package:flutter/material.dart';
import 'package:sqflite_crud/controllers/note_controller.dart';
import 'package:sqflite_crud/model/note_model.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final NoteController _noteController = NoteController();

  Future<void> _addNote() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty)
      return;

    final note = Note(
      title: _titleController.text,
      content: _contentController.text,
    );

    await _noteController.addNote(note);

    _titleController.clear();
    _contentController.clear();
  }

  Future<void> _deleteNote(int id) async {
    await _noteController.deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: StreamBuilder<List<Note>>(
        stream: _noteController.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notes found.'));
          }

          final notes = snapshot.data!;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteNote(note.id!),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add Note'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(labelText: 'Content'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addNote();
                  },
                  child: Text('Add'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
