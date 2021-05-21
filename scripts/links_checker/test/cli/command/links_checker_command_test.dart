// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:links_checker/checker/factory/links_checker_factory.dart';
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
    final linksChecker = _LinksCheckerMock();
    final linksCheckerFactory = _LinksCheckerFactoryMock();
    final fileHelperUtil = _FileHelperUtilMock();

    final command = LinksCheckerCommand(
      linksCheckerFactory: linksCheckerFactory,
      argumentsParser: argumentsParser,
      fileHelperUtil: fileHelperUtil,
    );

    tearDown(() {
      reset(argumentsParser);
      reset(fileHelperUtil);
      reset(linksChecker);
      reset(linksCheckerFactory);
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
        when(
          linksCheckerFactory.create(repository),
        ).thenReturn(linksChecker);

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
        when(
          linksCheckerFactory.create(repository),
        ).thenReturn(linksChecker);

        command.run();

        verify(fileHelperUtil.getFiles(paths)).called(1);
      },
    );

    test(
      ".run() creates a links checker using the given links checker factory and the repository prefix",
      () {
        final expectedRepositoryPrefix = linksCheckerArguments.repository;

        when(
          argumentsParser.parseArgResults(any),
        ).thenReturn(linksCheckerArguments);
        when(
          linksCheckerFactory.create(expectedRepositoryPrefix),
        ).thenReturn(linksChecker);

        command.run();

        verify(
          linksCheckerFactory.create(expectedRepositoryPrefix),
        ).called(equals(1));
      },
    );

    test(
      ".run() checks the files returned by the file helper using the created links checker",
      () {
        final expectedFiles = [File('test')];

        when(
          argumentsParser.parseArgResults(any),
        ).thenReturn(linksCheckerArguments);
        when(fileHelperUtil.getFiles(any)).thenReturn(expectedFiles);
        when(
          linksCheckerFactory.create(repository),
        ).thenReturn(linksChecker);

        command.run();

        verify(linksChecker.checkFiles(expectedFiles)).called(equals(1));
      },
    );

    test(
      ".run() excludes files from the analyze based on the given ignore parameter",
      () {
        const ignorePath = 'path/';
        final ignore = [ignorePath];
        final paths = ['file1', '${ignorePath}to/file2'];

        final arguments = LinksCheckerArguments(
          repository: repository,
          paths: paths,
          ignorePaths: ignore,
        );

        when(fileHelperUtil.getFiles(any)).thenReturn([]);
        when(argumentsParser.parseArgResults(any)).thenReturn(arguments);
        when(
          linksCheckerFactory.create(repository),
        ).thenReturn(linksChecker);

        command.run();

        verifyNever(
          fileHelperUtil.getFiles(argThat(startsWith(ignorePath))),
        );
      },
    );
  });
}

class _FileHelperUtilMock extends Mock implements FileHelperUtil {}

class _LinksCheckerMock extends Mock implements LinksChecker {}

class _LinksCheckerFactoryMock extends Mock implements LinksCheckerFactory {}

class _LinksCheckerArgumentsParserMock extends Mock
    implements LinksCheckerArgumentsParser {}
