class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    // TODO: implement toString
    return '$_message $_prefix';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, 'Error during comunication');
}

class BadRequestException extends AppException {
  BadRequestException([String? message])
      : super(message, 'Error during comunication');
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message])
      : super(message, 'Error during comunication');
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message])
      : super(message, 'Error during comunication');
}

class NoInternetException extends AppException {
  NoInternetException([String? message])
      : super(message, 'Error during comunication');
}
