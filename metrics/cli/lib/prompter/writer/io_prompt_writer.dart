// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/prompter/writer/prompt_writer.dart';

/// A [PromptWriter] implementation that uses the [Stdin] and the [Stdout]
/// to prompt.
class IOPromptWriter implements PromptWriter {
  /// A standard input stream of data used by this writer.
  final Stdin _stdin;

  /// A standard output stream of data used by this writer.
  final Stdout _stdout;

  /// A standard error output stream used by this writer.
  final Stdout _stderr;

  /// Creates a new instance of the [IOPromptWriter].
  ///
  /// If the given [inputStream] is `null`, the [stdin] is used.
  /// If the given [outputStream] is `null`, the [stdout] is used.
  /// If the given [errorStream] is `null`, the [stderr] is used.
  IOPromptWriter({
    Stdin inputStream,
    Stdout outputStream,
    Stdout errorStream,
  })  : _stdin = inputStream ?? stdin,
        _stdout = outputStream ?? stdout,
        _stderr = errorStream ?? stderr;

  @override
  void info(String text) {
    _stdout.writeln(text);
  }

  @override
  void error(Object error) {
    _stderr.writeln(error);
  }

  @override
  String prompt(String text) {
    info(text);

    return _stdin.readLineSync();
  }

  @override
  bool promptConfirm(String text, String confirmInput) {
    info(text);

    final userInput = _stdin.readLineSync();

    return userInput?.toLowerCase() == confirmInput?.toLowerCase();
  }
}
