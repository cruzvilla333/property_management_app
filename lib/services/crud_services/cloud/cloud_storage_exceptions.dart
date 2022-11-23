class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreatePropertyException extends CloudStorageException {
  @override
  String toString() {
    return 'Could not create property';
  }
}

class CouldNotCreatePaymentException extends CloudStorageException {
  @override
  String toString() {
    return 'Could not create payment';
  }
}

class CouldNotGetAllPropertiesException extends CloudStorageException {
  @override
  String toString() {
    return 'Could not get all properties';
  }
}

class CouldNotGetAllPaymentsException extends CloudStorageException {
  @override
  String toString() {
    return 'Could not get all payments';
  }
}

class CouldNotUpdatePropertyException extends CloudStorageException {
  @override
  String toString() {
    return 'Could not update property';
  }
}

class CouldNotDeletePropertyException extends CloudStorageException {
  @override
  String toString() {
    return 'Could not delete property';
  }
}

class CouldNotDeletePaymentException extends CloudStorageException {
  @override
  String toString() {
    return 'Could not delete property';
  }
}

class CouldNotFindPropertyExcepiton extends CloudStorageException {
  @override
  String toString() {
    return 'Could not find property';
  }
}

class CouldNotDelteAllPropertiesException extends CloudStorageException {
  @override
  String toString() {
    return 'Could not delete all properties';
  }
}

class PaymentExceedsRequiredAmount implements Exception {
  @override
  String toString() {
    return 'Payment Exceeds Required Amount';
  }
}

class CouldNotCreateTenantException extends CloudStorageException {
  @override
  String toString() {
    return 'Could not create tenant';
  }
}

class CouldNotGetAllTenantsException extends CloudStorageException {
  @override
  String toString() {
    return 'Could not get all tenants';
  }
}
