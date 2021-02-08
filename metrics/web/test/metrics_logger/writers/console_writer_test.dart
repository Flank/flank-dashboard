// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/metrics_logger/writers/console_writer.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ConsoleWriter", () {
    final error = Exception('test');
    final errorString = error.toString();
    final stackTrace = StackTrace.fromString('test stack trace');
    final stackTraceString = stackTrace.toString();

    ConsoleWriter writer;

    setUp(() {
      writer = ConsoleWriter();
    });

    test(
      ".setContext() sets the context by the given key to the given value",
      () {
        const key = 'contextKey';
        const value = 'contextValue';

        writer.setContext(key, value);

        final logMatcher = stringContainsInOrder([key, value]);

        expect(
          () => writer.writeError(error),
          prints(logMatcher),
        );
      },
    );

    test(
      ".writeError() prints the given error if the given stack trace is not passed",
      () {
        expect(
          () => writer.writeError(error),
          prints(contains(errorString)),
        );
      },
    );

    test(
      ".writeError() prints the given error if the given stack trace is null",
      () async {
        expect(
          () => writer.writeError(error, null),
          prints(contains(errorString)),
        );
      },
    );

    test(
      ".writeError() prints the given error and its stack trace",
      () async {
        final logMatcher = stringContainsInOrder([
          errorString,
          stackTraceString,
        ]);

        expect(
          () => writer.writeError(error, stackTrace),
          prints(logMatcher),
        );
      },
    );

    test(
      ".writeError() prints the contexts set with the error",
      () async {
        const firstContext = MapEntry('first_key', 'first_value');
        const secondContext = MapEntry('second_key', 'second_value');
        final stackTrace = StackTrace.fromString('test stack trace');

        writer.setContext(firstContext.key, firstContext.value);
        writer.setContext(secondContext.key, secondContext.value);
        writer.writeError(error, stackTrace);

        final logMatcher = stringContainsInOrder([
          errorString,
          firstContext.key,
          firstContext.value,
          secondContext.key,
          secondContext.value,
          stackTraceString,
        ]);

        expect(
          () => writer.writeError(error, stackTrace),
          prints(logMatcher),
        );
      },
    );
  });
}
