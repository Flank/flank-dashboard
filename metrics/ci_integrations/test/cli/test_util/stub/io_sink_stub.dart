import 'dart:convert';
import 'dart:io';

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
  Future addStream(Stream<List<int>> stream) => Future.value();

  @override
  Future close() => Future.value();

  @override
  Future get done => Future.value();

  @override
  Future flush() => Future.value();

  @override
  void write(Object obj) {}

  @override
  void writeAll(Iterable objects, [String separator = ""]) {}

  @override
  void writeCharCode(int charCode) {}
}
