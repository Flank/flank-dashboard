// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:args/command_runner.dart';
import 'package:guardian/config/helper/config_helper.dart';
import 'package:guardian/config/model/config.dart';

abstract class GuardianCommand<T> extends Command<T> {
  final ConfigHelper _configHelper = ConfigHelper();

  String get configurationsFilename;

  Config get config;

  void addConfigOptionByNames(List<String> names) {
    if (names == null) return;

    for (final name in names) {
      final field = config?.fields?.firstWhere(
        (field) => field.name == name,
        orElse: () => null,
      );

      if (field != null) {
        argParser.addOption(
          field.name,
          help: field.description,
          defaultsTo: field.value?.toString(),
        );
      }
    }
  }

  Map<String, dynamic> loadConfigurations() {
    if (_configHelper.checkExists(configurationsFilename)) {
      return _configHelper.readConfigs(configurationsFilename);
    }

    return {};
  }
}
