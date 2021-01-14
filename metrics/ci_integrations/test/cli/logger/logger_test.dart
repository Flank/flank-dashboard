import 'dart:convert';
import 'dart:io';

import 'package:ci_integration/cli/logger/logger.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("Logger", () {
    final errorSink = IOSinkStub();
    final messageSink = IOSinkStub();
    final unimplementedSink = IOSinkStub(
      writelnCallback: (_) => throw UnimplementedError(),
    );

    test(".printError() prints the given error to the error sink", () {
      Logger.setup(
        errorSink: errorSink,
        messageSink: unimplementedSink,
      );
      const expected = 'error';

      expect(
        () => Logger.printError(expected),
        prints(equalsIgnoringWhitespace(expected)),
      );
    });

    test(
      ".printMessage() prints the given message to the message sink",
      () {
        Logger.setup(
          errorSink: unimplementedSink,
          messageSink: messageSink,
        );
        const expected = 'message';

        expect(
          () => Logger.printMessage(expected),
          prints(equalsIgnoringWhitespace(expected)),
        );
      },
    );

    test(
      ".printLog() prints the given message to the message sink if the verbose is true",
      () {
        Logger.setup(
          errorSink: unimplementedSink,
          messageSink: messageSink,
          verbose: true,
        );
        const expected = 'log';

        expect(
          () => Logger.printLog(expected),
          prints(equalsIgnoringWhitespace(expected)),
        );
      },
    );

    test(
      ".printLog() does not print the given message to the message sink if the verbose is false",
      () {
        Logger.setup(
          errorSink: unimplementedSink,
          messageSink: messageSink,
          verbose: false,
        );
        const expected = 'log';

        expect(
          () => Logger.printLog(expected),
          prints(equalsIgnoringWhitespace('')),
        );
      },
    );
  });
}

/// A stub class for the [IOSink] providing a test implementation.
class IOSinkStub implements IOSink {
  /// A callback for the [writeln] method used to replace the default
  /// implementation.
  final void Function(Object) writelnCallback;

  @override
  Encoding encoding;

  /// Creates an instance of this [IOSinkStub].
  ///
  /// The [writelnCallback] is optional.
  IOSinkStub({
    this.writelnCallback,
  });

  @override
  void writeln([Object obj = ""]) {
    if (writelnCallback != null) {
      writelnCallback(obj);
    } else {
      print(obj);
    }
  }

  @override
  void add(List<int> data) {}

  @override
  void addError(Object error, [StackTrace stackTrace]) {}

  @override
  Future addStream(Stream<List<int>> stream) => Future.value(null);

  @override
  Future close() => Future.value(null);

  @override
  Future get done => Future.value(null);

  @override
  Future flush() => Future.value(null);

  @override
  void write(Object obj) {}

  @override
  void writeAll(Iterable objects, [String separator = ""]) {}

  @override
  void writeCharCode(int charCode) {}
}
