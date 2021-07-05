// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/common/cli/auth_cli.dart';
import 'package:test/test.dart';

void main() {
  group("AuthCli", () {
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
  });
}

/// A fake implementation of the [AuthCli] that is used for testing.
class _AuthCliFake extends AuthCli {
  @override
  String get authArgumentName => throw UnimplementedError();

  @override
  String get executable => throw UnimplementedError();

  @override
  bool get isAuthLeading => throw UnimplementedError();

  @override
  Future<void> version() {
    throw UnimplementedError();
  }
}
