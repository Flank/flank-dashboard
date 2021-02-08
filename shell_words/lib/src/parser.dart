// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'models/parser_result.dart';

// eof is thus represented as a Dart string instead of an int in Golang.
// Dart does not have a character type so each character is a string.
const eof = '-1';

/// This is a `recursive` descent parser for our basic shellword grammar.
class Parser {
  /// Parser takes a `string` and parses out a tree of __structs__ that represent text and Expansions.
  Parser({
    this.input,
    this.quoteChars,
    this.escapeChar,
    this.quoteEscapeChars,
    this.fieldSeperators,
    this.pos,
  });
  // Input is the string to parse
  String input;

  // Characters to use for quoted strings
  List<String> quoteChars;

  // The character used for escaping
  String escapeChar;

  // The characters used for escaping quotes in quoted strings
  List<String> quoteEscapeChars;

  // Field seperators are used for splitting words
  List<String> fieldSeperators;

  // The current internal position
  int pos;

  ParserResult parse() {
    ParserResult result;
    result = ParserResult(words: []);
    var word = StringBuffer();

    while (true) {
      // Read until we encounter a delimiter character
      var scanned = scanUntil(isDelimiter);

      if (scanned.isNotEmpty) {
        word.write(scanned);
      }

      // Read the character that caused the scan to stop
      var nextcharacter = nextCharacter();
      if (nextcharacter == eof) {
        break;
      }

      // Handle quotes
      if (isQuote(nextcharacter)) {
        var quote = scanQuote(nextcharacter);
        if (quote['error'] != null) {
          return ParserResult(words: null, error: quote['error']);
        }
        // Write to the buffer
        word.write(quote['result']);
      }
      // Handle escaped characters
      else if (nextcharacter == escapeChar) {
        var escaped = nextCharacter();
        if (escaped != null && escaped != eof) {
          word.write(escaped);
        }
      }

      // Handle field seperators
      else if (isFieldSeperator(nextcharacter)) {
        if (word != null && word.isNotEmpty) {
          result.words.add(word.toString());
          word.clear();
        }
      } else {
        result.error = 'Unhandled character $nextcharacter at pos $pos';
        result.words = null;
        return result;
      }
    }
    if (word.isNotEmpty) {
      result.words.add(word.toString());
      word.clear();
    }
    return result;
  }

  Map<String, String> scanQuote(String delim) {
    var quote = StringBuffer();
    while (true) {
      String r;
      r = nextCharacter();
      if (r == eof) {
        return {
          'result': null,
          'error':
              'Expected closing quote $delim at offset ${pos - 1}, got EOF',
        };
      }
      // Check for escaped characters
      if (quoteEscapeChars.contains(r)) {
        // Handle the case where our escape char is our delimiter (e.g "")
        if (r != delim || peekCharacter() == delim) {
          var escaped = nextCharacter();
          if (escaped != eof) {
            quote.write(escaped);
          }
          continue;
        }
      }
      if (r == delim) {
        break;
      }
      quote.write(r);
    }
    return {
      'result': quote.toString(),
      'error': null,
    };
  }

  bool isQuote(String r) => quoteChars.contains(r);

  bool isQuoteEscape(String r) => quoteEscapeChars.contains(r);

  bool isFieldSeperator(String r) => fieldSeperators.contains(r);

  bool isDelimiter(String character) {
    return escapeChar == character ||
        isQuote(character) ||
        isFieldSeperator(character);
  }

  /// Scans the `String` based of the passed [Function].
  String scanUntil(Function isDelimiter) {
    var start = pos;
    String currentletter;
    while (pos < input.length) {
      currentletter = input[pos];

      if (isDelimiter(currentletter)) {
        break;
      }
      pos += 1;
    }

    return input.substring(start, pos);
  }

  String nextCharacter() {
    if (pos >= input.length) {
      return eof;
    }

    var nextCharacter = input[pos];
    pos += 1;
    return nextCharacter;
  }

  String peekCharacter() {
    if (pos >= input.length) {
      return eof;
    }

    var nextCharacter = input[pos];
    return nextCharacter;
  }
}
