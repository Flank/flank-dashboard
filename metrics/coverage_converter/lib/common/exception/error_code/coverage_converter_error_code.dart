// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// A enum that represents the coverage converter error code.
enum CoverageConverterErrorCode {
  /// Indicates that the input file is not found.
  noSuchFile,

  /// Indicates that the input file is empty.
  fileIsEmpty,

  /// Indicates that the input file's format is not valid.
  invalidFileFormat,
}
