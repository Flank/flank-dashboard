import 'package:ci_integration/cli/logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_util/mock/io_sink_mock.dart';

void main() {
  group("Logger", () {
    final sinkMock = IOSinkMock();

    const message = 'message';
    const error = 'error';

    tearDown(() {
      reset(sinkMock);
    });

    test(
      ".logError() throws an Exception if the Logger is not configured",
      () {
        expect(() => Logger.logError(error), throwsStateError);
      },
    );

    test(
      ".logMessage() throws an Exception if the Logger is not configured",
      () {
        expect(() => Logger.logMessage(message), throwsStateError);
      },
    );

    test(
      ".logInfo() throws an Exception if the Logger is not configured",
      () {
        expect(() => Logger.logInfo(message), throwsStateError);
      },
    );

    test(".setup() configures the logger with the given error sink", () {
      Logger.setup(errorSink: sinkMock);
      Logger.logError(error);

      verify(sinkMock.writeln(any)).called(1);
    });

    test(".setup() configures the logger with the given message sink", () {
      Logger.setup(messageSink: sinkMock);
      Logger.logMessage(message);

      verify(sinkMock.writeln(any)).called(1);
    });

    test(".logError() prints the given error to the error sink", () {
      Logger.setup(errorSink: sinkMock);
      Logger.logError(error);

      verify(sinkMock.writeln(error)).called(1);
    });

    test(
      ".logMessage() prints the given message to the message sink",
      () {
        Logger.setup(messageSink: sinkMock);
        Logger.logMessage(message);

        verify(sinkMock.writeln(message)).called(1);
      },
    );

    test(
      ".logInfo() prints the given message to the message sink if the verbose is true",
      () {
        final dateTimeNow = DateFormat.yMd().add_Hms().format(DateTime.now());
        final expected = '[$dateTimeNow] $message';

        Logger.setup(messageSink: sinkMock, verbose: true);
        Logger.logInfo(message);

        verify(sinkMock.writeln(expected)).called(1);
      },
    );

    test(
      ".logInfo() does not print the given message to the message sink if the verbose is false",
      () {
        Logger.setup(messageSink: sinkMock, verbose: false);
        Logger.logInfo(message);

        verifyNever(sinkMock.writeln(message));
      },
    );
  });
}
