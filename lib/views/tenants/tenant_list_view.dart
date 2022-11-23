import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_tenant.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';
import 'package:training_note_app/utilities/navigation/navigation_utilities.dart';
import 'package:training_note_app/helpers/loading/loading_overlay.dart';
import '../../enums/pop_up_actions.dart';
import '../../services/auth/auth_bloc/auth_bloc.dart';
import '../../services/auth/auth_bloc/auth_events.dart';
import '../../services/crud_services/crud_bloc/crud_bloc.dart';
import '../../services/crud_services/crud_bloc/crud_events.dart';
import '../../designs/colors/app_colors.dart';
import 'tenant_tile_list_view.dart';

class TenantListView extends StatelessWidget {
  const TenantListView({super.key, required this.state});
  final CrudStateTenantsView state;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainAppBackGroundColor,
      appBar: AppBar(
        backgroundColor: mainAppBarColor,
        title: Text(
          'Your tenants',
          style: TextStyle(color: mainAppTextColor),
        ),
        actions: [
          IconButton(
              onPressed: () {
                context
                    .read<CrudBloc>()
                    .add(const CrudEventGetTenant(tenant: null));
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
        stream: state.tenants,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allTenants = snapshot.data as Iterable<CloudTenant>;
                return TenantTileListView(
                    tenants: allTenants,
                    onTap: (tenant) {},
                    onLongPress: (tenant) => context.read<CrudBloc>().add(
                          CrudEventGetTenant(tenant: tenant),
                        ));
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
        currentIndex: 1,
        onTap: (index) => context.read<CrudBloc>().add(navigationRoute[index]!),
      ),
    );
  }
}
