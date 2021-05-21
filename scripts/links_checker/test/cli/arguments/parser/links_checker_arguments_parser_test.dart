// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:args/args.dart';
import 'package:links_checker/cli/arguments/parser/links_checker_arguments_parser.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group("LinksCheckerArgumentsParser", () {
    const argumentsParser = LinksCheckerArgumentsParser();
    final argResultsMock = _ArgResultsMock();
    const paths = ['file1', 'path/to/file2'];
    final pathsString = paths.join(' ');

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
      ".parseArgResults() throws an ArgumentError if the given paths argument is null",
      () {
        when(argResultsMock['paths']).thenReturn(null);

        expect(
          () => argumentsParser.parseArgResults(argResultsMock),
          throwsArgumentError,
        );
      },
    );

    test(
      ".parseArgResults() creates a links checker arguments instance with ignorePaths equal to null if the given ignore paths argument is null",
      () {
        when(argResultsMock['paths']).thenReturn(pathsString);
        when(argResultsMock['ignore-paths']).thenReturn(null);

        final arguments = argumentsParser.parseArgResults(argResultsMock);

        expect(arguments.ignorePaths, isNull);
      },
    );

    test(
      ".parseArgResults() creates a links checker arguments instance with paths equal to an empty list if the given paths argument equals an empty string",
      () {
        when(argResultsMock['paths']).thenReturn('');

        final arguments = argumentsParser.parseArgResults(argResultsMock);

        expect(arguments.paths, equals([]));
      },
    );

    test(
      ".parseArgResults() creates a links checker arguments instance with ignorePaths equal to an empty list if the given ignore paths argument equals an empty string",
      () {
        when(argResultsMock['paths']).thenReturn(pathsString);
        when(argResultsMock['ignore-paths']).thenReturn('');

        final arguments = argumentsParser.parseArgResults(argResultsMock);

        expect(arguments.ignorePaths, equals([]));
      },
    );

    test(
      ".parseArgResults() parses the given space-separated string of paths to the list of paths",
      () {
        when(argResultsMock['paths']).thenReturn(pathsString);

        final arguments = argumentsParser.parseArgResults(argResultsMock);

        expect(arguments.paths, equals(paths));
      },
    );

    test(
      ".parseArgResults() parses the given space-separated string of ignore paths to the list of ignore paths",
      () {
        when(argResultsMock['ignore-paths']).thenReturn(pathsString);

        final arguments = argumentsParser.parseArgResults(argResultsMock);

        expect(arguments.ignorePaths, equals(paths));
      },
    );
  });
}

class _ArgResultsMock extends Mock implements ArgResults {}
