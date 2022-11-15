import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:training_note_app/services/auth/auth_bloc/auth_bloc.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';
import 'package:training_note_app/services/crud_services/cloud/firebase_cloud_storage.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_bloc.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_events.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';
import 'package:training_note_app/utilities/dialogs/error_dialog.dart';
import 'package:training_note_app/utilities/routes/app_routes.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  late final CloudProperty _property;
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _textController.dispose();
    super.dispose();
  }

  void _textControllerListener() async {
    context.read<CrudBloc>().add(CrudEventUpdateProperty(
        property: _property, text: _textController.text));
  }

  void _setUpTextControllerListener() async {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  void _deleteNoteIfTextIsEmpty() async {
    if (_textController.text.isEmpty) {
      await FirebaseCloudStorage()
          .deleteProperty(documentId: _property.documentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CrudBloc, CrudState>(
      listener: (context, state) async {
        if (state.exception != null) {
          await showErrorDialog(context, state.exception.toString());
        }
        if (state is CrudStateGetOrCreateProperty) {
          _property = state.property;
          _textController.text = state.property.title;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Testing state'),
          actions: [
            IconButton(
                onPressed: () {
                  context
                      .read<CrudBloc>()
                      .add(CrudEventDeleteProperty(property: _property));
                  context.goNamed(propertiesPage);
                },
                icon: const Icon(Icons.check)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.clear))
          ],
        ),
        body: Builder(
          builder: (context) {
            _setUpTextControllerListener();
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Start typing your notes...',
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
