import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_note.dart';
import 'package:training_note_app/services/crud_services/cloud/firebase_cloud_storage.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_bloc.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_events.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';
import 'package:training_note_app/utilities/dialogs/error_dialog.dart';

class CreateUpdatePropertyView extends StatefulWidget {
  const CreateUpdatePropertyView({super.key});

  @override
  State<CreateUpdatePropertyView> createState() =>
      _CreateUpdatePropertyViewState();
}

class _CreateUpdatePropertyViewState extends State<CreateUpdatePropertyView> {
  late final CloudNote _property;
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
      await FirebaseCloudStorage().deleteNote(documentId: _property.documentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CrudBloc, CrudState>(
      listener: (context, state) async {
        if (state.exception != null) {
          await showErrorDialog(context, state.exception.toString());
        }
      },
      builder: (context, state) {
        if (state is CrudStateGetOrCreateProperty) {
          _property = state.property;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(state is CrudStateGetOrCreateProperty
                ? state.property.text.isEmpty
                    ? 'New property'
                    : 'Edit property'
                : 'Error state'),
          ),
          body: Builder(
            builder: (context) {
              _setUpTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Start typing your notes...',
                ),
              );
            },
          ),
        );
      },
    );
  }
}
