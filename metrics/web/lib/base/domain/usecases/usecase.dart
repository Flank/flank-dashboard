// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// A base class for all use cases.
abstract class UseCase<Type, Params> {
  /// A base method to invoke this use case with the given [params].
  Type call(Params params);
}
