import 'dart:io';

import 'package:cli/runner/metrics_command_runner.dart';
import 'package:cli/util/prompt_util.dart';
import 'package:cli/util/prompt_wrapper.dart';

Future main(List<String> arguments) async {
  final promptWrapper = PromptWrapper();
  PromptUtil.init(promptWrapper);

  final runner = MetricsCommandRunner();

  try {
    await runner.run(arguments);
    exit(0);
  } catch (error) {
    exit(1);
  }
}
