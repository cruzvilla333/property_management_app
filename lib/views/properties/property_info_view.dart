import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_events.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';
import 'package:training_note_app/utilities/navigation/navigation_utilities.dart';

import '../../constants/regular_expressions.dart';
import '../../services/crud_services/cloud/cloud_property.dart';
import '../../services/crud_services/crud_bloc/crud_bloc.dart';
import '../../utilities/dialogs/error_dialog.dart';

class PropertyInfoView extends StatefulWidget {
  const PropertyInfoView({super.key, required this.state});
  final CrudStatePropertyInfo state;
  @override
  State<PropertyInfoView> createState() => _PropertyInfoViewState();
}

const List<Text> fruits = <Text>[Text('Cash'), Text('Zelle'), Text('Check')];

class _PropertyInfoViewState extends State<PropertyInfoView> {
  final List<bool> _selectedFruits = <bool>[true, false, false];
  String _paymentMethod = fruits[0].data!;
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
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => lastPage(context: context),
              icon: const Icon(Icons.arrow_back)),
          title: Text(widget.state.property.title),
        ),
        body: Form(
          key: _updateOrCreatePropertyForm,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Address: ${_property.address}',
                  textAlign: TextAlign.right,
                  softWrap: true,
                ),
                const SizedBox(height: 20),
                Text(
                  'Monthly price: ${_property.monthlyPrice.toString().replaceAllMapped(reg, mathFunc)}\$',
                  textAlign: TextAlign.right,
                  softWrap: true,
                ),
                const SizedBox(height: 20),
                Text(
                  'Money due: ${_property.moneyDue.toString().replaceAllMapped(reg, mathFunc)}\$',
                  textAlign: TextAlign.right,
                  softWrap: true,
                ),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () => context
                        .read<CrudBloc>()
                        .add(CrudEventPaymentHistory(property: _property)),
                    child: const Text('Payment history')),
                const SizedBox(height: 20),
                ToggleButtons(
                  direction: vertical ? Axis.vertical : Axis.horizontal,
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < _selectedFruits.length; i++) {
                        _selectedFruits[i] = i == index;
                        _paymentMethod = fruits[i].data!;
                      }
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.red[700],
                  selectedColor: Colors.white,
                  fillColor: Colors.red[200],
                  color: Colors.red[400],
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 80.0,
                  ),
                  isSelected: _selectedFruits,
                  children: fruits,
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
                TextButton(
                  onPressed: () => context.read<CrudBloc>().add(
                        CrudEventMakePayment(
                            property: _property,
                            amount: int.parse(_paymentController.text
                                .replaceAll(RegExp(r','), '')),
                            paymentMethod: _paymentMethod),
                      ),
                  child: const Text(
                    'Make payment',
                    style: TextStyle(fontSize: 20),
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
