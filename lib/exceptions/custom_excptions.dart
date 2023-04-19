class CustomException implements Exception {
  final String message;
  CustomException(this.message);
}

// Unknown video name exception
class UnknownVideoNameException extends CustomException {
  UnknownVideoNameException(String message) : super(message);
}
