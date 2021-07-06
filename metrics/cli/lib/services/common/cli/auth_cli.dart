// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/services/common/cli/cli.dart';

/// A base class for [Cli]s that support authorization.
abstract class AuthCli extends Cli {
  /// A name of the authorization argument of this CLI.
  ///
  /// This name is used as the name of the option that is used to pass
  /// the authorization value to the CLI.
  String get authArgumentName;

  /// Indicates whether the authorization should be a leading argument
  /// for this CLI.
  ///
  /// If `true` the authorization argument is applied as the very first in
  /// the list of arguments. Otherwise, it is added to the end of
  /// the arguments list.
  bool get isAuthLeading => false;

  /// An authorization value.
  ///
  /// This is specific to the concrete implementation but usually represents
  /// the access token value to use for the authorization.
  String _authorization;

  /// Returns an auth argument composing of the [authArgumentName] and
  /// the [_authorization].
  ///
  /// This [Cli] uses the auth argument to authorize its commands.
  String get _authArgument => '--$authArgumentName=$_authorization';

  /// Initializes the authorization for this [Cli] with
  /// the given [authorization].
  ///
  /// Throws an [ArgumentError] if the given [authorization] is `null`.
  void setupAuth(String authorization) {
    _authorization = ArgumentError.checkNotNull(authorization);
  }

  /// Resets the [_authorization] value.
  void resetAuth() {
    _authorization = null;
  }

  /// Starts a process running [executable] in the [workingDirectory]
  /// with the specified [arguments].
  ///
  /// Adds the [_authArgument] to the [arguments] list if the [_authorization]
  /// is not `null`.
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
  /// the [_authorization] value is not `null`.
  ///
  /// If [isAuthLeading] is `true`, adds the [_authArgument] to the beginning of
  /// the [arguments] list. Otherwise, adds the [_authArgument] to the end of
  /// the [arguments] list.
  List<String> _addAuthArgument(List<String> arguments) {
    if (_authorization == null) return arguments;

    final newArgs = List<String>.from(arguments);

    if (isAuthLeading) {
      newArgs.insert(0, _authArgument);
    } else {
      newArgs.add(_authArgument);
    }

    return newArgs;
  }
}
