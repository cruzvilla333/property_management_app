// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../services/crud_services/cloud/cloud_property.dart';
// import '../services/crud_services/cloud/cloud_property_payment.dart';
// import '../services/crud_services/cloud/cloud_storage_constants.dart';
// import '../services/crud_services/cloud/cloud_storage_exceptions.dart';
// import '../services/crud_services/cloud/cloud_tenant.dart';

// final collections = FirebaseFirestore.instance;
// final payments = collections.collection(paymentsCollection);
// final properties = collections.collection(propertiesCollection);
// final tenants = collections.collection(tenantsCollection);

// Future<CloudPropertyPayment> createPayment({
//   required String propertyId,
//   required int paymentAmount,
//   required String paymentMethod,
// }) async {
//   try {
//     final date = DateTime.now();
//     final payment = await payments.add({
//       propertyIdFieldName: propertyId,
//       paymentAmountFieldName: paymentAmount,
//       paymentMethodFieldName: paymentMethod,
//       paymentDateFieldName: date,
//     });
//     final newPayment = await payment.get();
//     return CloudPropertyPayment(
//       paymentDate: date,
//       documentId: newPayment.id,
//       propertyId: propertyId,
//       paymentAmount: paymentAmount,
//       paymentMethod: paymentMethod,
//     );
//   } catch (e) {
//     throw CouldNotCreatePaymentException();
//   }
// }

// Future<CloudTenant> createTenant({
//   required String firstName,
//   required String lastName,
//   required int age,
//   required String sex,
//   propertyId = '',
// }) async {
//   try {
//     final tenant = await tenants.add({
//       tenantFirstNameFieldName: firstName,
//       tenantLastNameFieldName: lastName,
//       sexFieldName: sex,
//       ageFieldName: age,
//       propertyIdFieldName: propertyId,
//     });
//     final newTenant = await tenant.get();
//     return CloudTenant(
//       age: age,
//       tenantId: newTenant.id,
//       sex: sex,
//       firstName: firstName,
//       lastName: lastName,
//       propertyId: propertyId,
//     );
//   } catch (e) {
//     throw CouldNotCreateTenantException();
//   }
// }

// Future<CloudProperty> createProperty({
//   required String ownerUserId,
//   required String title,
//   required String address,
//   required int monthlyPrice,
// }) async {
//   try {
//     final document = await properties.add({
//       ownerUserIdFieldName: ownerUserId,
//       titleFieldName: title,
//       addressFieldName: address,
//       monthlyPriceFieldName: monthlyPrice,
//       moneyDueFieldName: monthlyPrice,
//       propertyCurrentDateFieldName: DateTime.now(),
//     });
//     final newNote = await document.get();
//     return CloudProperty(
//       documentId: newNote.id,
//       ownerUserId: ownerUserId,
//       title: title,
//       address: address,
//       monthlyPrice: monthlyPrice,
//       moneyDue: monthlyPrice,
//     );
//   } catch (e) {
//     throw CouldNotCreatePropertyException();
//   }
// }
