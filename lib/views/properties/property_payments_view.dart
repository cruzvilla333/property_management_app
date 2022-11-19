import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_property_payment.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';
import '../../constants/regular_expressions.dart';
import '../../helpers/loading/loading_overlay.dart';
import '../../services/crud_services/crud_bloc/crud_bloc.dart';
import '../../services/crud_services/crud_bloc/crud_events.dart';
import '../../utilities/dialogs/delete_dialog.dart';
import '../../utilities/navigation/navigation_utilities.dart';

class PropertyPaymentsView extends StatefulWidget {
  const PropertyPaymentsView({super.key, required this.state});
  final CrudStatePaymentHistory state;

  @override
  State<PropertyPaymentsView> createState() => _PropertyPaymentsViewState();
}

class _PropertyPaymentsViewState extends State<PropertyPaymentsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment history'),
        leading: IconButton(
            onPressed: () => lastPage(context: context),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: StreamBuilder<Object>(
          stream: widget.state.payments,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allPayments =
                      snapshot.data as Iterable<CloudPropertyPayment>;
                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: allPayments.length,
                    itemBuilder: (context, index) {
                      final payment = allPayments.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Amount: ${payment.paymentAmount.toString().replaceAllMapped(reg, mathFunc)}\$',
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Payment method: ${payment.paymentMethod}',
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Payment date: ${payment.paymentDate.month}/${payment.paymentDate.day}/${payment.paymentDate.year}',
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              final shouldDelete =
                                  await showDeletePaymentDialog(context);
                              if (shouldDelete && mounted) {
                                context.read<CrudBloc>().add(
                                    CrudEventDeletePayment(payment: payment));
                              }
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const LoadingOverlay();
                }
              default:
                return const LoadingOverlay();
            }
          }),
    );
  }
}
