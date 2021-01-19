import 'dart:io';

import 'package:ci_integration/cli/logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_util/stub/io_sink_stub.dart';

void main() {
  group("Logger", () {
    final errorSink = IOSinkStub();
    final messageSink = IOSinkStub();
    final unimplementedSink = IOSinkStub(
      writelnCallback: (_) => throw UnimplementedError(),
    );
    const message = 'message';
    const error = 'error';

    test(
      ".logError() throws an Exception if the Logger is not configured",
      () {
        expect(() => Logger.logError(error), throwsException);
      },
    );

    test(
      ".logMessage() throws an Exception if the Logger is not configured",
      () {
        expect(() => Logger.logMessage(message), throwsException);
      },
    );

    test(
      ".logInfo() throws an Exception if the Logger is not configured",
      () {
        expect(() => Logger.logInfo(message), throwsException);
      },
    );

    test(".setup() configure the logger with the given error sink", () {
      final errorSink = IOSinkMock();
      Logger.setup(errorSink: errorSink);

      Logger.logError(error);

      verify(errorSink.writeln(any)).called(1);
    });

    test(".setup() configure the logger with the given message sink", () {
      final messageSink = IOSinkMock();
      Logger.setup(messageSink: messageSink);

      Logger.logMessage(message);

      verify(messageSink.writeln(any)).called(1);
    });

    test(".logError() prints the given error to the error sink", () {
      Logger.setup(
        errorSink: errorSink,
        messageSink: unimplementedSink,
      );

      expect(
        () => Logger.logError(error),
        prints(equalsIgnoringWhitespace(error)),
      );
    });

    test(
      ".logMessage() prints the given message to the message sink",
      () {
        Logger.setup(
          errorSink: unimplementedSink,
          messageSink: messageSink,
        );

        expect(
          () => Logger.logMessage(message),
          prints(equalsIgnoringWhitespace(message)),
        );
      },
    );

    test(
      ".logInfo() prints the given message to the message sink if the verbose is true",
      () {
        final dateTimeNow = DateFormat('dd-MM-yyyy HH:mm:ss').format(
          DateTime.now(),
        );

        final expected = '[$dateTimeNow] $message';

        Logger.setup(
          errorSink: unimplementedSink,
          messageSink: messageSink,
          verbose: true,
        );

        expect(
          () => Logger.logInfo(message),
          prints(equalsIgnoringWhitespace(expected)),
        );
      },
    );

    test(
      ".logInfo() does not print the given message to the message sink if the verbose is false",
      () {
        Logger.setup(
          errorSink: unimplementedSink,
          messageSink: messageSink,
          verbose: false,
        );

        expect(
          () => Logger.logInfo(message),
          prints(equalsIgnoringWhitespace('')),
        );
      },
    );
  });
}

class IOSinkMock extends Mock implements IOSink {}
