import 'package:cloud_firestore/cloud_firestore.dart';
import 'cloud_property.dart';
import 'cloud_property_payment.dart';
import 'cloud_storage_constants.dart';
import 'cloud_storage_exceptions.dart';
import 'cloud_tenant.dart';

Future<CloudPropertyPayment> tryCreatePayment({
  required CollectionReference<Map<String, dynamic>> payments,
  required String propertyId,
  required int paymentAmount,
  required String paymentMethod,
}) async {
  try {
    final date = DateTime.now();
    final payment = await payments.add({
      propertyIdFieldName: propertyId,
      paymentAmountFieldName: paymentAmount,
      paymentMethodFieldName: paymentMethod,
      paymentDateFieldName: date,
    });
    final newPayment = await payment.get();
    return CloudPropertyPayment(
      paymentDate: date,
      documentId: newPayment.id,
      propertyId: propertyId,
      paymentAmount: paymentAmount,
      paymentMethod: paymentMethod,
    );
  } catch (e) {
    throw CouldNotCreatePaymentException();
  }
}

Future<CloudTenant> tryCreateTenant({
  required CollectionReference<Map<String, dynamic>> tenants,
  required String ownerUserId,
  required String firstName,
  required String lastName,
  required int age,
  required String sex,
  propertyId = '',
}) async {
  try {
    final tenant = await tenants.add({
      tenantFirstNameFieldName: firstName,
      tenantLastNameFieldName: lastName,
      sexFieldName: sex,
      ageFieldName: age,
      propertyIdFieldName: propertyId,
      ownerUserIdFieldName: ownerUserId,
    });
    final newTenant = await tenant.get();
    return CloudTenant(
      ownerUserId: ownerUserId,
      age: age,
      tenantId: newTenant.id,
      sex: sex,
      firstName: firstName,
      lastName: lastName,
      propertyId: propertyId,
    );
  } catch (e) {
    throw CouldNotCreateTenantException();
  }
}

Future<CloudProperty> tryCreateProperty({
  required CollectionReference<Map<String, dynamic>> properties,
  required String ownerUserId,
  required String title,
  required String address,
  required int monthlyPrice,
}) async {
  try {
    final document = await properties.add({
      ownerUserIdFieldName: ownerUserId,
      titleFieldName: title,
      addressFieldName: address,
      monthlyPriceFieldName: monthlyPrice,
      moneyDueFieldName: monthlyPrice,
      propertyCurrentDateFieldName: DateTime.now(),
    });
    final newNote = await document.get();
    return CloudProperty(
      documentId: newNote.id,
      ownerUserId: ownerUserId,
      title: title,
      address: address,
      monthlyPrice: monthlyPrice,
      moneyDue: monthlyPrice,
    );
  } catch (e) {
    throw CouldNotCreatePropertyException();
  }
}
