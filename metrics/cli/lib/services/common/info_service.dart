// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:cli/services/common/service/model/service_name.dart';

/// A base class for info services that provides common methods
/// for getting information about service.
abstract class InfoService {
  /// A [ServiceName] that represents the name of this service.
  ServiceName get serviceName;

  /// Shows the version information of this service.
  Future<ProcessResult> version();
}
