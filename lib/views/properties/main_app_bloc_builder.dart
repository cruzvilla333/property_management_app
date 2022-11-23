import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/auth/auth_tools.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_bloc.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_events.dart';
import 'package:training_note_app/utilities/dialogs/error_dialog.dart';
import 'package:training_note_app/utilities/navigation/navigation_utilities.dart';
import 'package:training_note_app/utilities/routes/auth_route_handling.dart';
import 'package:training_note_app/views/properties/create_update_property_view.dart';
import 'package:training_note_app/views/tenants/create_update_tenant_view.dart';
import 'package:training_note_app/views/tenants/tenant_list_view.dart';
import '../../services/auth/auth_bloc/auth_bloc.dart';
import '../../services/auth/auth_bloc/auth_states.dart';
import '../../services/crud_services/crud_bloc/crud_states.dart';
import '../../utilities/dialogs/loading_functions.dart';
import '../../utilities/dialogs/log_out_dialog.dart';
import 'property_list_view.dart';
import 'property_info_view.dart';
import 'property_payments_view.dart';

class PropertiesViewBuilder extends StatefulWidget {
  const PropertiesViewBuilder({super.key});

  @override
  State<PropertiesViewBuilder> createState() => _PropertiesViewBuilderState();
}

class _PropertiesViewBuilderState extends State<PropertiesViewBuilder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<CrudBloc>().add(const CrudEventPropertiesView());
    return MultiBlocListener(
      listeners: [
        BlocListener<CrudBloc, CrudState>(
          listener: (context, state) {
            if (state.exception != null) {
              showErrorDialog(context, state.exception.toString());
            } else {
              handleLoading(context: context, state: state);
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            handleLoading(context: context, state: state);
            if (state is AuthStateShowLogOut) {
              final shouldLogOut = await showlLogOutDialog(context);
              if (shouldLogOut) {
                attemptLogOut(context: context);
              }
            }
            handleAuthRouting(context: context, state: state);
          },
        ),
      ],
      child: BlocBuilder<CrudBloc, CrudState>(
        builder: (context, state) {
          if (state is CrudStateDisableLoading) {
            currentPage(context: context);
          }
          if (state is CrudStatePropertiesView) {
            return AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: PropertyListView(
                state: state,
              ),
            );
          }
          if (state is CrudStateGetProperty) {
            return CreateUpdatePropertyView(
              state: state,
            );
          }
          if (state is CrudStateGetTenant) {
            return CreateUpdateTenantView(
              state: state,
            );
          }
          if (state is CrudStatePropertyInfo) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: PropertyInfoView(
                key: const Key('1'),
                state: state,
              ),
              // transitionBuilder: (child, animation) => SizeTransition(
              //   sizeFactor: animation,
              // ),
            );
          }
          if (state is CrudStatePaymentHistory) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: PropertyPaymentsView(
                key: const Key('1'),
                state: state,
              ),
              // transitionBuilder: (child, animation) =>
              //     ScaleTransition(scale: animation),
            );
          }
          if (state is CrudStateTenantsView) {
            return TenantListView(state: state);
          }
          return const Scaffold();
        },
      ),
    );
  }
}
