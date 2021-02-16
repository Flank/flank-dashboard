// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:args/args.dart';
import 'package:links_checker/arguments/parser/links_checker_arguments_parser.dart';
import 'package:test/test.dart';

void main() {
  group("LinksCheckerArgumentsParser", () {
    test(
      ".configureArguments() configures the given arg parser to accept the paths option",
      () {
        final parser = ArgParser();
        const argumentsParser = LinksCheckerArgumentsParser();

        argumentsParser.configureArguments(parser);

        final options = parser.options;

        expect(options, contains(LinksCheckerArgumentsParser.paths));
      },
    );

    test(
      ".configureArguments() configures the given arg parser to accept the ignore option",
      () {
        final parser = ArgParser();
        const argumentsParser = LinksCheckerArgumentsParser();

        argumentsParser.configureArguments(parser);

        final options = parser.options;

        expect(options, contains(LinksCheckerArgumentsParser.ignore));
      },
    );

    test(
      ".parseArgResults() parses the given paths option value to a links checker arguments instance with paths",
      () {
        const paths = 'file1 path/to/file2';
        const options = ['--paths', paths];

        final expected = ['file1', 'path/to/file2'];

        final parser = ArgParser();
        const argumentsParser = LinksCheckerArgumentsParser();

        argumentsParser.configureArguments(parser);

        final argResults = parser.parse(options);
        final arguments = argumentsParser.parseArgResults(argResults);

        expect(arguments.paths, equals(expected));
      },
    );

    test(
      ".parseArgResults() parses the given ignore option value to a links checker arguments instance with ignore",
      () {
        const ignore = 'path/to/ignore';
        const options = ['--ignore', ignore];

        final expected = ['path/to/ignore'];

        final parser = ArgParser();
        const argumentsParser = LinksCheckerArgumentsParser();

        argumentsParser.configureArguments(parser);

        final argResults = parser.parse(options);
        final arguments = argumentsParser.parseArgResults(argResults);

        expect(arguments.ignore, equals(expected));
      },
    );

    test(
      ".parseArgResults() creates a links checker arguments instance with paths equals to an empty list",
      () {
        final parser = ArgParser();
        const argumentsParser = LinksCheckerArgumentsParser();

        argumentsParser.configureArguments(parser);

        final argResults = parser.parse([]);
        final arguments = argumentsParser.parseArgResults(argResults);

        expect(arguments.paths, equals([]));
      },
    );

    test(
      ".parseArgResults() creates a links checker arguments instance with ignore equals to an empty list",
      () {
        final parser = ArgParser();
        const argumentsParser = LinksCheckerArgumentsParser();

        argumentsParser.configureArguments(parser);

        final argResults = parser.parse([]);
        final arguments = argumentsParser.parseArgResults(argResults);

        expect(arguments.ignore, equals([]));
      },
    );
  });
}
