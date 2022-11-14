import 'package:flutter/material.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_note.dart';

import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallBack = void Function(CloudNote note);

class PropertiesListView extends StatelessWidget {
  const PropertiesListView({
    super.key,
    required this.notes,
    required this.onDeleNote,
    required this.onTap,
  });
  final NoteCallBack onDeleNote;
  final Iterable<CloudNote> notes;
  final NoteCallBack onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return ListTile(
          onTap: () {
            onTap(note);
          },
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: note.text.isEmpty
              ? null
              : IconButton(
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
