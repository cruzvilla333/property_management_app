import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';
import 'package:training_note_app/views/properties/properties_list_view.dart';
import 'package:training_note_app/helpers/loading/loading_overlay.dart';
import '../../enums/menu_action.dart';
import '../../services/auth/auth_bloc/auth_bloc.dart';
import '../../services/auth/auth_bloc/auth_events.dart';
import '../../services/crud_services/cloud/cloud_property.dart';
import '../../services/crud_services/crud_bloc/crud_bloc.dart';
import '../../services/crud_services/crud_bloc/crud_events.dart';
import '../../designs/colors/app_colors.dart';

class PropertiesList extends StatelessWidget {
  const PropertiesList({super.key, required this.state});
  final CrudStatePropertiesView state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainAppBackGroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(
          'Your properties',
          style: TextStyle(color: mainAppTextColor),
        ),
        actions: [
          IconButton(
              onPressed: () {
                context
                    .read<CrudBloc>()
                    .add(const CrudEventGetProperty(property: null));
              },
              icon: Icon(
                Icons.add,
                color: mainAppIconColor,
              )),
          PopupMenuButton<MenuAction>(
            icon: Icon(
              Icons.adaptive.more,
              color: mainAppIconColor,
            ),
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
        stream: state.properties,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allProperties = snapshot.data as Iterable<CloudProperty>;
                return PropertiesListView(
                  properties: allProperties,
                  onDeleteProperty: (property) => context
                      .read<CrudBloc>()
                      .add(CrudEventDeleteProperty(property: property)),
                  onEditPress: (property) => context
                      .read<CrudBloc>()
                      .add(CrudEventGetProperty(property: property)),
                  onTap: (property) {
                    return context
                        .read<CrudBloc>()
                        .add(CrudEventPropertyInfo(property: property));
                  },
                );
              } else {
                return const LoadingOverlay();
              }
            default:
              return const LoadingOverlay();
          }
        },
      ),
    );
  }
}
