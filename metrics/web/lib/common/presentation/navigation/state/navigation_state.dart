// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// A class used to interact with the navigation state.
abstract class NavigationState {
  /// Replaces the navigation state with the given parameters.
  ///
  /// The [data] represents the data associated with the navigation state with
  /// which the current state will be replaced.
  /// The [title] is a title of the navigation state with which the current state
  /// will be replaced.
  /// The [path] parameter represents the path of the navigation state with
  /// which the current state will be replaced.
  void replaceState(dynamic data, String title, String path);
}
