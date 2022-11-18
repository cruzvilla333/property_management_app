import 'package:flutter/material.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';

import '../../constants/regular_expressions.dart';
import '../../utilities/dialogs/delete_dialog.dart';

typedef CallBack = void Function(CloudProperty note);

class PropertiesListView extends StatelessWidget {
  const PropertiesListView({
    super.key,
    required this.properties,
    required this.onDeleteNote,
    required this.onEditPress,
    required this.onTap,
  });
  final CallBack onDeleteNote;
  final Iterable<CloudProperty> properties;
  final CallBack onEditPress;
  final CallBack onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties.elementAt(index);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListTile(
            tileColor: property.moneyDue == 0
                ? Colors.green.shade200
                : Colors.red.shade200,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: property.moneyDue == 0 ? Colors.green : Colors.red,
                  width: 1),
              borderRadius: BorderRadius.circular(15),
            ),
            onTap: () => onTap(property),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title: ${property.title}',
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Address: ${property.address}',
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Monthly price: ${property.monthlyPrice.toString().replaceAllMapped(reg, mathFunc)}\$',
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Money due: ${property.moneyDue.toString().replaceAllMapped(reg, mathFunc)}\$',
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => onEditPress(property),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () async {
                    final shouldDelete =
                        await showDeletePropertyDialog(context);
                    if (shouldDelete) {
                      onDeleteNote(property);
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
