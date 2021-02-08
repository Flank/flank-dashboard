// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:metrics/metrics_logger/sentry/event_processors/sentry_event_processor.dart';
import 'package:sentry/sentry.dart';

/// A [SentryEventProcessor] that adds the user agent header
/// to the [SentryEvent.request].
class UserAgentEventProcessor implements SentryEventProcessor {
  /// A a characteristic [String] that contains information about the
  /// browser and operating system.
  final String userAgent;

  /// Creates a new instance of the [UserAgentEventProcessor] with the given
  /// [userAgent].
  const UserAgentEventProcessor(this.userAgent);

  @override
  SentryEvent call(SentryEvent event, {dynamic hint}) {
    if (event == null) return event;

    final request = event.request ?? Request();
    final headers = request.headers ?? {};

    final newHeaders = Map<String, String>.from(headers);
    newHeaders[HttpHeaders.userAgentHeader] = userAgent;

    final newRequest = request.copyWith(headers: newHeaders);

    return event.copyWith(request: newRequest);
  }
}
