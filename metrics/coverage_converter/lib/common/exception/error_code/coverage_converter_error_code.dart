/// Enum that represents the coverage converter error code.
enum CoverageConverterErrorCode {
  /// Indicates that the file is not found.
  noSuchFile,

  /// Indicates that the input file is empty.
  fileIsEmpty,

  /// Indicates that the given file's format is not supported.
  invalidFileFormat,
}
