/// A base class for analytics repositories.
///
/// Provides an ability to log user activities.
abstract class AnalyticsRepository {
  /// Provides an ability to log user logins.
  Future<void> logLogin(String id);

  /// Provides an ability to log page changes.
  Future<void> logPageView(String pageName);
}
