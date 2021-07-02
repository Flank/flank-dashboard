import 'dart:io';

import 'package:cli/services/common/cli/cli.dart';

/// A base class for [Cli]s with authorization.
abstract class AuthCli extends Cli {
  /// The name of the auth flag.
  String get authArgumentName;

  /// Indicates whether the authorization is leading.
  bool get isAuthLeading;

  /// An auth token argument this [Cli] uses to authorize its commands.
  String _authorization;

  /// Initializes the authorization for this [Cli] with the given [authorization].
  void setupAuth(String authorization) {
    _authorization = ArgumentError.checkNotNull(authorization);
  }

  /// Resets the auth.
  void resetAuth() {
    _authorization = null;
  }

  /// Starts a process running [executable] in the [workingDirectory]
  /// with the specified [arguments]. Adds an auth argument to the [arguments]
  /// list if the [_authorization] is not null.
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

  /// Adds an auth argument to the list of the [arguments]
  /// if the [_authorization] is not null.
  ///
  /// If [isAuthLeading] adding the auth argument to the beginning of
  /// the [arguments] list. Otherwise, adding the auth argument to the end of
  /// the [arguments] list.
  List<String> _addAuthArgument(List<String> arguments) {
    if (_authorization == null) return arguments;

    final authArgument = '--$authArgumentName=$_authorization';

    if (isAuthLeading) {
      final authArgumentList = [authArgument];

      return authArgumentList..addAll(arguments);
    }

    return arguments..add(authArgument);
  }
}
