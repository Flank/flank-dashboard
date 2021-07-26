// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/util/dependencies/dependencies.dart';
import 'package:cli/util/file/file_helper.dart';
import 'package:yaml_map/yaml_map.dart';

/// A class providing method for creating a [Dependencies] instance.
class DependenciesFactory {
  /// Creates a new instance of the [DependenciesFactory];
  const DependenciesFactory();

  /// Creates a new instance of [Dependencies] from the file located by the
  /// given [path].
  ///
  /// Returns `null` if the file by the given [path] does not exist.
  Dependencies create(String path) {
    const fileHelper = FileHelper();
    final file = fileHelper.getFile(path);

    if (file?.existsSync() == false) {
      return null;
    }

    const parser = YamlMapParser();
    final parsedYaml = parser.parse(file.readAsStringSync());

    return Dependencies.fromMap(parsedYaml);
  }
}
