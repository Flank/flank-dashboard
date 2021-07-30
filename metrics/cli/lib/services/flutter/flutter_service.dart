// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/common/info_service.dart';
import 'package:cli/services/common/service/model/service_name.dart';

/// An abstract class for Flutter service that provides methods
/// for working with Flutter.
abstract class FlutterService extends InfoService {
  @override
  ServiceName get serviceName => ServiceName.flutter;

  /// Builds a Flutter application located in the given [appPath].
  Future<void> build(String appPath);
}
