// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/services/common/cli/cli.dart';

/// A base class for [Cli]s with authorization.
abstract class AuthCli extends Cli {
  /// The name of the authorization flag.
  String get authArgumentName;

  /// Indicates whether the [_authArgument] is leading.
  bool get isAuthLeading;

  /// An authorization value.
  ///
  /// Most commonly represents the value of the access token.
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
  Future<ProcessResult> runWithOptionalAuth(
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

  /// Adds the [_authArgument] to the [arguments] list if the [_authorization]
  /// is not `null`.
  ///
  /// If [isAuthLeading], adding the [_authArgument] at the beginning of
  /// the [arguments] list. Otherwise, adding the [_authArgument] at the end of
  /// the [arguments] list.
  List<String> _addAuthArgument(List<String> arguments) {
    if (_authorization == null) return arguments;

    if (isAuthLeading) {
      final authArgumentList = [_authArgument];

      return authArgumentList..addAll(arguments);
    }

    return arguments..add(_authArgument);
  }
}
