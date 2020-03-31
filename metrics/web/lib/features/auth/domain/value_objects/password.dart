import 'package:flutter/material.dart';

import '../exceptions/validation_exception.dart';

/// Responsible for validation password [TextField] input widget
class Password {
  final String value;

  Password(this.value) {
    if (value.isEmpty) {
      throw ValidationException('Password is required');
    }
  }
}
