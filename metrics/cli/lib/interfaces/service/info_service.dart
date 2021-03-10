/// A base class for services that provides common methods for them.
abstract class InfoService {
  /// Shows the version information of the tool used by the service.
  Future<void> version();
}
