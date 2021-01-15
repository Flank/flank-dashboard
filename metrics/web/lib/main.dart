import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_app/metrics_app.dart';
import 'package:metrics/metrics_logger/metrics_logger.dart';
import 'package:metrics/metrics_logger/sentry/event_processors/user_agent_event_processor.dart';
import 'package:metrics/metrics_logger/sentry/writers/sentry_writer.dart';
import 'package:metrics/metrics_logger/writers/console_writer.dart';
import 'package:metrics/metrics_logger/writers/logger_writer.dart';
import 'package:metrics/util/app_configuration_util.dart'
    if (dart.library.html) 'package:metrics/platform/web/web_app_configuration_util.dart';
import 'package:metrics/util/favicon.dart';
import 'package:universal_html/html.dart';

import 'package:metrics/platform/stub/metrics_config/metrics_config_factory.dart'
    if (dart.library.html) 'package:metrics/platform/web/metrics_config/metrics_config_factory.dart';

Future<void> main() async {
  AppConfigurationUtil.configureApp();
  Favicon().setup();

  LoggerWriter writer;

  final configFactory = MetricsConfigFactory();
  final metricsConfig = configFactory.create();

  if (kReleaseMode) {
    final userAgent = window?.navigator?.userAgent;
    final eventProcessor = UserAgentEventProcessor(userAgent);
    writer = await SentryWriter.init(
      metricsConfig.sentryDsn,
      metricsConfig.sentryRelease,
      metricsConfig.sentryEnvironment,
      eventProcessor: eventProcessor,
    );
  } else {
    writer = ConsoleWriter();
  }

  await MetricsLogger.initialize(writer);

  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (details, {bool forceReport = false}) {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    };

    runApp(MetricsApp(
      metricsConfig: metricsConfig,
    ));
  }, (Object error, StackTrace stackTrace) async {
    await MetricsLogger.logError(error, stackTrace);
  });
}
