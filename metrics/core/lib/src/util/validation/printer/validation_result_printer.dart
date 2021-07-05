// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:metrics_core/src/util/validation/target_validation_result.dart';
import 'package:metrics_core/src/util/validation/validation_result.dart';
import 'package:metrics_core/src/util/validation/validation_target.dart';

/// A class that is responsible for printing the [ValidationResult].
class ValidationResultPrinter {
  /// An instance of the [StringSink] this printer uses to print the result.
  final StringSink sink;

  /// Create a new instance of the [ValidationResultPrinter] with the given
  /// [StringSink].
  ///
  /// If the [StringSink] is `null`, an instance of the standard output stream
  /// is used.
  ValidationResultPrinter({
    StringSink sink,
  }) : sink = sink ?? stdout;

  /// Prints the given [result] to the [StringSink].
  void print(ValidationResult result) {
    final validationResults = result.results;

    final validationResultEntries = validationResults.entries;

    for (final entry in validationResultEntries) {
      final field = entry.key;
      final result = entry.value;

      final message = _buildFieldValidationOutput(field, result);

      sink.writeln(message);
    }
  }

  /// Builds the output that provides the information
  /// about the [validationResult] for the given [target].
  String _buildFieldValidationOutput(
    ValidationTarget target,
    TargetValidationResult validationResult,
  ) {
    final targetName = target.name;
    final targetDescription = target.description ?? '';
    final conclusion = validationResult.conclusion;
    final conclusionIndicator = conclusion.indicator ?? '?';
    final validationDescription = validationResult.description != null
        ? ' - ${validationResult.description}'
        : '';
    final details = _getValidationDetails(validationResult);
    final context = _getValidationContext(validationResult);

    return '''
[$conclusionIndicator] $targetName $targetDescription $validationDescription ($details)
\t$context
    ''';
  }

  /// Returns the [String] representation of the given
  /// [TargetValidationResult.details].
  ///
  /// Returns an empty string If the given [TargetValidationResult.details] is
  /// empty.
  String _getValidationDetails(TargetValidationResult validationResult) {
    final details = validationResult.details;
    final resultMessage = [];

    if (details.isEmpty) return '';

    details.forEach((key, value) => resultMessage.add('$key $value'));

    return resultMessage.join(', ');
  }

  /// Returns the [String] representation of the given
  /// [TargetValidationResult.context].
  ///
  /// Returns an empty string If the given [TargetValidationResult.context] is
  /// empty.
  String _getValidationContext(TargetValidationResult validationResult) {
    final context = validationResult.context;
    const indent = '\n\t\t';
    final resultMessage = [];

    if (context.isEmpty) return '';

    context.forEach((key, value) {
      final indentValue = value.toString().replaceAll('\n', indent);
      resultMessage.add('$key$indent$indentValue');
    });

    return resultMessage.join('\n\t');
  }
}
