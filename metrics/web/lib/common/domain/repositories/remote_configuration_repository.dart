import 'package:metrics/common/domain/entities/remote_configuration.dart';

/// A base class for remote configuration repositories.
///
/// Provides an ability to get the remote configuration data.
abstract class RemoteConfigurationRepository {
  /// Applies the default values for the remote configuration.
  void applyDefaults(Map<String, dynamic> defaults);

  /// Fetches parameter values from the remote configuration service.
  Future<void> fetch();

  /// Makes fetched parameters available for getters.
  Future<void> activate();

  /// Returns an instance of the [RemoteConfiguration].
  RemoteConfiguration getConfiguration();
}
