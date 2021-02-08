// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:guardian/config/model/config.dart';
import 'package:yaml_map/yaml_map.dart';

class ConfigHelper {
  static const YamlMapParser yamlParser = YamlMapParser();
  final Directory configDirectory;
  final YamlMapFormatter yamlFormatter;

  ConfigHelper({
    Directory configDirectory,
    int yamlIndentationLength = 2,
  })  : configDirectory = configDirectory ?? _getDirectoryFromPlatform(),
        yamlFormatter = YamlMapFormatter(
          spacesPerIndentationLevel: yamlIndentationLength,
        );

  static Directory _getDirectoryFromPlatform() {
    final scriptUri = Platform.script;
    final pathSegments = scriptUri.pathSegments;
    final directoryPathSegments = pathSegments.toList()..removeLast();
    return Directory(directoryPathSegments.join(Platform.pathSeparator));
  }

  String _configFilepath(String filename) {
    return '${Platform.pathSeparator}${configDirectory.path}'
        '${Platform.pathSeparator}$filename';
  }

  Config build(Config config, {bool showEmptyFields = false}) {
    final _local = config.copy();

    for (final configField in _local.fields) {
      stdout.write(configField.editFieldString(
        showEmptyValue: showEmptyFields,
      ));

      try {
        final input = stdin.readLineSync();
        if (input == null || input.isEmpty) {
          continue;
        } else {
          configField.setter(input);
        }
      } catch (error) {
        print(error);
        stderr.writeln('Invalid value. Please, try again');
      }
    }

    return _local;
  }

  bool checkExists(String filename) {
    final file = File(_configFilepath(filename));
    return file.existsSync();
  }

  File writeConfigs(Config config) {
    final filename = config.filename;
    final file = File(_configFilepath(filename));

    file.writeAsStringSync(
      yamlFormatter.format(config.toMap()),
      mode: FileMode.writeOnly,
    );

    return file;
  }

  Map<String, dynamic> readConfigs(String filename) {
    final file = File(_configFilepath(filename));
    return yamlParser.parse(file.readAsStringSync());
  }

  void removeConfigs(String filename) {
    final file = File(_configFilepath(filename));
    return file.deleteSync();
  }
}
