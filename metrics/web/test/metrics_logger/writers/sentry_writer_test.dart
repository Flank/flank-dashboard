import 'package:metrics/metrics_logger/writers/sentry_writer.dart';
import 'package:mockito/mockito.dart';
import 'package:sentry/sentry.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("SentryWriter", () {
    const testDsn = "testDsn";
    const testRelease = "testRelease";

    final sentryClientMock = _SentryClientMock();
    SentryWriter writer;

    setUp(() async {
      writer = await SentryWriter.init(testDsn, testRelease);
      Sentry.bindClient(sentryClientMock);
    });

    tearDown(() {
      reset(sentryClientMock);
      Sentry.close();
    });

    test(
      ".init() initializes Sentry with the given DSN and release",
      () async {
        final writer = await SentryWriter.init(testDsn, testRelease);

        expect(writer, isNotNull);
        expect(Sentry.isEnabled, isTrue);
      },
    );

    test(
      ".setContext() sets the context by the given key to the given value",
      () async {
        const key = 'contextKey';
        const value = {'testContext': 'value'};

        writer.setContext(key, value);

        Map<String, dynamic> context;
        Sentry.configureScope((scope) => context = scope.contexts);

        expect(context, containsPair(key, value));
      },
    );

    test(
      ".setContext() sets the context by the given key to the given value in map if the given value is not a map",
      () async {
        const key = 'contextKey';
        const value = 'contextValue';
        const expectedValue = {'value': value};

        writer.setContext(key, value);

        Map<String, dynamic> context;
        Sentry.configureScope((scope) => context = scope.contexts);

        expect(context, containsPair(key, expectedValue));
      },
    );

    test(
      ".writeError() writes the given error if the given stack trace is not given",
      () async {
        final error = Error();

        await writer.writeError(error);

        verify(sentryClientMock.captureException(
          error,
          stackTrace: argThat(isNull, named: 'stackTrace'),
          scope: anyNamed('scope'),
          hint: argThat(isNull, named: 'hint'),
        )).called(1);
      },
    );

    test(
      ".writeError() writes the given error if the given stack trace is null",
      () async {
        final error = Error();

        await writer.writeError(error, null);

        verify(sentryClientMock.captureException(
          error,
          stackTrace: argThat(isNull, named: 'stackTrace'),
          scope: anyNamed('scope'),
          hint: argThat(isNull, named: 'hint'),
        )).called(1);
      },
    );

    test(
      ".writeError() writes the given error and its stack trace",
      () async {
        final error = Error();
        final stackTrace = StackTrace.fromString('test stack trace');

        await writer.writeError(error, stackTrace);

        verify(sentryClientMock.captureException(
          error,
          stackTrace: stackTrace,
          scope: anyNamed('scope'),
          hint: argThat(isNull, named: 'hint'),
        )).called(1);
      },
    );

    test(
      ".writeError() applies the contexts set to the error",
      () async {
        const key = 'contextKey';
        const value = {'testContext': 'value'};
        final error = Error();
        final stackTrace = StackTrace.fromString('test stack trace');

        writer.setContext(key, value);
        await writer.writeError(error, stackTrace);

        verify(sentryClientMock.captureException(
          error,
          stackTrace: stackTrace,
          scope: argThat(
            predicate<Scope>((scope) => scope.contexts[key] == value),
            named: 'scope',
          ),
          hint: argThat(isNull, named: 'hint'),
        )).called(1);
      },
    );
  });
}

class _SentryClientMock extends Mock implements SentryClient {}
