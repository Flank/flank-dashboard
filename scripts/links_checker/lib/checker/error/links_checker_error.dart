// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// A class that represents the links checker [Error].
class LinksCheckerError extends Error {
  /// A [List] of error descriptions that provides an information
  /// about concrete links checker errors.
  final List<String> errors;

  /// Creates a new instance of the [LinksCheckerError]
  /// with the given [errors].
  LinksCheckerError(this.errors);

  @override
  String toString() {
    if (errors == null) return '';

    final errorsDescription = errors.join('\n');

    return 'Found ${errors.length} non-master links:\n$errorsDescription';
  }
}
