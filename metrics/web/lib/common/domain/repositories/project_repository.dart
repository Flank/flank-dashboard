import 'package:metrics_core/metrics_core.dart';

/// Base class for projects repositories.
///
/// Provides an ability to get the projects data.
abstract class ProjectRepository {
  /// Provides the stream of [Project]s.
  Stream<List<Project>> projectsStream();
}
