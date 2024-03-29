import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/designs/colors/app_colors.dart';
import 'package:training_note_app/services/auth/auth_tools.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_tenant.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_bloc.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_events.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';
import 'package:training_note_app/services/crud_services/crud_utilities.dart';
import 'package:training_note_app/utilities/dialogs/error_dialog.dart';
import 'package:training_note_app/utilities/navigation/navigation_utilities.dart';

class CreateUpdateTenantView extends StatefulWidget {
  final CrudStateGetTenant state;
  const CreateUpdateTenantView({super.key, required this.state});

  @override
  State<CreateUpdateTenantView> createState() => _CreateUpdateTenantViewState();
}

const List<Text> sexes = <Text>[Text('male'), Text('female')];

class _CreateUpdateTenantViewState extends State<CreateUpdateTenantView> {
  List<bool> _possibleSexes = <bool>[true, false];
  String _selectedSex = sexes[0].data!;
  late final CloudTenant? _tenant;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _ageController;
  late final TextEditingController _sexController;
  final _updateOrCreatePropertyForm = GlobalKey<FormState>();
  @override
  void initState() {
    _tenant = widget.state.tenant;
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _ageController = TextEditingController();
    _sexController = TextEditingController();
    int age = widget.state.tenant?.age ?? 0;
    _ageController.text = age == 0 ? '' : age.toString();
    _firstNameController.text = widget.state.tenant?.firstName ?? '';
    _lastNameController.text = widget.state.tenant?.lastName ?? '';
    _sexController.text = widget.state.tenant?.sex ?? '';
    String currentSex = widget.state.tenant?.sex ?? 'male';
    _possibleSexes =
        currentSex == 'male' ? <bool>[true, false] : <bool>[false, true];
    _selectedSex = widget.state.tenant?.sex ?? 'male';
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _sexController.dispose();
    super.dispose();
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
          backgroundColor: mainAppBarColor,
          title: Text(
            _tenant == null ? 'New tenant' : 'Edit tenant',
            style: TextStyle(color: mainAppTextColor),
          ),
          actions: [
            _tenant != null
                ? IconButton(
                    color: mainAppIconColor,
                    onPressed: () async {
                      final deleted = await attemptTenantDeletion(
                          context: context, tenant: _tenant!);
                      if (deleted == true) {
                        lastPage(context: context);
                      }
                    },
                    icon: const Icon(Icons.delete))
                : const SizedBox(height: 0, width: 0),
            IconButton(
                color: mainAppIconColor,
                onPressed: () {
                  if (_updateOrCreatePropertyForm.currentState!.validate()) {
                    final tenant = CloudTenant(
                      tenantId: _tenant?.tenantId ?? '',
                      ownerUserId: user().id,
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      age: int.parse(_ageController.text),
                      sex: _selectedSex,
                    );
                    context.read<CrudBloc>().add(CrudEventCreateOrUpdateTenant(
                          tenant: tenant,
                        ));
                    lastPage(context: context);
                  }
                },
                icon: const Icon(Icons.check)),
            IconButton(
                color: mainAppIconColor,
                onPressed: () => lastPage(context: context),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field needs value';
                        }
                        return null;
                      },
                      controller: _firstNameController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'First name...',
                        labelText: 'First name',
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
                      controller: _lastNameController,
                      keyboardType: TextInputType.streetAddress,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Last name...',
                        labelText: 'Last name',
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
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Age...',
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ToggleButtons(
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < _possibleSexes.length; i++) {
                            _possibleSexes[i] = i == index;
                          }
                          _selectedSex = sexes[index].data!;
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: Colors.red,
                      selectedColor: Colors.black,
                      fillColor: Colors.white,
                      color: mainAppTextColor,
                      constraints: const BoxConstraints(
                        minHeight: 40.0,
                        minWidth: 80.0,
                      ),
                      isSelected: _possibleSexes,
                      children: sexes,
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
