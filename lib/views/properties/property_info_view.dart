import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/designs/buttons/button_designs.dart';
import 'package:training_note_app/designs/colors/app_colors.dart';
import 'package:training_note_app/designs/icons/icons_designs.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_events.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';
import 'package:training_note_app/utilities/navigation/navigation_utilities.dart';

import '../../constants/regular_expressions.dart';
import '../../enums/pop_up_actions.dart';
import '../../services/crud_services/cloud/cloud_property.dart';
import '../../services/crud_services/crud_bloc/crud_bloc.dart';

class PropertyInfoView extends StatefulWidget {
  const PropertyInfoView({super.key, required this.state});
  final CrudStatePropertyInfo state;
  @override
  State<PropertyInfoView> createState() => _PropertyInfoViewState();
}

const List<Text> methods = <Text>[Text('Cash'), Text('Zelle'), Text('Check')];

class _PropertyInfoViewState extends State<PropertyInfoView> {
  final List<bool> _selectedMethod = <bool>[true, false, false];
  String _paymentMethod = methods[0].data!;
  bool vertical = false;
  late final CloudProperty _property;
  late final TextEditingController _paymentController;
  final _updateOrCreatePropertyForm = GlobalKey<FormState>();

  @override
  void initState() {
    _property = widget.state.property;
    _paymentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _paymentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CrudBloc, CrudState>(
      listener: (context, state) async {},
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: mainAppBarColor,
          leading: IconButton(
            color: mainAppIconColor,
            onPressed: () => lastPage(context: context),
            icon: backArrowIcon,
          ),
          title: Text(
            _property.title,
            style: TextStyle(color: mainAppTextColor),
          ),
          actions: [
            PopupMenuButton<PropertyInfoAction>(
              icon: Icon(
                Icons.menu,
                color: mainAppIconColor,
              ),
              onSelected: (value) async {
                switch (value) {
                  case PropertyInfoAction.paymentHistory:
                    context
                        .read<CrudBloc>()
                        .add(CrudEventPaymentHistory(property: _property));
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<PropertyInfoAction>(
                      value: PropertyInfoAction.paymentHistory,
                      child: Text("Payment history"))
                ];
              },
            )
          ],
        ),
        body: Form(
          key: _updateOrCreatePropertyForm,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  _property.address,
                  textAlign: TextAlign.right,
                  softWrap: true,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Text(
                  'Monthly price: ${_property.monthlyPrice.toString().replaceAllMapped(reg, mathFunc)}\$',
                  textAlign: TextAlign.right,
                  softWrap: true,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Text(
                  'Money due: ${_property.moneyDue.toString().replaceAllMapped(reg, mathFunc)}\$',
                  textAlign: TextAlign.right,
                  softWrap: true,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 100),
                ToggleButtons(
                  direction: vertical ? Axis.vertical : Axis.horizontal,
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < _selectedMethod.length; i++) {
                        _selectedMethod[i] = i == index;
                      }
                      _paymentMethod = methods[index].data!;
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
                  isSelected: _selectedMethod,
                  children: methods,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field needs value';
                      }
                      return null;
                    },
                    controller: _paymentController,
                    keyboardType: TextInputType.number,
                    maxLines: null,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 8.0, bottom: 8.0, top: 8.0),
                      hintText: 'Payment amount \$...',
                      labelText: 'Payment amount \$',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  style: standardButtonStyle(
                    width: 150,
                    height: 50,
                    alignment: Alignment.center,
                    backgroundColor: mainAppBackGroundColor,
                  ),
                  onPressed: () => context.read<CrudBloc>().add(
                        CrudEventMakePayment(
                            property: _property,
                            amount: int.parse(_paymentController.text
                                .replaceAll(RegExp(r','), '')),
                            paymentMethod: _paymentMethod),
                      ),
                  child: const Text(
                    'Add payment',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
