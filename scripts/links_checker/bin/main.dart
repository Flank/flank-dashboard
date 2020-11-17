import 'dart:io';

import 'package:links_checker/runner/links_checker_runner.dart';

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
