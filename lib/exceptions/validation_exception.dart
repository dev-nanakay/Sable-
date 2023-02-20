class ValidationException implements Exception {
  String cause;

  ValidationException(this.cause);
}
