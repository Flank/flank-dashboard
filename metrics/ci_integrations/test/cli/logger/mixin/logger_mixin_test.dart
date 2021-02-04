// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/logger/manager/logger_manager.dart';
import 'package:ci_integration/cli/logger/mixin/logger_mixin.dart';
import 'package:test/test.dart';

void main() {
  group("LoggerMixin", () {
    tearDownAll(() {
      LoggerManager.instance.reset();
    });

    test(
      ".logger returns a logger for a source class mixed with logger mixin",
      () {
        final stub = _ClassStub();
        final logger = stub.logger;

        expect(logger.sourceClass, equals(_ClassStub));
      },
    );
  });
}

/// A class stub to test the [LoggerMixin] members.
class _ClassStub with LoggerMixin {}
