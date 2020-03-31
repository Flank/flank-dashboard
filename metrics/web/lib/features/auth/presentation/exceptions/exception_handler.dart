import 'package:metrics/features/auth/domain/exceptions/validation_exception.dart';
import 'package:metrics/features/auth/service/exceptions/sign_in_exception.dart';
import 'package:metrics/features/auth/service/exceptions/sign_out_exception.dart';

class ExceptionHandler {
  static ErrorMessage errorMessage(dynamic error) {
    if (error == null) {
      return ErrorMessage();
    }

    if (error is SignInException) {
      return ErrorMessage(message: error.message, title: error.title);
    }

    if (error is SignOutException) {
      return ErrorMessage(message: error.message, title: error.title);
    }

    if (error is ValidationException) {
      return ErrorMessage(message: error.message);
    }

    throw error;
  }
}

class ErrorMessage {
  final String title;
  final String message;

  ErrorMessage({this.title, this.message});
}
