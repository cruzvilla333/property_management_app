import 'package:flutter/material.dart';
import 'package:training_note_app/constants/routes_tools.dart';
import 'package:training_note_app/services/auth/auth_tools.dart';
import 'package:training_note_app/services/cloud/cloud_note.dart';
import 'package:training_note_app/services/cloud/firebase_cloud_storage.dart';
import 'package:training_note_app/views/notes/notes_list_view.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../utilities/dialogs/log_out_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _firebaseCloudStorageService;

  @override
  void initState() {
    _firebaseCloudStorageService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your info'),
          actions: [
            IconButton(
                onPressed: () {
                  shiftPage(context: context, route: createOrUpdateNoteRoute);
                },
                icon: const Icon(Icons.add)),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogOut = await showlLogOutDialog(context);
                    if (shouldLogOut && mounted) {
                      attemptLogOut(
                        context: context,
                      );
                    }
                    break;
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                      value: MenuAction.logout, child: Text("Log out"))
                ];
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: _firebaseCloudStorageService.allNotes(ownerUserId: user().id),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes: allNotes,
                    onDeleNote: (note) async {
                      await _firebaseCloudStorageService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateNoteRoute,
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
