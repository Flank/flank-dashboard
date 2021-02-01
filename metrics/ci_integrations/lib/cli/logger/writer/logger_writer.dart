/// An abstract class for logger writers that provide methods to write messages
/// to the logs output.
abstract class LoggerWriter {
  /// Writes the given [message] to the logs output of this writer.
  void write(Object message);
}
