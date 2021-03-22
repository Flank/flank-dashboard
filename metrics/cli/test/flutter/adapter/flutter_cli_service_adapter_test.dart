import 'package:cli/flutter/adapter/flutter_cli_service_adapter.dart';
import 'package:cli/flutter/cli/flutter_cli.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../test_utils/matchers.dart';

void main() {
  group("FlutterCliServiceAdapter", () {
    final flutterCliMock = _FlutterCliMock();
    final flutterCliServiceAdapter = FlutterCliServiceAdapter(flutterCliMock);

    test("throws an AssertionError if the given flutter CLI is null", () {
      expect(() => FlutterCliServiceAdapter(null), throwsAssertionError);
    });

    test(".version() shows the version information", () async {
      await flutterCliServiceAdapter.version();
      verify(flutterCliMock.version()).called(once);
    });

    test(
      ".build() enables web support and builds the web application in the given path",
      () async {
        const path = './test';

        await flutterCliServiceAdapter.build(path);

        verifyInOrder([
          flutterCliMock.enableWeb(),
          flutterCliMock.buildWeb(path),
        ]);
      },
    );
  });
}

class _FlutterCliMock extends Mock implements FlutterCli {}
