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
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onTap: () => onTap(property),
            title: SizedBox(
              height: 130,
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    property.address,
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Monthly price: ',
                      style: const TextStyle(fontSize: 17, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                '${property.monthlyPrice.toString().replaceAllMapped(reg, mathFunc)}\$',
                            style: const TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(218, 70, 117, 228))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Money due: ',
                      style: const TextStyle(fontSize: 17, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                '${property.moneyDue.toString().replaceAllMapped(reg, mathFunc)}\$',
                            style: TextStyle(
                                fontSize: 17,
                                color: property.moneyDue > 0
                                    ? Colors.red
                                    : Colors.green)),
                      ],
                    ),
                  )
                ],
              ),
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
