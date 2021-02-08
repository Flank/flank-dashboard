// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:sentry/sentry.dart';

/// A base class for event processors that are used within
/// the Sentry integration to process [SentryEvent]s.
abstract class SentryEventProcessor {
  /// Invokes this processor with the given [event] and its optional [hint].
  ///
  /// If this processor results with `null`, the event won't be sent to Sentry.
  FutureOr<SentryEvent> call(SentryEvent event, {dynamic hint});
}
