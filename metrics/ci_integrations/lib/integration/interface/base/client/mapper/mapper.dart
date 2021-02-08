// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// A class that represents the mapper interface.
abstract class Mapper<SourceType, DestinationType> {
  /// Maps the given [value] of [SourceType] to the value of [DestinationType].
  DestinationType map(SourceType value);

  /// Unmaps the given [value] of [DestinationType] to the value of [SourceType].
  SourceType unmap(DestinationType value);
}
