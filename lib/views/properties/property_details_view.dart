import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/constants/regular_expressions.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_bloc.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_events.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';
import 'package:training_note_app/utilities/dialogs/error_dialog.dart';

class PropertyDetailsView extends StatefulWidget {
  final CrudStatesSeePropertyDetails state;
  const PropertyDetailsView({super.key, required this.state});

  @override
  State<PropertyDetailsView> createState() => _PropertyDetailsViewState();
}

class _PropertyDetailsViewState extends State<PropertyDetailsView> {
  late final CloudProperty _property;
  late final TextEditingController _paymentController;
  late final TextEditingController _amountDueController;
  final _updateOrCreatePropertyForm = GlobalKey<FormState>();
  @override
  void initState() {
    _property = widget.state.property;
    _paymentController = TextEditingController();
    _amountDueController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _paymentController.dispose();
    _amountDueController.dispose();
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
          leading: IconButton(
              onPressed: () =>
                  context.read<CrudBloc>().add(const CrudEventPropertiesView()),
              icon: const Icon(Icons.arrow_back)),
          title: Text(widget.state.property.title),
          actions: const [],
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
                    Row(
                      children: [
                        const Text('Make Payment: '),
                        SizedBox(
                          height: 100,
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
                              hintText: 'Payment amount...',
                              labelText: 'Payment amount',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
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
