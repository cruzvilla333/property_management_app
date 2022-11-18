import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_note_app/services/crud_services/crud_bloc/crud_states.dart';
import '../../constants/regular_expressions.dart';
import '../../services/crud_services/crud_bloc/crud_bloc.dart';
import '../../services/crud_services/crud_bloc/crud_events.dart';
import '../../utilities/dialogs/delete_dialog.dart';
import '../../utilities/navigation/navigation_utilities.dart';

class PropertyPaymentsView extends StatelessWidget {
  const PropertyPaymentsView({super.key, required this.state});
  final CrudStatePaymentHistory state;

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment history'),
        leading: IconButton(
            onPressed: () => goBack(context: context),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: ListView.builder(
        itemCount: state.payments.length,
        itemBuilder: (context, index) {
          final payment = state.payments.elementAt(index);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 1),
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
                ],
              ),
              trailing: IconButton(
                onPressed: () async {
                  final shouldDelete = await showDeletePaymentDialog(context);
                  if (shouldDelete && mounted) {
                    context
                        .read<CrudBloc>()
                        .add(CrudEventDeletePayment(payment: payment));
                  }
                },
                icon: const Icon(Icons.delete),
              ),
            ),
          );
        },
      ),
    );
  }
}
