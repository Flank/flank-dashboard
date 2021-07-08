// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/services/common/cli/auth_cli.dart';
import 'package:test/test.dart';

void main() {
  group("AuthCli", () {
    const authorization = 'authorization';

    final testArguments = ['testArgument1', 'testArgument2'];

    String composeAuthArgument(String authArgumentName, String authorization) {
      return '--$authArgumentName=$authorization';
    }

    test(
      ".setupAuth() throws an ArgumentError if the given authorization is null",
      () {
        final authCli = _AuthCliFake();

        expect(
          () => authCli.setupAuth(null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".runWithAuth() composes an auth argument of the auth argument name and the authorization",
      () async {
        final authCli = _AuthCliFake();
        final authArgumentName = authCli.authArgumentName;
        final expected = composeAuthArgument(authArgumentName, authorization);

        authCli.setupAuth(authorization);
        await authCli.runWithAuth(testArguments);

        final authArgument = authCli.lastArguments.last;

        expect(authArgument, equals(expected));
      },
    );

    test(
      ".runWithAuth() adds an auth argument to the beginning of the arguments list if the authorization is leading",
      () async {
        final authCli = _AuthCliFake(isAuthLeading: true);
        final authArgumentName = authCli.authArgumentName;
        final expected = composeAuthArgument(authArgumentName, authorization);

        authCli.setupAuth(authorization);
        await authCli.runWithAuth(testArguments);

        final arguments = authCli.lastArguments;

        expect(arguments.first, equals(expected));
      },
    );

    test(
      ".runWithAuth() adds an auth argument to the end of the arguments list if the authorization is not leading",
      () async {
        final authCli = _AuthCliFake(isAuthLeading: false);
        final authArgumentName = authCli.authArgumentName;
        final expected = composeAuthArgument(authArgumentName, authorization);

        authCli.setupAuth(authorization);
        await authCli.runWithAuth(testArguments);

        final arguments = authCli.lastArguments;

        expect(arguments.last, equals(expected));
      },
    );

    test(
      ".runWithAuth() does not add authorization to arguments if the authorization value is null",
      () async {
        final authCli = _AuthCliFake();

        authCli.resetAuth();
        await authCli.runWithAuth(testArguments);

        expect(authCli.lastArguments, equals(testArguments));
      },
    );
  });
}

/// A fake implementation of the [AuthCli] that is used for testing.
class _AuthCliFake extends AuthCli {
  /// Indicates whether the authorization should be a leading argument
  /// for this CLI.
  final bool _isAuthLeading;

  /// Stores the list of arguments the [run] method was called with last time.
  List<String> _arguments;

  /// Provides a list of last arguments used in tests.
  List<String> get lastArguments => _arguments;

  @override
  String get authArgumentName => 'token';

  @override
  String get executable => 'test';

  @override
  bool get isAuthLeading => _isAuthLeading;

  /// Creates a new instance of the [_AuthCliFake].
  ///
  /// If the given [isAuthLeading] is `null`, the `false` value is used.
  _AuthCliFake({bool isAuthLeading}) : _isAuthLeading = isAuthLeading ?? false;

  @override
  Future<void> version() {
    throw UnimplementedError();
  }

  @override
  Future<ProcessResult> run(
    List<String> arguments, {
    bool attachOutput = true,
    String workingDirectory,
    Stream<List<int>> stdin,
  }) async {
    _arguments = arguments;

    return null;
  }
}
