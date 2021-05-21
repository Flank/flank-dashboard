// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:links_checker/checker/links_checker.dart';
import 'package:links_checker/cli/arguments/models/links_checker_arguments.dart';
import 'package:links_checker/cli/arguments/parser/links_checker_arguments_parser.dart';
import 'package:links_checker/cli/command/links_checker_command.dart';
import 'package:links_checker/utils/file_helper_util.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group("LinksCheckerCommand", () {
    const paths = ['file1', 'path/to/file2'];
    const repository = 'owner/repository';

    final linksCheckerArguments = LinksCheckerArguments(
      repository: repository,
      paths: paths,
      ignorePaths: [],
    );
    final argumentsParser = _LinksCheckerArgumentsParserMock();
    final fileHelperUtil = _FileHelperUtilMock();

    tearDown(() {
      reset(argumentsParser);
      reset(fileHelperUtil);
    });

    test(
      ".description contains a non-empty description of a command",
      () {
        final command = LinksCheckerCommand();

        expect(command.description, isNotEmpty);
      },
    );

    test(
      ".name contains the validate command name",
      () {
        final command = LinksCheckerCommand();

        expect(command.name, equals('validate'));
      },
    );

    test(
      "configures arguments using the given argument parser's .configureArguments()",
      () {
        LinksCheckerCommand(argumentsParser: argumentsParser);

        verify(argumentsParser.configureArguments(any)).called(1);
      },
    );

    test(
      ".run() uses the given argument parser's .parseArgResults() to parse arguments",
      () {
        when(
          argumentsParser.parseArgResults(any),
        ).thenReturn(linksCheckerArguments);

        final command = LinksCheckerCommand(argumentsParser: argumentsParser);
        command.run();

        verify(argumentsParser.parseArgResults(any)).called(1);
      },
    );

    test(
      ".run() uses the given file helper util's .getFiles() to get files from paths",
      () {
        when(fileHelperUtil.getFiles(paths)).thenReturn([]);
        when(
          argumentsParser.parseArgResults(any),
        ).thenReturn(linksCheckerArguments);

        final command = LinksCheckerCommand(
          fileHelperUtil: fileHelperUtil,
          argumentsParser: argumentsParser,
        );
        command.run();

        verify(fileHelperUtil.getFiles(paths)).called(1);
      },
    );

    test(
      ".run() uses the given links checker .checkFiles() to validate files for a valid links",
      () {
        final linksChecker = _LinksCheckerMock();

        when(linksChecker.checkFiles([])).thenReturn(null);
        when(
          argumentsParser.parseArgResults(any),
        ).thenReturn(linksCheckerArguments);

        final command = LinksCheckerCommand(
          linksChecker: linksChecker,
          argumentsParser: argumentsParser,
        );
        command.run();

        verify(linksChecker.checkFiles([])).called(equals(1));
      },
    );

    test(
      ".run() excludes files from the analyze based on the given ignore parameter",
      () {
        const ignorePath = 'path/';
        const repository = 'owner/repository';
        final paths = ['file1', '${ignorePath}to/file2'];
        final ignore = [ignorePath];
        final arguments = LinksCheckerArguments(
          repository: repository,
          paths: paths,
          ignorePaths: ignore,
        );

        when(fileHelperUtil.getFiles(any)).thenReturn([]);
        when(argumentsParser.parseArgResults(any)).thenReturn(arguments);

        final command = LinksCheckerCommand(
          fileHelperUtil: fileHelperUtil,
          argumentsParser: argumentsParser,
        );
        command.run();

        verifyNever(
          fileHelperUtil.getFiles(argThat(contains('path/to/file2'))),
        );
      },
    );
  });
}

class _FileHelperUtilMock extends Mock implements FileHelperUtil {}

class _LinksCheckerMock extends Mock implements LinksChecker {}

class _LinksCheckerArgumentsParserMock extends Mock
    implements LinksCheckerArgumentsParser {}
