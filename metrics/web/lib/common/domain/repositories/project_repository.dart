// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';

/// A base class for projects repositories.
///
/// Provides an ability to get the projects data.
abstract class ProjectRepository {
  /// Provides the stream of [Project]s.
  Stream<List<Project>> projectsStream();
}
