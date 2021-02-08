// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:links_checker/arguments/models/links_checker_arguments.dart';
import 'package:links_checker/arguments/parser/links_checker_arguments_parser.dart';
import 'package:links_checker/checker/links_checker.dart';
import 'package:links_checker/command/links_checker_command.dart';
import 'package:links_checker/utils/file_helper_util.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group("LinksCheckerCommand", () {
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
        when(argumentsParser.parseArgResults(any))
            .thenReturn(LinksCheckerArguments(paths: []));

        final command = LinksCheckerCommand(argumentsParser: argumentsParser);
        command.run();

        verify(argumentsParser.parseArgResults(any)).called(1);
      },
    );

    test(
      ".run() uses the given file helper util's .getFiles() to get files from paths",
      () {
        final paths = ['file1', 'path/to/file2'];
        when(fileHelperUtil.getFiles(paths)).thenReturn([]);
        when(argumentsParser.parseArgResults(any))
            .thenReturn(LinksCheckerArguments(paths: paths));

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
        when(argumentsParser.parseArgResults(any))
            .thenReturn(LinksCheckerArguments(paths: []));

        final command = LinksCheckerCommand(
          linksChecker: linksChecker,
          argumentsParser: argumentsParser,
        );
        command.run();

        verify(linksChecker.checkFiles([])).called(equals(1));
      },
    );
  });
}

class _FileHelperUtilMock extends Mock implements FileHelperUtil {}

class _LinksCheckerMock extends Mock implements LinksChecker {}

class _LinksCheckerArgumentsParserMock extends Mock
    implements LinksCheckerArgumentsParser {}
