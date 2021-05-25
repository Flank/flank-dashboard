// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:links_checker/cli/runner/links_checker_runner.dart';

Future<void> main(List<String> args) async {
  final runner = LinksCheckerRunner();

  try {
    await runner.run(args);

    exit(0);
  } catch (e) {
    stderr.writeln(e);
    exit(1);
  }
}
