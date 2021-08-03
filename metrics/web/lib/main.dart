// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_app/metrics_app.dart';
import 'package:metrics/metrics_logger/metrics_logger.dart';
import 'package:metrics/metrics_logger/sentry/event_processors/user_agent_event_processor.dart';
import 'package:metrics/metrics_logger/sentry/writers/sentry_writer.dart';
import 'package:metrics/metrics_logger/writers/console_writer.dart';
import 'package:metrics/metrics_logger/writers/logger_writer.dart';
import 'package:metrics/platform/stub/metrics_config/metrics_config_factory.dart'
    if (dart.library.html) 'package:metrics/platform/web/metrics_config/metrics_config_factory.dart';
import 'package:metrics/platform/stub/platform_configuration/platform_configuration_stub.dart'
    if (dart.library.html) 'package:metrics/platform/web/platform_configuration/web_platform_configuration.dart';
import 'package:metrics/util/favicon.dart';
import 'package:universal_html/html.dart';

Future<void> main() async {
  PlatformConfiguration.configureApp();
  Favicon().setup();

  LoggerWriter writer;

  final configFactory = MetricsConfigFactory();
  final metricsConfig = configFactory.create();

  runApp(MetricsApp(
    metricsConfig: metricsConfig,
  ));
}
