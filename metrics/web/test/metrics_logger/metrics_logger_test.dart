import 'package:metrics/metrics_logger/metrics_logger.dart';
import 'package:metrics/metrics_logger/writer/logger_writer.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_utils/matcher_util.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("MetricsLogger", () {
    const contextKey = 'context_key';
    const contextValue = 'context_value';
    final error = Error();

    final writerMock = _MockLoggerWriter();

    tearDown(() {
      reset(writerMock);
    });

    test(
      ".initialize() throws an AssertionError if the given writer is null",
      () {
        expect(
          () => MetricsLogger.initialize(null),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      ".logError() throws an AssertionError if the current writer is null",
      () {
        expect(
          () => MetricsLogger.logError(error),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      ".setContext() throws an AssertionError if the current writer is null",
      () {
        expect(
          () => MetricsLogger.setContext(contextKey, contextValue),
          MatcherUtil.throwsAssertionError,
        );
      },
    );

    test(
      ".initialize() sets the current logger writer to the given one",
      () async {
        await MetricsLogger.initialize(writerMock);

        final future = MetricsLogger.logError(error);

        expect(future, completes);
        verify(writerMock.writeError(error)).called(1);
      },
    );

    test(
      ".initialize() set contexts from the given map entries for the current writer",
      () async {
        final contexts = {
          contextKey: contextValue,
          'testKey': 'testValue',
        };

        await MetricsLogger.initialize(writerMock, contexts: contexts);

        verifyInOrder([
          writerMock.setContext(contextKey, contextValue),
          writerMock.setContext('testKey', 'testValue'),
        ]);
      },
    );

    test(
      ".initialize() does not set contexts for the current writer if the given map is null",
      () async {
        await MetricsLogger.initialize(writerMock, contexts: null);

        verifyNever(writerMock.setContext(any, any));
      },
    );

    test(
      ".logError() uses the current writer to write the given error",
      () async {
        await MetricsLogger.logError(error);

        verify(writerMock.writeError(error)).called(1);
      },
    );
    test(
      ".setContext() uses the current writer to set the given context",
      () async {
        await MetricsLogger.setContext(contextKey, contextValue);

        verify(writerMock.setContext(contextKey, contextValue)).called(1);
      },
    );
  });
}

class _MockLoggerWriter extends Mock implements LoggerWriter {}
