import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../exceptions/validation_exception.dart';

/// Responsible for validation email [TextField] input widget
class Email {
  final String value;

  Email(this.value) {
    if (value.isEmpty) {
      throw ValidationException('Email address is required');
    }

    if (!EmailValidator.validate(value)) {
      throw ValidationException('Invalid email address');
    }
  }
}
