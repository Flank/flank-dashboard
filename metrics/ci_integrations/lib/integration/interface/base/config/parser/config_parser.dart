// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';

/// An abstract class providing methods for parsing a
/// configuration [Map] into the [Config] instance.
abstract class ConfigParser<T extends Config> {
  /// Parses the given [map] into the [Config] instance.
  ///
  /// Returns `null` if [map] is `null`.
  T parse(Map<String, dynamic> map);

  /// Checks whether this parser is able to parse the given [map].
  ///
  /// Returns `false` if [map] is `null`.
  bool canParse(Map<String, dynamic> map);
}
