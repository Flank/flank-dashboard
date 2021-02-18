// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:args/args.dart';
import 'package:links_checker/arguments/parser/links_checker_arguments_parser.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group("LinksCheckerArgumentsParser", () {
    const argumentsParser = LinksCheckerArgumentsParser();
    final argResultsMock = _ArgResultsMock();
    const paths = ['file1', 'path/to/file2'];

    setUpAll(() {
      when(argResultsMock[any]).thenReturn('');
    });

    test(
      ".configureArguments() configures the given arg parser to accept the paths option",
      () {
        final parser = ArgParser();

        argumentsParser.configureArguments(parser);

        final options = parser.options;

        expect(options, contains(LinksCheckerArgumentsParser.paths));
      },
    );

    test(
      ".configureArguments() configures the given arg parser to accept the ignore option",
      () {
        final parser = ArgParser();

        argumentsParser.configureArguments(parser);

        final options = parser.options;

        expect(options, contains(LinksCheckerArgumentsParser.ignorePaths));
      },
    );

    test(
      ".configureArguments() configures the given arg parser to have an empty string as a default paths argument value",
      () {
        final parser = ArgParser();

        argumentsParser.configureArguments(parser);

        final options = parser.options;
        final pathsOption = options[LinksCheckerArgumentsParser.paths];

        expect(pathsOption.defaultsTo, equals(''));
      },
    );

    test(
      ".parseArgResults() creates a links checker arguments instance with paths equal to an empty list if the given paths argument equals an empty string",
      () {
        final arguments = argumentsParser.parseArgResults(argResultsMock);

        expect(arguments.paths, equals([]));
      },
    );

    test(
      ".parseArgResults() creates a links checker arguments instance with ignorePaths equal to an empty list if the given ignore paths argument equals an empty string",
      () {
        final arguments = argumentsParser.parseArgResults(argResultsMock);

        expect(arguments.ignorePaths, equals([]));
      },
    );

    test(
      ".parseArgResults() correctly parses the given paths argument",
      () {
        when(argResultsMock['paths']).thenReturn(paths.join(' '));

        final arguments = argumentsParser.parseArgResults(argResultsMock);

        expect(arguments.paths, equals(paths));
      },
    );

    test(
      ".parseArgResults() correctly parses the given ignore paths argument",
      () {
        when(argResultsMock['ignore-paths']).thenReturn(paths.join(' '));

        final arguments = argumentsParser.parseArgResults(argResultsMock);

        expect(arguments.ignorePaths, equals(paths));
      },
    );
  });
}

class _ArgResultsMock extends Mock implements ArgResults {}
