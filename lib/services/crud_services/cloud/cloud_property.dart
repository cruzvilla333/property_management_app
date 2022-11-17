import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_storage_constants.dart';

class CloudProperty {
  String documentId;
  String ownerUserId;
  String title;
  String address;
  int monthlyPrice;
  int _moneyDue;

  CloudProperty({
    required this.documentId,
    required this.ownerUserId,
    required this.title,
    required this.address,
    required this.monthlyPrice,
  }) : _moneyDue = monthlyPrice;

  int get moneyDue => _moneyDue;

  CloudProperty.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName] as String,
        title = snapshot.data()[titleFieldName] as String,
        address = snapshot.data()[addressFieldName] as String,
        monthlyPrice = snapshot.data()[monthlyPriceFieldName] as int,
        _moneyDue = snapshot.data()[moneyDueFieldName] as int;

  CloudProperty.populate({
    required this.documentId,
    required this.ownerUserId,
    required this.title,
    required this.address,
    required this.monthlyPrice,
  }) : _moneyDue = monthlyPrice;

  int makePayment({required int amount}) {
    _moneyDue -= amount;
    return _moneyDue;
  }
}
