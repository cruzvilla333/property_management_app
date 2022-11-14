import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/auth/auth_tools.dart';
import 'package:training_note_app/services/auth/auth_bloc/auth_events.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_note.dart';
import 'package:training_note_app/services/crud_services/cloud/firebase_cloud_storage.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_bloc.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_events.dart';
import 'package:training_note_app/utilities/routes/auth_route_handling.dart';
import 'package:training_note_app/utilities/routes/crud_route_handling.dart';
import 'package:training_note_app/views/notes/properties_list_view.dart';
import '../../enums/menu_action.dart';
import '../../services/auth/auth_bloc/auth_bloc.dart';
import '../../services/auth/auth_bloc/auth_states.dart';
import '../../services/crud_services/crud_bloc/crud_states.dart';
import '../../utilities/dialogs/loading_functions.dart';
import '../../utilities/dialogs/log_out_dialog.dart';

class PropertiesView extends StatefulWidget {
  const PropertiesView({super.key});

  @override
  State<PropertiesView> createState() => _PropertiesViewState();
}

class _PropertiesViewState extends State<PropertiesView> {
  late final FirebaseCloudStorage _firebaseCloudStorageService;

  @override
  void initState() {
    _firebaseCloudStorageService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CrudBloc, CrudState>(
          listener: (context, state) {
            handleLoading(context: context, state: state);
            handleCrudRouting(context: context, state: state);
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            handleLoading(context: context, state: state);
            if (state is AuthStateShowLogOut) {
              final shouldLogOut = await showlLogOutDialog(context);
              if (shouldLogOut) {
                attemptLogOut(context: context);
              }
            }
            handleAuthRouting(context: context, state: state);
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your properties'),
          actions: [
            IconButton(
                onPressed: () {
                  context
                      .read<CrudBloc>()
                      .add(const CrudEventGetOrCreateProperty(property: null));
                },
                icon: const Icon(Icons.add)),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    context.read<AuthBloc>().add(const AuthEventShowLogOut());
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
                  return PropertiesListView(
                    notes: allNotes,
                    onDeleNote: (note) async {
                      await _firebaseCloudStorageService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) {
                      // Navigator.of(context).pushNamed(
                      //   createOrUpdateNoteRoute,
                      //   arguments: note,
                      // );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
