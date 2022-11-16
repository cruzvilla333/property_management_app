import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';
import 'package:training_note_app/services/crud_services/cloud/firebase_cloud_storage.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_bloc.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_events.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';
import 'package:training_note_app/utilities/dialogs/error_dialog.dart';

class CreateUpdatePropertyView extends StatefulWidget {
  final CrudStateGetOrCreateProperty state;
  const CreateUpdatePropertyView({super.key, required this.state});

  @override
  State<CreateUpdatePropertyView> createState() =>
      _CreateUpdatePropertyViewState();
}

class _CreateUpdatePropertyViewState extends State<CreateUpdatePropertyView> {
  late final CloudProperty _property;
  late final TextEditingController _textController;

  @override
  void initState() {
    _property = widget.state.property;
    _textController = TextEditingController();
    _textController.text = widget.state.property.title;
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
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.state.property.title.isEmpty
              ? 'New property'
              : 'Edit property'),
          actions: [
            IconButton(
                onPressed: () {
                  context.read<CrudBloc>().add(const CrudEventInitialize());
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
