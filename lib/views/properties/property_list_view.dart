import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';
import 'package:training_note_app/utilities/navigation/navigation_utilities.dart';
import 'package:training_note_app/views/properties/property_tile_list_view.dart';
import 'package:training_note_app/helpers/loading/loading_overlay.dart';
import '../../enums/pop_up_actions.dart';
import '../../services/auth/auth_bloc/auth_bloc.dart';
import '../../services/auth/auth_bloc/auth_events.dart';
import '../../services/crud_services/cloud/cloud_property.dart';
import '../../services/crud_services/crud_bloc/crud_bloc.dart';
import '../../services/crud_services/crud_bloc/crud_events.dart';
import '../../designs/colors/app_colors.dart';

class PropertyListView extends StatelessWidget {
  const PropertyListView({super.key, required this.state});
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
                return PropertyTileListView(
                  properties: allProperties,
                  onTap: (property) => context
                      .read<CrudBloc>()
                      .add(CrudEventPropertyInfo(property: property)),
                  onLongPress: (property) => context
                      .read<CrudBloc>()
                      .add(CrudEventGetProperty(property: property)),
                );
              } else {
                return const LoadingOverlay();
              }
            default:
              return const LoadingOverlay();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.house), label: 'properties'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'tenants'),
        ],
        currentIndex: 0,
        onTap: (index) => context.read<CrudBloc>().add(navigationRoute[index]!),
      ),
    );
  }
}
