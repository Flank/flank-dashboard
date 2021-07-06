// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';
import 'package:metrics_core/src/util/validation/printer/validation_result_printer.dart';
import 'package:metrics_core/src/util/validation/target_validation_result.dart';
import 'package:metrics_core/src/util/validation/validation_conclusion.dart';
import 'package:metrics_core/src/util/validation/validation_result.dart';
import 'package:metrics_core/src/util/validation/validation_target.dart';
import 'package:mockito/mockito.dart';

import 'package:test/test.dart';

import '../../../test_utils/matchers.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ValidationResultPrinter", () {
    const target = ValidationTarget(name: 'service 1', description: 'test');
    const secondTarget =
        ValidationTarget(name: 'service 2', description: 'test');
    const thirdTarget =
        ValidationTarget(name: 'service 3', description: 'test');
    const conclusion = ValidationConclusion(name: 'success', indicator: '+');
    const details = {'test': 'details'};
    const context = {'test': 'context'};
    const firstResult = TargetValidationResult(
      target: target,
      conclusion: conclusion,
      description: 'description 1',
      details: details,
      context: context,
    );
    const secondResult = TargetValidationResult(
      target: secondTarget,
      conclusion: conclusion,
      description: 'description 2',
      details: details,
      context: context,
    );
    const thirdResult = TargetValidationResult(
      target: thirdTarget,
      conclusion: conclusion,
      description: 'description 3',
      details: details,
      context: context,
    );

    final ioSink = IOSinkMock();
    final resultPrinter = ValidationResultPrinter(sink: ioSink);

    Matcher containsAllEntries(Map<String, dynamic> fromMap) {
      final entries = <String>[];
      fromMap.forEach((key, value) {
        entries.add(key);
        entries.add(value.toString());
      });

      return stringContainsInOrder(entries);
    }

    Matcher validationResultMessageMatcher(
      ValidationTarget target,
      TargetValidationResult result,
    ) {
      final targetName = target.name;
      final targetDescription = target.description ?? '';
      final conclusion = result.conclusion;
      final conclusionIndicator = conclusion.indicator ?? '?';
      final description = result.description;
      final details = result.details;
      final context = result.context;

      return allOf(
        startsWith('[$conclusionIndicator]'),
        contains(targetName),
        contains(targetDescription),
        contains(description),
        containsAllEntries(details),
        containsAllEntries(context),
      );
    }

    tearDown(() {
      reset(ioSink);
    });

    test(
      "creates an instance with the default stdout iosink, if the given one is null",
      () {
        final resultPrinter = ValidationResultPrinter(sink: null);

        expect(resultPrinter.sink, equals(stdout));
      },
    );

    test(
      "creates an instance with the given sink",
      () {
        final resultPrinter = ValidationResultPrinter(sink: ioSink);

        expect(resultPrinter.sink, equals(ioSink));
      },
    );

    test(
      ".print() prints the validation result message to the sink with the '?' indicator if the given one is null",
      () {
        const conclusion = ValidationConclusion(name: 'name', indicator: null);
        const result = TargetValidationResult(
          target: target,
          conclusion: conclusion,
        );
        final results = {target: result};
        final validationResult = ValidationResult(results);

        resultPrinter.print(validationResult);

        final startsWithDefaultIndicator = startsWith('[?]');

        verify(
          ioSink.writeln(argThat(startsWithDefaultIndicator)),
        ).called(once);
      },
    );

    test(
      ".print() prints the validation result message to the sink with the given indicator",
      () {
        const indicator = '+';
        const conclusion = ValidationConclusion(
          name: 'name',
          indicator: indicator,
        );
        const result = TargetValidationResult(
          target: target,
          conclusion: conclusion,
        );
        final results = {target: result};
        final validationResult = ValidationResult(results);

        resultPrinter.print(validationResult);

        final startsWithDefaultIndicator = startsWith('[$indicator]');

        verify(
          ioSink.writeln(argThat(startsWithDefaultIndicator)),
        ).called(once);
      },
    );

    test(
      ".print() prints the validation result message to the sink with the given target name",
      () {
        const targetName = 'target name';
        const target = ValidationTarget(name: targetName);
        const result = TargetValidationResult(
          target: target,
          conclusion: conclusion,
        );
        final results = {target: result};
        final validationResult = ValidationResult(results);

        resultPrinter.print(validationResult);

        verify(
          ioSink.writeln(argThat(contains(targetName))),
        ).called(once);
      },
    );

    test(
      ".print() prints the validation result message to the sink with the given target description",
      () {
        const targetDescription = 'target description';
        const target = ValidationTarget(
          name: 'name',
          description: targetDescription,
        );
        const result = TargetValidationResult(
          target: target,
          conclusion: conclusion,
        );
        final results = {target: result};
        final validationResult = ValidationResult(results);

        resultPrinter.print(validationResult);

        verify(
          ioSink.writeln(argThat(contains(targetDescription))),
        ).called(once);
      },
    );

    test(
      ".print() prints the validation result message to the sink with the given validation result description",
      () {
        const description = 'description';
        const result = TargetValidationResult(
          target: target,
          conclusion: conclusion,
          description: description,
        );
        final results = {target: result};
        final validationResult = ValidationResult(results);

        resultPrinter.print(validationResult);

        verify(
          ioSink.writeln(argThat(contains(description))),
        ).called(once);
      },
    );

    test(
      ".print() prints the validation result message to the sink with the given validation result details",
      () {
        const details = {'test': 'details'};
        const result = TargetValidationResult(
          target: target,
          conclusion: conclusion,
          details: details,
        );
        final results = {target: result};
        final validationResult = ValidationResult(results);

        resultPrinter.print(validationResult);

        verify(
          ioSink.writeln(argThat(containsAllEntries(details))),
        ).called(once);
      },
    );

    test(
      ".print() prints the validation result message to the sink with the given validation result context",
      () {
        const context = {'test': 'context'};
        const result = TargetValidationResult(
          target: target,
          conclusion: conclusion,
          context: context,
        );
        final results = {target: result};
        final validationResult = ValidationResult(results);

        resultPrinter.print(validationResult);

        verify(
          ioSink.writeln(argThat(containsAllEntries(context))),
        ).called(once);
      },
    );

    test(
      ".print() prints validation result messages for all targets",
      () {
        final results = {
          target: firstResult,
          secondTarget: secondResult,
          thirdTarget: thirdResult,
        };
        final validationResult = ValidationResult(results);

        resultPrinter.print(validationResult);

        results.forEach((target, result) {
          verify(
            ioSink.writeln(argThat(
              validationResultMessageMatcher(target, result),
            )),
          ).called(once);
        });
      },
    );

    test(
      ".print() prints the validation results in the given order",
      () {
        final results = {
          target: firstResult,
          secondTarget: secondResult,
          thirdTarget: thirdResult,
        };
        final validationResult = ValidationResult(results);

        resultPrinter.print(validationResult);

        final expectedMessages = results.entries.map((entry) {
          final target = entry.key;
          final result = entry.value;

          return argThat(
            validationResultMessageMatcher(target, result),
          );
        });

        verifyInOrder(
          expectedMessages.map(ioSink.writeln).toList(),
        );
      },
    );
  });
}

class IOSinkMock extends Mock implements IOSink {}
