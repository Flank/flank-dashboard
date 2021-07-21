// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:metrics_core/src/util/validation/target_validation_result.dart';
import 'package:metrics_core/src/util/validation/validation_conclusion.dart';
import 'package:metrics_core/src/util/validation/validation_result.dart';
import 'package:metrics_core/src/util/validation/validation_target.dart';

/// A class that is responsible for printing the [ValidationResult].
class ValidationResultPrinter {
  /// An instance of the [StringSink] this printer uses to print the result.
  final StringSink sink;

  /// Creates a new instance of the [ValidationResultPrinter] with the given
  /// [StringSink].
  ///
  /// Throws an [ArgumentError] if the given [sink] is `null`;
  ValidationResultPrinter({
    this.sink,
  }) {
    ArgumentError.checkNotNull(sink, 'sink');
  }

  /// Prints the given [result] to the [sink].
  void print(ValidationResult result) {
    final validationResults = result.results;

    final validationResultEntries = validationResults.entries;

    for (final entry in validationResultEntries) {
      final target = entry.key;
      final result = entry.value;

      final message = _buildTargetValidationOutput(target, result);

      sink.writeln(message);
    }
  }

  /// Builds the output that provides the information about
  /// the given [target] and [validationResult].
  String _buildTargetValidationOutput(
    ValidationTarget target,
    TargetValidationResult validationResult,
  ) {
    final conclusion = _getConclusionIndicator(validationResult);
    final targetName = target.name;
    final targetDescription = _getDescription(target);
    final validationDescription = _getValidationDescription(validationResult);
    final details = _getValidationDetails(validationResult);
    final context = _getValidationContext(validationResult);

    return '''
$conclusion $targetName$targetDescription$validationDescription$details
\t$context
    ''';
  }

  /// Returns a [String] representation of the
  /// [TargetValidationResult.conclusion].
  ///
  /// Returns the `[?]` indicator if the given [ValidationConclusion.indicator]
  /// is `null` or empty.
  String _getConclusionIndicator(TargetValidationResult validationResult) {
    final conclusion = validationResult.conclusion;
    final indicator = conclusion.indicator;

    if (indicator == null || indicator.isEmpty) {
      return '[?]';
    }

    return '[$indicator]';
  }

  /// Returns a [String] representation of the [ValidationTarget.description].
  ///
  /// Returns an empty string if the given [ValidationTarget.description] is
  /// `null` or empty.
  String _getDescription(ValidationTarget target) {
    final description = target.description;

    if (description == null || description.isEmpty) return '';

    return ' $description';
  }

  /// Returns a [String] representation of the
  /// [TargetValidationResult.description].
  ///
  /// Returns an empty string if the given [TargetValidationResult.description]
  /// is `null` or empty.
  String _getValidationDescription(TargetValidationResult validationResult) {
    final description = validationResult.description;

    if (description == null || description.isEmpty) return '';

    return ' - $description';
  }

  /// Returns the [String] representation of the given
  /// [TargetValidationResult.details].
  ///
  /// Returns an empty string if the given [TargetValidationResult.details] is
  /// `null` or empty.
  String _getValidationDetails(TargetValidationResult validationResult) {
    final details = validationResult.details;
    final resultMessage = [];

    if (details == null || details.isEmpty) return '';

    details.forEach((key, value) => resultMessage.add('$key $value'));

    return ' (${resultMessage.join(', ')})';
  }

  /// Returns the [String] representation of the given
  /// [TargetValidationResult.context].
  ///
  /// Returns an empty string if the given [TargetValidationResult.context] is
  /// `null` or empty.
  String _getValidationContext(TargetValidationResult validationResult) {
    final context = validationResult.context;
    const indent = '\n\t\t';
    final resultMessage = [];

    if (context == null || context.isEmpty) return '';

    context.forEach((key, value) {
      final indentValue = value.toString().replaceAll('\n', indent);
      resultMessage.add('$key$indent$indentValue');
    });

    return resultMessage.join('\n\t');
  }
}
