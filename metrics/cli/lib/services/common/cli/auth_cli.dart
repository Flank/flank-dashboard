// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/services/common/cli/cli.dart';

/// A base class for [Cli]s that support authentication.
abstract class AuthCli extends Cli {
  /// A name of the authentication argument of this CLI.
  ///
  /// This name is used as the name of the option that is used to pass
  /// the authentication value to the CLI.
  String get authArgumentName;

  /// Indicates whether the authentication should be a leading argument
  /// for this CLI.
  ///
  /// If `true` the authentication argument is applied as the very first in
  /// the list of arguments. Otherwise, it is added to the end of
  /// the arguments list.
  bool get isAuthLeading => false;

  /// An authentication value.
  ///
  /// This is specific to the concrete implementation but usually represents
  /// the access token value to use for the authentication.
  String _authValue;

  /// Returns an authentication argument composing of the [authArgumentName] and
  /// the [_authValue].
  ///
  /// This [Cli] uses the authentication argument to authenticate its commands.
  String get _authArgument => '--$authArgumentName=$_authValue';

  /// Initializes the authentication value for this [Cli] with
  /// the given [auth].
  ///
  /// Throws an [ArgumentError] if the given [auth] is `null`.
  void setupAuth(String auth) {
    _authValue = ArgumentError.checkNotNull(auth, 'auth');
  }

  /// Resets the [_authValue] value.
  void resetAuth() {
    _authValue = null;
  }

  /// Starts a process running [executable] in the [workingDirectory]
  /// with the specified [arguments].
  ///
  /// Adds the authentication to the [arguments] list if the corresponding value
  /// is not `null` for this CLI.
  ///
  /// The [attachOutput] default value is `true`.
  Future<ProcessResult> runWithAuth(
    List<String> arguments, {
    bool attachOutput = true,
    String workingDirectory,
    Stream<List<int>> stdin,
  }) {
    final args = _addAuthArgument(arguments);

    return run(
      args,
      attachOutput: attachOutput,
      workingDirectory: workingDirectory,
      stdin: stdin,
    );
  }

  /// Adds the [_authArgument] to the given [arguments] list if
  /// the [_authValue] value is not `null`.
  ///
  /// If [isAuthLeading] is `true`, adds the [_authArgument] to the beginning of
  /// the [arguments] list. Otherwise, adds the [_authArgument] to the end of
  /// the [arguments] list.
  List<String> _addAuthArgument(List<String> arguments) {
    if (_authValue == null) return arguments;

    final newArgs = List<String>.from(arguments);

    if (isAuthLeading) {
      newArgs.insert(0, _authArgument);
    } else {
      newArgs.add(_authArgument);
    }

    return newArgs;
  }
}
