import 'dart:io' show Platform;
import 'posix.dart';
import 'models/parser_result.dart';
import 'batch.dart';

// Split chooses between SplitPosix and SplitBatch based on your operating system
ParserResult split(String line) {
  ParserResult result;
  if (Platform.isWindows) {
    result = splitBatch(line);
  } else {
    result = splitPosix(line);
  }
  return result;
}
