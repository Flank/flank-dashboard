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
    final buffer = StringBuffer();

    _addConclusion(buffer, validationResult.conclusion);
    buffer.write(' ${target.name}');
    _addDescription(buffer, target.description);
    _addResultDescription(buffer, validationResult.description);
    _addDetails(buffer, validationResult.details);
    buffer.write('\n');
    _addContext(buffer, validationResult.context);

    return buffer.toString();
  }

  /// Adds the [String] representation of the given [conclusion] to the
  /// given [buffer].
  ///
  /// Records `[?]` if the given [ValidationConclusion.indicator]
  /// is empty or `null`.
  void _addConclusion(StringBuffer buffer, ValidationConclusion conclusion) {
    final indicator = conclusion.indicator;

    if (indicator == null || indicator.isEmpty) {
      buffer.write('[?]');
    } else {
      buffer.write('[$indicator]');
    }
  }

  /// Adds the [String] representation of the given [description] to the
  /// given [buffer].
  ///
  /// Adds nothing if the given [description] is empty or `null`.
  void _addDescription(StringBuffer buffer, String description) {
    if (description == null || description.isEmpty) return;

    buffer.write(' $description');
  }

  /// Adds the [String] representation of the given [resultDescription] to the
  /// given [buffer].
  ///
  /// Adds nothing if the given [resultDescription] is empty or `null`.
  void _addResultDescription(StringBuffer buffer, String resultDescription) {
    if (resultDescription == null || resultDescription.isEmpty) return;

    buffer.write(' - $resultDescription');
  }

  /// Adds the [String] representation of the given [details] to the
  /// given [buffer].
  ///
  /// Adds nothing if the given [details] is empty or `null`.
  void _addDetails(StringBuffer buffer, Map<String, dynamic> details) {
    if (details == null || details.isEmpty) return;

    final messages = <String>[];
    details.forEach((key, value) => messages.add('$key $value'));
    final detailsMessage = messages.join(', ');

    buffer.write(' ($detailsMessage)');
  }

  /// Adds the [String] representation of the given [context] to the
  /// given [buffer].
  ///
  /// Adds nothing if the given [context] is empty or `null`.
  void _addContext(StringBuffer buffer, Map<String, dynamic> context) {
    if (context == null || context.isEmpty) return;

    const indent = '\n\t\t';
    final resultMessage = [];

    context.forEach((key, value) {
      final indentValue = value.toString().replaceAll('\n', indent);
      resultMessage.add('$key$indent$indentValue');
    });

    buffer.write('\t');
    buffer.write(resultMessage.join('\n\t'));
  }
}
