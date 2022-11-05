import 'package:flutter/material.dart';
import 'package:training_note_app/services/auth/auth_service.dart';
import '../constants/routes.dart';
import '../enums/menu_action.dart';
import '../utilities/show_log_out_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut = await showlLogOutDialog(context);
                  if (shouldLogOut) {
                    await AuthService.firebase().logOut();
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    }
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
      body: const Text("Hello world"),
    );
  }
}
