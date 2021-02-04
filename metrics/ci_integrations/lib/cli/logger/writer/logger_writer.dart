// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// An abstract class for logger writers that provide methods to write messages
/// to the logs output.
abstract class LoggerWriter {
  /// Writes the given [message] to the logs output of this writer.
  void write(Object message);
}
