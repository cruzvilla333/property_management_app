import 'package:flutter/material.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';

import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallBack = void Function(CloudProperty note);

class PropertiesListView extends StatelessWidget {
  const PropertiesListView({
    super.key,
    required this.properties,
    required this.onDeleNote,
    required this.onTap,
  });
  final NoteCallBack onDeleNote;
  final Iterable<CloudProperty> properties;
  final NoteCallBack onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties.elementAt(index);
        return ListTile(
          onTap: () {
            onTap(property);
          },
          title: Text(
            property.title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            property.address,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleNote(property);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
