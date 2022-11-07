import 'package:flutter/material.dart';
import 'package:training_note_app/services/crud/notes_service.dart';

import '../../utilities/dialogs/delete_dialog.dart';

typedef DeleteNoteCallBack = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleNote,
  });
  final DeleteNoteCallBack onDeleNote;
  final List<DatabaseNote> notes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleNote(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
