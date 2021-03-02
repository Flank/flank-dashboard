// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:ci_integration/cli/config/model/raw_integration_config.dart';
import 'package:ci_integration/cli/config/parser/raw_integration_config_parser.dart';
import 'package:ci_integration/util/file/file_reader.dart';

/// A class that is responsible for creating [RawIntegrationConfigParser].
class RawIntegrationConfigFactory {
  /// A [FileReader] this factory uses to read the contents of the YAML
  /// configuration file.
  final FileReader fileReader;

  /// A [RawIntegrationConfigParser] this factory uses to parse the contents
  /// of the YAML configuration file to the [RawIntegrationConfig].
  final RawIntegrationConfigParser rawConfigParser;

  /// Creates a new instance of the [RawIntegrationConfigFactory] with the given
  /// [fileReader] and [rawConfigParser].
  ///
  /// If the given [fileReader] is `null`, an instance of the [FileReader]
  /// is used.
  /// If the given [rawConfigParser] is `null`, an instance
  /// of the [RawIntegrationConfigParser] is used.
  const RawIntegrationConfigFactory({
    FileReader fileReader,
    RawIntegrationConfigParser rawConfigParser,
  })  : fileReader = fileReader ?? const FileReader(),
        rawConfigParser = rawConfigParser ?? const RawIntegrationConfigParser();

  /// Creates a [RawIntegrationConfig] using the given [configPath].
  ///
  /// A [configPath] is a [File.path] of the YAML configuration file.
  ///
  /// Throws an [ArgumentError] if the given [configPath] is `null`.
  RawIntegrationConfig create(String configPath) {
    ArgumentError.checkNotNull(configPath, 'configPath');

    final fileContent = fileReader.read(configPath);

    return rawConfigParser.parse(fileContent);
  }
}
