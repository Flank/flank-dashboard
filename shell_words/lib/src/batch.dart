// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:unicode/unicode.dart' as unicode;
import 'parser.dart';
import 'models/parser_result.dart';

const batchSpecialChars = ['^', '&', ';', ',', '=', '%'];
const batchEscape = '^';

const quoteChars = ['\'', '"'];
const escapeChar = batchEscape;
const quoteEscapeChars = [batchEscape, '"'];
const fieldSeperators = ['\n', '\t', ' '];

/// SplitBatch splits a command `string` into words like Windows CMD.EXE would.
///
///[See] (https://ss64.com/nt/syntax-esc.html)
ParserResult splitBatch(String line) {
  var p = Parser(
      input: line,
      quoteChars: quoteChars,
      escapeChar: escapeChar,
      quoteEscapeChars: quoteEscapeChars,
      fieldSeperators: fieldSeperators,
      pos: 0);
  return p.parse();
}

/// QuoteBatch returns the `string` such that a CMD.EXE shell would parse it as a single word.
String quoteBatch(String s) {
  var builder = StringBuffer();
  var needsQuotes = false;

  s.runes.forEach((int rune) {
    var c = String.fromCharCode(rune);
    if (batchSpecialChars.contains(c)) {
      builder.write(batchEscape + c);
    } else {
      builder.write(c);
    }
    if (unicode.isSpaceSeparator(rune)) {
      needsQuotes = true;
    }
  });
  if (needsQuotes) {
    return '''"$builder"''';
  }
  return builder.toString();
}
