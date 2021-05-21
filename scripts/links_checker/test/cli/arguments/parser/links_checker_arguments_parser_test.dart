// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:args/args.dart';
import 'package:links_checker/cli/arguments/parser/links_checker_arguments_parser.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group("LinksCheckerArgumentsParser", () {
    const pathsArgName = 'paths';
    const ignorePathsArgName = 'ignore-paths';
    const repositoryArgName = 'repository';
    const paths = ['file1', 'path/to/file2'];
    const repository = 'owner/repository';
    const argumentsParser = LinksCheckerArgumentsParser();

    final argResultsMock = _ArgResultsMock();
    final pathsString = paths.join(' ');

    tearDown(() {
      reset(argResultsMock);
    });

    test(
      ".configureArguments() configures the given arg parser to accept the repository option",
      () {
        final parser = ArgParser();

        argumentsParser.configureArguments(parser);

        final options = parser.options;

        expect(options, contains(LinksCheckerArgumentsParser.repository));
      },
    );

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
      ".parseArgResults() throws an ArgumentError if the given repository argument is null",
      () {
        when(argResultsMock[repositoryArgName]).thenReturn(null);
        when(argResultsMock[pathsArgName]).thenReturn(pathsString);

        expect(
          () => argumentsParser.parseArgResults(argResultsMock),
          throwsArgumentError,
        );
      },
    );

    test(
      ".parseArgResults() throws an ArgumentError if the given paths argument is null",
      () {
        when(argResultsMock[repositoryArgName]).thenReturn(repository);
        when(argResultsMock[pathsArgName]).thenReturn(null);

        expect(
          () => argumentsParser.parseArgResults(argResultsMock),
          throwsArgumentError,
        );
      },
    );

    test(
      ".parseArgResults() creates a links checker arguments instance with ignorePaths equal to null if the given ignore paths argument is null",
      () {
        when(argResultsMock[repositoryArgName]).thenReturn(repository);
        when(argResultsMock[pathsArgName]).thenReturn(pathsString);
        when(argResultsMock[ignorePathsArgName]).thenReturn(null);

        final arguments = argumentsParser.parseArgResults(argResultsMock);

        expect(arguments.ignorePaths, isNull);
      },
    );

    test(
      ".parseArgResults() creates a links checker arguments instance with paths equal to an empty list if the given paths argument equals an empty string",
      () {
        when(argResultsMock[repositoryArgName]).thenReturn(repository);
        when(argResultsMock[pathsArgName]).thenReturn('');

        final arguments = argumentsParser.parseArgResults(argResultsMock);

        expect(arguments.paths, equals([]));
      },
    );

    test(
      ".parseArgResults() creates a links checker arguments instance with ignorePaths equal to an empty list if the given ignore paths argument equals an empty string",
      () {
        when(argResultsMock[repositoryArgName]).thenReturn(repository);
        when(argResultsMock[pathsArgName]).thenReturn(pathsString);
        when(argResultsMock[ignorePathsArgName]).thenReturn('');

        final arguments = argumentsParser.parseArgResults(argResultsMock);

        expect(arguments.ignorePaths, equals([]));
      },
    );

    test(
      ".parseArgResults() parses the given space-separated string of paths to the list of paths",
      () {
        when(argResultsMock[repositoryArgName]).thenReturn(repository);
        when(argResultsMock[pathsArgName]).thenReturn(pathsString);

        final arguments = argumentsParser.parseArgResults(argResultsMock);

        expect(arguments.paths, equals(paths));
      },
    );

    test(
      ".parseArgResults() parses the given space-separated string of ignore paths to the list of ignore paths",
      () {
        when(argResultsMock[repositoryArgName]).thenReturn(repository);
        when(argResultsMock[pathsArgName]).thenReturn(pathsString);
        when(argResultsMock[ignorePathsArgName]).thenReturn(pathsString);

        final arguments = argumentsParser.parseArgResults(argResultsMock);

        expect(arguments.ignorePaths, equals(paths));
      },
    );
  });
}

class _ArgResultsMock extends Mock implements ArgResults {}
