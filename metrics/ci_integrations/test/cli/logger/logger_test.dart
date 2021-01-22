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

    test(".setup() sets up the Logger", () {
      Logger.setup(messageSink: sinkMock);

      expect(() => Logger.logMessage(message), returnsNormally);
    });

    test(".logError() logs the given error to the error sink", () {
      Logger.setup(errorSink: sinkMock);
      Logger.logError(error);

      verify(sinkMock.writeln(error)).called(1);
    });

    test(
      ".logMessage() logs the given message to the message sink",
      () {
        Logger.setup(messageSink: sinkMock);
        Logger.logMessage(message);

        verify(sinkMock.writeln(message)).called(1);
      },
    );

    test(
      ".logInfo() logs the given message to the message sink if the verbose is true",
      () {
        final dateTimeNow = DateFormat.yMd().add_Hms().format(DateTime.now());
        final expected = '[$dateTimeNow] $message';

        Logger.setup(messageSink: sinkMock, verbose: true);
        Logger.logInfo(message);

        verify(sinkMock.writeln(expected)).called(1);
      },
    );

    test(
      ".logInfo() does not log the given message to the message sink if the verbose is false",
      () {
        Logger.setup(messageSink: sinkMock, verbose: false);
        Logger.logInfo(message);

        verifyNever(sinkMock.writeln(message));
      },
    );
  });
}
