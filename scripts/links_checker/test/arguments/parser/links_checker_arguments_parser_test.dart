// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:args/args.dart';
import 'package:links_checker/arguments/parser/links_checker_arguments_parser.dart';
import 'package:test/test.dart';

void main() {
  group("LinksCheckerArgumentsParser", () {
    const argumentsParser = LinksCheckerArgumentsParser();

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

        expect(options, contains(LinksCheckerArgumentsParser.ignore));
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
      ".configureArguments() configures the given arg parser to have an empty string as a default ignore argument value",
      () {
        final parser = ArgParser();

        argumentsParser.configureArguments(parser);

        final options = parser.options;
        final ignoreOption = options[LinksCheckerArgumentsParser.ignore];

        expect(ignoreOption.defaultsTo, equals(''));
      },
    );

    test(
      ".parseArgResults() creates a links checker arguments instance with paths equal to an empty list if the given paths argument equals an empty string",
      () {
        const options = ['--paths', ''];

        final parser = ArgParser();

        argumentsParser.configureArguments(parser);

        final argResults = parser.parse(options);
        final arguments = argumentsParser.parseArgResults(argResults);

        expect(arguments.paths, equals([]));
      },
    );

    test(
      ".parseArgResults() creates a links checker arguments instance with ignorePaths equal to an empty list if the given ignore argument equals an empty string",
      () {
        const options = ['--ignore', ''];

        final parser = ArgParser();

        argumentsParser.configureArguments(parser);

        final argResults = parser.parse(options);
        final arguments = argumentsParser.parseArgResults(argResults);

        expect(arguments.ignorePaths, equals([]));
      },
    );

    test(
      ".parseArgResults() creates a links checker arguments instance with paths equals to an empty list",
      () {
        final parser = ArgParser();

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

        argumentsParser.configureArguments(parser);

        final argResults = parser.parse([]);
        final arguments = argumentsParser.parseArgResults(argResults);

        expect(arguments.ignorePaths, equals([]));
      },
    );
  });
}
