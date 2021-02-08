// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// A class that represents the links checker [Exception].
class LinksCheckerException implements Exception {
  /// A list of errors that provides an information
  /// about concrete links checker exceptions.
  final List<String> errors;

  /// Creates a new instance of the [LinksCheckerException]
  /// with the given [errors].
  const LinksCheckerException(this.errors);

  @override
  String toString() {
    if (errors == null) return '';

    final errorsDescription = errors.join('\n');

    return 'Found ${errors.length} non-master links:\n$errorsDescription';
  }
}
