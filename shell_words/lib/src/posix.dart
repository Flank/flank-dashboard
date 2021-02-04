// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:unicode/unicode.dart' as unicode;
import 'parser.dart';
import 'models/parser_result.dart';

const posixSpecialChars = [
  '!',
  '"',
  '#',
  '\$',
  '&',
  '\'',
  '(',
  ')',
  '*',
  ',',
  ';',
  '<',
  '=',
  '>',
  '?',
  '[',
  ']',
  r'\',
  '^',
  '`',
  '{',
  '}',
  '|',
  '~'
];
const posixEscape = '\\';

const quoteChars = ['\'', '"'];
const escapeChar = posixEscape;
const quoteEscapeChars = [posixEscape];
const fieldSeperators = ['\n', '\t', ' '];

/// SplitPosix splits a command `string` into words like a posix shell would.
ParserResult splitPosix(String line, [abc]) {
  var p = Parser(
      input: line,
      quoteChars: quoteChars,
      escapeChar: posixEscape,
      quoteEscapeChars: quoteEscapeChars,
      fieldSeperators: fieldSeperators,
      pos: 0);
  return p.parse();
}

/// QuotePosix returns the `string` such that a posix shell would parse it as a single word.
String quotePosix(String s) {
  var builder = StringBuffer();
  var needsQuotes = false;

  s.runes.forEach((int rune) {
    var c = String.fromCharCode(rune);
    if (posixSpecialChars.contains(c)) {
      builder.write(posixEscape + c);
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
