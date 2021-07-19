// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/cli/updater/config/parser/update_config_parser.dart';
import 'package:cli/common/model/config/update_config.dart';
import 'package:cli/util/file/file_helper.dart';

/// A class that provides a method for creating an [UpdateConfig] instance.
class UpdateConfigFactory {
  /// A [FileHelper] this factory uses to get the YAML configuration file.
  final FileHelper _fileHelper;

  /// An [UpdateConfigParser] this factory uses to parse the content
  /// of the YAML configuration file to the [UpdateConfig].
  final UpdateConfigParser _configParser;

  /// Creates a new instance of the [UpdateConfigFactory].
  ///
  /// If the given [fileHelper] is `null`, an instance of the [FileHelper]
  /// is used.
  /// If the given [configParser] is `null`, an instance of the
  /// [UpdateConfigParser] is used.
  const UpdateConfigFactory({
    FileHelper fileHelper,
    UpdateConfigParser configParser,
  })  : _fileHelper = fileHelper ?? const FileHelper(),
        _configParser = configParser ?? const UpdateConfigParser();

  /// Creates a new instance of the [UpdateConfig] using the [configPath].
  ///
  /// A [configPath] is a [File.path] of the YAML configuration file.
  ///
  /// Throws an [ArgumentError] if the given [configPath] is `null`.
  UpdateConfig create(String configPath) {
    ArgumentError.checkNotNull(configPath, 'configPath');

    final configFile = _fileHelper.getFile(configPath);
    final configContent = configFile.readAsStringSync();

    return _configParser.parse(configContent);
  }
}
