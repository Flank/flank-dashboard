/// A base class for CLIs that provides common methods for them.
abstract class Cli {
  /// Shows the version information of this CLI.
  Future<void> version();
}
