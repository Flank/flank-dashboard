// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/parser/config_parser.dart';
import 'package:ci_integration/integration/interface/source/config/model/source_config.dart';

/// An abstract class providing methods for parsing a source
/// configuration [Map] into the [SourceConfig] instance.
abstract class SourceConfigParser<T extends SourceConfig>
    extends ConfigParser<T> {}
