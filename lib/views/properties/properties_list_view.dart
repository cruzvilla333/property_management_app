import 'package:flutter/material.dart';

import 'package:training_note_app/designs/colors/app_colors.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';

import '../../constants/regular_expressions.dart';
import '../../enums/menu_action.dart';

typedef CallBack = void Function(CloudProperty note);

class PropertiesListView extends StatelessWidget {
  const PropertiesListView({
    super.key,
    required this.properties,
    required this.onDeleteProperty,
    required this.onEditPress,
    required this.onTap,
  });
  final CallBack onDeleteProperty;
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
              // onLongPress: () {
              //   final box = context.findRenderObject() as RenderSliverList;
              //   final bounds = box.paintBounds;
              //   final size = box.getAbsoluteSizeRelativeToOrigin();
              //   showMenu(
              //       context: context,
              //       position: RelativeRect.fromSize(bounds, size),
              //       items: [
              //         PopupMenuItem<PropertyAction>(
              //             onTap: () => context
              //                 .read<CrudBloc>()
              //                 .add(CrudEventDeleteProperty(property: property)),
              //             value: PropertyAction.delete,
              //             child: const Text("Delete")),
              //         PopupMenuItem<PropertyAction>(
              //             onTap: () => context.read<CrudBloc>().add(
              //                 CrudEventCreateOrUpdateProperty(
              //                     property: property)),
              //             value: PropertyAction.delete,
              //             child: const Text("Edit")),
              //       ]);
              // },
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
                      style: TextStyle(
                        color: mainAppTextColor,
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
                      style: TextStyle(
                        fontSize: 17,
                        color: mainAppTextColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        text: 'Monthly price: ',
                        style: TextStyle(fontSize: 17, color: mainAppTextColor),
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
                        style: TextStyle(fontSize: 17, color: mainAppTextColor),
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
              trailing: PopupMenuButton<PropertyAction>(
                icon: Icon(
                  Icons.adaptive.more,
                  color: mainAppIconColor,
                ),
                onSelected: (value) async {
                  switch (value) {
                    case PropertyAction.delete:
                      onDeleteProperty(property);
                      break;
                    case PropertyAction.edit:
                      onEditPress(property);
                  }
                },
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem<PropertyAction>(
                        value: PropertyAction.delete, child: Text("Delete")),
                    PopupMenuItem<PropertyAction>(
                        value: PropertyAction.edit, child: Text("Edit"))
                  ];
                },
              )),
        );
      },
    );
  }
}
