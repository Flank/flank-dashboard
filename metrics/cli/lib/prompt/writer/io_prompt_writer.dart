// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/prompt/writer/prompt_writer.dart';

/// A [PromptWriter] implementation that uses the [Stdin] and the [Stdout]
/// to prompt.
class IOPromptWriter extends PromptWriter {
  /// The standard input stream of data used by this writer.
  final Stdin _stdin;

  /// The standard output stream of data used by this writer.
  final Stdout _stdout;

  /// Creates a new instance of the [IOPromptWriter].
  ///
  /// If the [inputStream] is null, a [stdin] used.
  /// If the [outputStream] is null, a [stdout] used.
  IOPromptWriter({
    Stdin inputStream,
    Stdout outputStream,
  })  : _stdin = inputStream ?? stdin,
        _stdout = outputStream ?? stdout;

  @override
  String prompt(String text) {
    _stdout.writeln(text);

    return _stdin.readLineSync();
  }

  @override
  bool promptConfirm(String text, String confirmInput) {
    _stdout.writeln(text);

    final userInput = _stdin.readLineSync();

    return userInput?.toLowerCase() == confirmInput?.toLowerCase();
  }

  @override
  Future<void> dispose() async {
    await _stdout.flush();

    return _stdout.close();
  }
}
