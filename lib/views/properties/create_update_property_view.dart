import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/constants/regular_expressions.dart';
import 'package:training_note_app/designs/colors/app_colors.dart';
import 'package:training_note_app/services/auth/auth_tools.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_tenant.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_bloc.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_events.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';
import 'package:training_note_app/utilities/dialogs/error_dialog.dart';
import 'package:training_note_app/utilities/navigation/navigation_utilities.dart';

import '../../services/crud_services/crud_utilities.dart';

class CreateUpdatePropertyView extends StatefulWidget {
  final CrudStateGetProperty state;
  const CreateUpdatePropertyView({super.key, required this.state});

  @override
  State<CreateUpdatePropertyView> createState() =>
      _CreateUpdatePropertyViewState();
}

class _CreateUpdatePropertyViewState extends State<CreateUpdatePropertyView> {
  late final CloudProperty? _property;
  late final List<CloudTenant> _availableTenants;
  late final TextEditingController _titleController;
  late final TextEditingController _addressController;
  late final TextEditingController _monthlyPriceController;
  late final TextEditingController _moneyDueController;
  final _mainTenant = TextEditingController();
  late final List<CloudTenant> _currentTenants;
  final List<CloudTenant> _removedTenants = [];

  final inputTextFieldBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  );
  final _updateOrCreatePropertyForm = GlobalKey<FormState>();
  @override
  void initState() {
    _mainTenant.text = 'No current tenant';
    _property = widget.state.property;
    _availableTenants = widget.state.availableTenants ?? [];
    _currentTenants = widget.state.currentTenants;
    _titleController = TextEditingController();
    _addressController = TextEditingController();
    _monthlyPriceController = TextEditingController();
    _moneyDueController = TextEditingController();
    int moneyDue = widget.state.property?.moneyDue ?? 0;
    _moneyDueController.text = moneyDue == 0
        ? '0'
        : moneyDue.toString().replaceAllMapped(reg, mathFunc);
    _titleController.text = widget.state.property?.title ?? '';
    _addressController.text = widget.state.property?.address ?? '';
    int monthlyPrice = widget.state.property?.monthlyPrice ?? 0;
    _monthlyPriceController.text = monthlyPrice == 0
        ? ''
        : monthlyPrice.toString().replaceAllMapped(reg, mathFunc);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _monthlyPriceController.dispose();
    _moneyDueController.dispose();
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
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: mainAppBarColor,
            title: Text(
              _property == null ? 'New property' : 'Edit property',
              style: TextStyle(color: mainAppTextColor),
            ),
            actions: [
              _property != null
                  ? IconButton(
                      color: mainAppIconColor,
                      onPressed: () async {
                        final deleted = await attemptPropertyDeletion(
                            context: context, property: _property!);
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
                      final property = CloudProperty(
                        propertyId: _property?.propertyId ?? '',
                        ownerUserId: user().id,
                        title: _titleController.text,
                        address: _addressController.text,
                        monthlyPrice: int.parse(_monthlyPriceController.text
                            .replaceAll(RegExp(r','), '')),
                        moneyDue: int.parse(_moneyDueController.text
                            .replaceAll(RegExp(r','), '')),
                      );
                      context
                          .read<CrudBloc>()
                          .add(CrudEventCreateOrUpdateProperty(
                            property: property,
                            context: context,
                            removedTenants: _removedTenants,
                            currentTenants: _currentTenants,
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
                      Text(
                        'Main information',
                        style: TextStyle(
                          color: mainAppTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
                        controller: _titleController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Title...',
                          labelText: 'Title',
                          border: inputTextFieldBorder,
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
                        keyboardType: TextInputType.streetAddress,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Address...',
                          labelText: 'Address',
                          border: inputTextFieldBorder,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Financial information',
                        style: TextStyle(
                          color: mainAppTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
                        controller: _monthlyPriceController,
                        keyboardType: TextInputType.number,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Monthly price...',
                          labelText: 'Monthly price',
                          border: inputTextFieldBorder,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _property != null
                          ? TextFormField(
                              validator: (value) {
                                if (_property == null) return null;
                                if (value == null || value.isEmpty) {
                                  return 'This field needs value';
                                }
                                return null;
                              },
                              controller: _moneyDueController,
                              keyboardType: TextInputType.number,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: 'Money due...',
                                labelText: 'Money due',
                                border: inputTextFieldBorder,
                                // filled: true,
                                // fillColor: mainAppTextFieldColor,
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 20),
                      Text(
                        'Tenant information',
                        style: TextStyle(
                          color: mainAppTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          Text(
                            'Current tenants',
                            style: TextStyle(
                              color: mainAppTextColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PopupMenuButton(
                            icon: Icon(
                              Icons.add,
                              color: mainAppIconColor,
                            ),
                            onSelected: (tenant) => setState(() {
                              _currentTenants.add(tenant);
                              _availableTenants.remove(tenant);
                            }),
                            itemBuilder: (context) => _availableTenants
                                .where((tenant) =>
                                    tenant.fullName != _mainTenant.text)
                                .map(
                                  (tenant) => PopupMenuItem(
                                    value: tenant,
                                    child: Text(tenant.fullName),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _currentTenants.length,
                        itemBuilder: (context, index) {
                          final tenant = _currentTenants.elementAt(index);
                          return ListTile(
                            title: Text(tenant.fullName),
                            trailing: IconButton(
                              onPressed: () => setState(
                                () {
                                  _currentTenants.remove(tenant);
                                  _availableTenants.add(tenant);
                                  if (tenant.tenantId.isNotEmpty) {
                                    _removedTenants.add(tenant);
                                  }
                                },
                              ),
                              icon: const Icon(Icons.close),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
