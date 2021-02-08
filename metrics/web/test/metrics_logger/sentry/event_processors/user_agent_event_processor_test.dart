// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:test/test.dart';
import 'package:metrics/metrics_logger/sentry/event_processors/user_agent_event_processor.dart';
import 'package:sentry/sentry.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("UserAgentEventProcessor", () {
    const userAgent = 'test-user-agent';
    const processor = UserAgentEventProcessor(userAgent);

    test(
      "creates an instance with the given user agent",
      () {
        const processor = UserAgentEventProcessor(userAgent);

        expect(processor.userAgent, equals(userAgent));
      },
    );

    test(
      ".call() returns null if the given event is null",
      () {
        final processed = processor.call(null);

        expect(processed, isNull);
      },
    );

    test(
      ".call() returns the event with request headers containing the given user agent value",
      () {
        final processed = processor.call(SentryEvent());

        final headers = processed.request.headers;

        expect(headers, containsPair(HttpHeaders.userAgentHeader, userAgent));
      },
    );

    test(
      ".call() updates the request of the given event with the user agent header",
      () {
        const headerKey = 'test-header';
        const headerValue = 'test-value';
        const expectedHeaders = {
          headerKey: headerValue,
          HttpHeaders.userAgentHeader: userAgent,
        };
        final event = SentryEvent(
          request: Request(headers: const {headerKey: headerValue}),
        );

        final processed = processor.call(event);
        final newHeaders = processed.request.headers;

        expect(newHeaders, equals(expectedHeaders));
      },
    );
  });
}
