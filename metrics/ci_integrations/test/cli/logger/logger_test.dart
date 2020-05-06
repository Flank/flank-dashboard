import 'dart:convert';
import 'dart:io';

import 'package:ci_integration/cli/logger/logger.dart';
import 'package:test/test.dart';

void main() {
  group("Logger", () {
    final errorSink = IOSinkStub();
    final messageSink = IOSinkStub();

    test(
      "should create Logger with default stderr if no error sink is given",
      () {
        final logger = Logger(messageSink: messageSink);
        final errorSink = logger.errorSink;

        expect(errorSink, equals(stderr));
      },
    );

    test(
      "should create Logger with default stdout if no message sink is given",
      () {
        final logger = Logger(errorSink: errorSink);
        final messageSink = logger.messageSink;

        expect(messageSink, equals(stdout));
      },
    );

    test(".printError() should print the given error to the error sink", () {
      final unimplementedMessageSink = IOSinkStub(
        writelnCallback: (_) => throw UnimplementedError(),
      );
      final logger = Logger(
        errorSink: errorSink,
        messageSink: unimplementedMessageSink,
      );
      const expected = 'error';

      expect(
        () => logger.printError(expected),
        prints(equalsIgnoringWhitespace(expected)),
      );
    });

    test(
      ".printMessage() should print the given message to the message sink",
      () {
        final unimplementedErrorSink = IOSinkStub(
          writelnCallback: (_) => throw UnimplementedError(),
        );
        final logger = Logger(
          errorSink: unimplementedErrorSink,
          messageSink: messageSink,
        );
        const expected = 'message';

        expect(
          () => logger.printMessage(expected),
          prints(equalsIgnoringWhitespace(expected)),
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
