// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/flutter/adapter/flutter_cli_service_adapter.dart';
import 'package:cli/flutter/cli/flutter_cli.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';

void main() {
  group("FlutterCliServiceAdapter", () {
    const path = './test';
    final flutterCli = _FlutterCliMock();
    final flutterCliServiceAdapter = FlutterCliServiceAdapter(flutterCli);

    tearDown(() {
      reset(flutterCli);
    });

    test(
      "throws an ArgumentError if the given Flutter CLI is null",
      () {
        expect(() => FlutterCliServiceAdapter(null), throwsArgumentError);
      },
    );

    test(
      ".version() shows the version information",
      () async {
        await flutterCliServiceAdapter.version();

        verify(flutterCli.version()).called(once);
      },
    );

    test(
      ".build() builds the web application in the given path",
      () async {
        await flutterCliServiceAdapter.build(path);

        verify(flutterCli.buildWeb(path)).called(once);
      },
    );

    test(
      ".build() enables web support",
      () async {
        await flutterCliServiceAdapter.build(path);

        verify(flutterCli.enableWeb()).called(once);
      },
    );

    test(
      ".build() enables web support before building the web application",
      () async {
        await flutterCliServiceAdapter.build(path);

        verifyInOrder([
          flutterCli.enableWeb(),
          flutterCli.buildWeb(path),
        ]);
      },
    );
  });
}

class _FlutterCliMock extends Mock implements FlutterCli {}
