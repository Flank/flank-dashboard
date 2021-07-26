// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/util/dependencies/dependencies.dart';
import 'package:cli/util/file/file_helper.dart';
import 'package:yaml_map/yaml_map.dart';

/// A class providing method for creating a [Dependencies] instance.
class DependenciesFactory {
  /// A [FileHelper] this factory uses to get the YAML dependencies file.
  final FileHelper _fileHelper;

  /// A [YamlMapParser] this factory uses to parse the YAML dependencies file.
  final YamlMapParser _yamlMapParser;

  /// Creates a new instance of the [DependenciesFactory];
  ///
  /// If the given [fileHelper] is `null`, an instance of the [FileHelper]
  /// is used.
  /// If the given [yamlMapParser] is `null`, an instance of the [YamlMapParser]
  /// is used.
  const DependenciesFactory({
    FileHelper fileHelper,
    YamlMapParser yamlMapParser,
  })  : _fileHelper = fileHelper ?? const FileHelper(),
        _yamlMapParser = yamlMapParser ?? const YamlMapParser();

  /// Creates a new instance of [Dependencies] from the file located by the
  /// given [path].
  ///
  /// Returns `null` if the file by the given [path] does not exist.
  ///
  /// Throws an [ArgumentError] if the given [path] is `null`.
  Dependencies create(String path) {
    ArgumentError.checkNotNull(path);

    final file = _fileHelper.getFile(path);

    if (!file.existsSync()) {
      return null;
    }

    final dependenciesMap = _yamlMapParser.parse(file.readAsStringSync());

    return Dependencies.fromMap(dependenciesMap);
  }
}
