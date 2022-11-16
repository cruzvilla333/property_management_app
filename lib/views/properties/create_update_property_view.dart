import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';
import 'package:training_note_app/services/crud_services/cloud/firebase_cloud_storage.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_bloc.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_events.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';
import 'package:training_note_app/utilities/dialogs/error_dialog.dart';

class CreateUpdatePropertyView extends StatefulWidget {
  final CrudStateGetProperty state;
  const CreateUpdatePropertyView({super.key, required this.state});

  @override
  State<CreateUpdatePropertyView> createState() =>
      _CreateUpdatePropertyViewState();
}

class _CreateUpdatePropertyViewState extends State<CreateUpdatePropertyView> {
  late final CloudProperty _property;
  late final TextEditingController _titleController;
  late final TextEditingController _addressController;
  final _updateOrCreatePropertyForm = GlobalKey<FormState>();
  @override
  void initState() {
    _property = widget.state.property;
    _titleController = TextEditingController();
    _addressController = TextEditingController();
    _titleController.text = widget.state.property.title;
    _addressController.text = widget.state.property.address;
    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _titleController.dispose();
    super.dispose();
  }

  void _deleteNoteIfTextIsEmpty() async {
    if (_titleController.text.isEmpty) {
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
                  if (_updateOrCreatePropertyForm.currentState!.validate()) {
                    context
                        .read<CrudBloc>()
                        .add(CrudEventCreateOrUpdateProperty(
                          property: _property,
                          title: _titleController.text,
                          address: _addressController.text,
                        ));
                  }
                },
                icon: const Icon(Icons.check)),
            IconButton(
                onPressed: () {
                  context.read<CrudBloc>().add(const CrudEventPropertiesView());
                },
                icon: const Icon(Icons.clear))
          ],
        ),
        body: Builder(
          builder: (context) {
            return Form(
              key: _updateOrCreatePropertyForm,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field needs value';
                        }
                        return null;
                      },
                      controller: _titleController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Title...',
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field needs value';
                        }
                        return null;
                      },
                      controller: _addressController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Address...',
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
