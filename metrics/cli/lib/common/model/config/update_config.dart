// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/model/config/firebase_config.dart';
import 'package:cli/common/model/config/sentry_config.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents an update configuration.
class UpdateConfig extends Equatable {
  /// A Firebase configuration.
  final FirebaseConfig firebaseConfig;

  /// A Sentry configuration.
  final SentryConfig sentryConfig;

  @override
  List<Object> get props => [firebaseConfig, sentryConfig];

  /// Creates a new instance of the [UpdateConfig] with the given parameters.
  ///
  /// Throws an [ArgumentError] if the given [firebaseConfig] is `null`.
  UpdateConfig({
    @required this.firebaseConfig,
    this.sentryConfig,
  }) {
    ArgumentError.checkNotNull(firebaseConfig, 'firebaseConfig');
  }

  /// Creates a new instance of the [UpdateConfig] from the given [json].
  ///
  /// Returns `null` if the given [json] is `null`.
  factory UpdateConfig.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final firebaseJson = json['firebase'] as Map<String, dynamic>;
    final sentryJson = json['sentry'] as Map<String, dynamic>;

    return UpdateConfig(
      firebaseConfig: FirebaseConfig.fromJson(firebaseJson),
      sentryConfig: SentryConfig.fromJson(sentryJson),
    );
  }
}
