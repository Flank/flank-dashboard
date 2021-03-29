// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/flutter/service/flutter_service.dart';
import 'package:cli/gcloud/service/gcloud_service.dart';

/// A class that holds services needed to deploy the Metrics application.
class Services {
  /// A service that provides methods for working with Flutter.
  final FlutterService flutterService;

  /// A service that provides methods for working with GCloud.
  final GCloudService gcloudService;

  /// Creates a new instance of the [Services] with the given services.
  ///
  /// Throws an [ArgumentError] if the given [flutterService] is `null`.
  /// Throws an [ArgumentError] if the given [gcloudService] is `null`.
  Services({
    this.flutterService,
    this.gcloudService,
  }) {
    ArgumentError.checkNotNull(flutterService, 'flutterService');
    ArgumentError.checkNotNull(gcloudService, 'gcloudService');
  }
}
