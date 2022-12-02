import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_storage_constants.dart';
import 'package:training_note_app/services/crud_services/cloud/cloud_storage_exceptions.dart';
import 'package:training_note_app/services/crud_services/cloud/firebase_cloud_storage.dart';

class CloudProperty extends FirebaseCloudObject {
  String propertyId;
  String ownerUserId;
  String title;
  String address;
  int monthlyPrice;
  int moneyDue;
  DateTime? currentDate;
  CloudProperty(
      {required this.propertyId,
      required this.ownerUserId,
      required this.title,
      required this.address,
      required this.monthlyPrice,
      required this.moneyDue});

  CloudProperty.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : propertyId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName] as String,
        title = snapshot.data()[titleFieldName] as String,
        address = snapshot.data()[addressFieldName] as String,
        monthlyPrice = snapshot.data()[monthlyPriceFieldName] as int,
        moneyDue = snapshot.data()[moneyDueFieldName] as int,
        currentDate =
            (snapshot.data()[propertyCurrentDateFieldName] as Timestamp)
                .toDate();

  int resetMoneyDue() {
    moneyDue = monthlyPrice;
    return moneyDue;
  }

  int makePayment({required int amount}) {
    if (amount > moneyDue) throw PaymentExceedsRequiredAmount();
    moneyDue -= amount;
    return moneyDue;
  }
}
